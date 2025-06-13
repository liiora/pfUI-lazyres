pfUI:RegisterModule("lazyres", function()
    local msg_pref = GetAddOnMetadata("pfui-lazyres", "Title") .. "|r: "
    local config

    pfUI.lazyres = CreateFrame("Frame", "pfLazyres", UIParent)
    pfUI.lazyres:RegisterEvent("VARIABLES_LOADED")

    function pfUI.lazyres:Load()
        config = C.lazyres
    end

    local classOrder = {"SHAMAN", "PALADIN", "PRIEST", "DRUID", "MAGE", "HUNTER", "WARLOCK", "WARRIOR", "ROGUE"}
    local classcolors = { DRUID="FF7D0A", HUNTER="ABD473", MAGE="69CCF0", PALADIN="F58CBA", PRIEST="FFFFFF", ROGUE="FFF569", SHAMAN="2459FF", WARLOCK="9482C9", WARRIOR="C79C6E" }
    local _, playerClass = UnitClass("player")
    local resSpell
    if playerClass == "PRIEST" then
        resSpell = "Resurrection"
    elseif playerClass == "SHAMAN" then
        resSpell = "Ancestral Spirit"
    elseif playerClass == "PALADIN" then
        resSpell = "Redemption"
    else
        DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "No resurrection spell found. Exiting addon ...")
        return
    end

    local function Log(msg)
        if config.notification == "1" then
            DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. msg)
        end
    end

    local function IsInParty() return GetNumRaidMembers() == 0 and GetNumPartyMembers() > 0 end

    _G.SLASH_LAZYRES1 = "/pflr"
    function _G.SlashCmdList.LAZYRES()
        CastSpellByName(resSpell)

        local numMembers = IsInParty() and GetNumPartyMembers() or GetNumRaidMembers()
        local unitPrefix = IsInParty() and "party" or "raid"
        for cId=1, table.getn(classOrder) do
            for mId=1, numMembers do
                local unitId = unitPrefix..mId
                local _, unitClass = UnitClass(unitId)
                if unitClass == classOrder[cId]
                and UnitIsDead(unitId)
                and not UnitIsGhost(unitId)
                and not pfUI.api.libpredict:UnitHasIncomingResurrection(unitId)
                and SpellIsTargeting()
                and SpellCanTargetUnit(unitId) then
                    SpellTargetUnit(unitId)
                    Log("resurrecting \124cFF"..classcolors[classOrder[cId]].."\124Hitem:19:0:0:0:0:0 :0: \124h"..UnitName(unitId).."\124h\124r")
                    return
                end
            end
        end

        Log("select target to resurrecting")
    end

    pfUI.lazyres:SetScript("OnEvent", pfUI.lazyres.Load)
end)
