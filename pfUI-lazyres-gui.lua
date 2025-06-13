-- load pfUI environment
setfenv(1, pfUI:GetEnvironment())

function pfUI.lazyres:LoadGui()
  if not pfUI.gui then return end
    local CreateConfig = pfUI.gui.CreateConfig
    local CreateGUIEntry = pfUI.gui.CreateGUIEntry
    local U = pfUI.gui.UpdaterFunctions

    CreateGUIEntry(T["Thirdparty"], GetAddOnMetadata("pfUI-lazyres", "X-LocalName"), function()
        CreateConfig(U["lazyres"], T["Show Notifcations"], C.lazyres, "notification", "checkbox")

        CreateConfig(nil, T["Version"] .. ": " .. GetAddOnMetadata("pfUI-lazyres", "Version"), nil, nil, "header")
        CreateConfig(U["lazyres"], T["Website"], nil, nil, "button", function()
            pfUI.chat.urlcopy.CopyText("https://github.com/liiora/pfUI-lazyres")
        end)
    end)
end

pfUI.lazyres:LoadGui()
