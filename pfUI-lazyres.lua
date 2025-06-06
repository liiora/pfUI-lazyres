pfUI:RegisterModule("lazyres", function ()

    local msg_pref = GetAddOnMetadata("pfui-lazyres", "Title") .. "|r: "
    local config

    pfUI.lazyres = CreateFrame("Frame", "pfLazyres", UIParent)
    pfUI.lazyres:RegisterEvent("VARIABLES_LOADED")

    function pfUI.lazyres:Load()
        config = C.lazyres
    end


    local classOrder = {"SHAMAN", "PALADIN", "PRIEST", "DRUID", "MAGE", "HUNTER", "WARLOCK", "WARRIOR", "ROGUE"};
    local classcolors = { DRUID="FF7D0A", HUNTER="ABD473", MAGE="69CCF0", PALADIN="F58CBA", PRIEST="FFFFFF", ROGUE="FFF569", SHAMAN="2459FF", WARLOCK="9482C9", WARRIOR="C79C6E" }
    local _, playerClass = UnitClass("player")
    local resSpell
    if playerClass == "PRIEST" then
        resSpell = "Resurrection"
    elseif playerClass == "SHAMAN" then
        resSpell = "Ancestral Spirit"
    else
        resSpell = "Redemption"
    end
    local function SlashHandler(msg)
        local isRessing = false
        CastSpellByName(resSpell);
        for c=1, table.getn(classOrder) do
            for r=1, GetNumRaidMembers() do
                local raidId = "raid"..r;

                local _, raidClass = UnitClass(raidId);

                if UnitIsDead(raidId)
                    and raidClass == classOrder[c]
                    and not UnitIsGhost(raidId)
                    and not pfUI.api.libpredict:UnitHasIncomingResurrection(raidId)
                    and SpellIsTargeting()
                    and SpellCanTargetUnit(raidId) then

                        isRessing = true
                        SpellTargetUnit(raidId)

                        if config.notification == "1" then
                            DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "resurrecting \124cFF"..classcolors[classOrder[c]].."\124Hitem:19:0:0:0:0:0 :0: \124h"..UnitName(raidId).."\124h\124r");
                        end
                end
            end
        end

        if not isRessing and config.notification == "1" then
            DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. " select target to ress");
        end
    end

    _G.SLASH_LAZYRES1 = "/pflr"
    _G.SlashCmdList.LAZYRES = SlashHandler

    pfUI.lazyres:SetScript("OnEvent", pfUI.lazyres.Load)
end)
