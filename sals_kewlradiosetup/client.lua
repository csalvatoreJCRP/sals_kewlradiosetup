local QBCore = exports['qb-core']:GetCoreObject()

-- Function to open the main radio menu
function OpenRadioMenu()
    QBCore.Functions.TriggerCallback('radio:getData', function(data)
        local currentRadioID = data and data.radioID or "Not Set"
        local currentCodePlug = data and data.codePlug or "Not Set"

        local menuItems = {
            {
                header = "Radio Menu",
                isMenuHeader = true
            },
            {
                header = "Set Radio ID",
                txt = "Current: " .. currentRadioID,
                params = {
                    event = "radio:setRadioIDPrompt"
                }
            },
            {
                header = "Set CodePlug",
                txt = "Current: " .. currentCodePlug,
                params = {
                    event = "radio:setCodePlugPrompt"
                }
            },
            {
                header = "Volume Up",
                txt = "Increase radio volume",
                params = {
                    event = "radio:volumeUp"
                }
            },
            {
                header = "Volume Down",
                txt = "Decrease radio volume",
                params = {
                    event = "radio:volumeDown"
                }
            },
            {
                header = "Channel Up",
                txt = "Switch to the next channel",
                params = {
                    event = "radio:channelUp"
                }
            },
            {
                header = "Channel Down",
                txt = "Switch to the previous channel",
                params = {
                    event = "radio:channelDown"
                }
            },
            {
                header = "Radio View Toggle",
                txt = "Toggle Radio View",
                params = {
                    event = "radio:toggleView"
                }
            },
            {
                header = "Radio Power Cycle",
                txt = "Cycle Radio Power",
                params = {
                    event = "radio:powerCycle"
                }
            },
            {
                header = "Radio Focus",
                txt = "Focus on Radio",
                params = {
                    event = "radio:focusRadio"
                }
            },
            {
                header = "Change Battery",
                txt = "Replace your battery",
                params = {
                    event = "radio:changeBattery"
                }
            },

            {
                header = "Close Menu",
                txt = "",
                params = {
                    event = "radio:closeMenu"
                }
            }
        }

        -- Open the menu with the current data
        exports['qb-menu']:openMenu(menuItems)
    end)
end

-- Event: Prompt to set Radio ID
RegisterNetEvent('radio:setRadioIDPrompt', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Set Radio ID",
        submitText = "Set",
        inputs = {
            {
                type = "text",
                isRequired = true,
                text = "Enter Radio ID",
                name = "radio_id"
            }
        }
    })

    if dialog then
        local radioID = dialog.radio_id
        if radioID and radioID ~= "" then
            TriggerServerEvent('radio:setRadioID', radioID)
            QBCore.Functions.Notify("Radio ID set to: " .. radioID, "success")
        else
            QBCore.Functions.Notify("Invalid Radio ID.", "error")
        end
    else
        QBCore.Functions.Notify("Radio ID input canceled.", "error")
    end

    -- Reopen the main menu
    OpenRadioMenu()
end)

-- Event: Open menu to set CodePlug
RegisterNetEvent('radio:setCodePlugPrompt', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local playerJob = playerData.job.name

    local codePlugMenu = {}

    -- Filter CodePlugs based on the player's job
    for _, plug in pairs(Config.CodePlugs) do
        if IsJobAllowedForCodePlug(playerJob, plug.allowedJobs) then
            table.insert(codePlugMenu, {
                header = plug.label,
                txt = "Select this CodePlug",
                params = {
                    event = "radio:selectCodePlug",
                    args = {
                        value = plug.value,
                        label = plug.label
                    }
                }
            })
        end
    end

    -- Add a Cancel option if there are valid CodePlugs
    if #codePlugMenu > 0 then
        table.insert(codePlugMenu, {
            header = "Cancel",
            txt = "Go back to the main menu",
            params = {
                event = "radio:closeMenu"
            }
        })

        -- Open the CodePlug menu
        exports['qb-menu']:openMenu(codePlugMenu)
    else
        QBCore.Functions.Notify("No CodePlugs available for your job.", "error")
        OpenRadioMenu() -- Return to the main menu
    end
end)

-- Event: Select a CodePlug
RegisterNetEvent('radio:selectCodePlug', function(data)
    if data and data.value then
        TriggerServerEvent('radio:setCodePlug', data.value)
        QBCore.Functions.Notify("CodePlug set to: " .. data.label, "success")
    else
        QBCore.Functions.Notify("Failed to set CodePlug.", "error")
    end

    -- Reopen the main menu
    OpenRadioMenu()
end)

-- Event: Change Battery
RegisterNetEvent('radio:changeBattery', function()
    ExecuteCommand("change_battery")
    QBCore.Functions.Notify("Replaced your battery.", "success")
    OpenRadioMenu() -- Reopen the main menu
end)

-- Event: Volume Up
RegisterNetEvent('radio:volumeUp', function()
    ExecuteCommand("volume_up")
    QBCore.Functions.Notify("Increased radio volume.", "success")
    OpenRadioMenu() -- Reopen the main menu
end)

-- Event: Volume Down
RegisterNetEvent('radio:volumeDown', function()
    ExecuteCommand("volume_down")
    QBCore.Functions.Notify("Decreased radio volume.", "success")
    OpenRadioMenu() -- Reopen the main menu
end)

-- Event: Channel Up
RegisterNetEvent('radio:channelUp', function()
    ExecuteCommand("channel_up")
    QBCore.Functions.Notify("Switched to the next channel.", "success")
    OpenRadioMenu() -- Reopen the main menu
end)

-- Event: Channel Down
RegisterNetEvent('radio:channelDown', function()
    ExecuteCommand("channel_down")
    QBCore.Functions.Notify("Switched to the previous channel.", "success")
    OpenRadioMenu() -- Reopen the main menu
end)

-- Event: Toggle Radio View
RegisterNetEvent('radio:toggleView', function()
    ExecuteCommand("toggle_radio")
    QBCore.Functions.Notify("Toggled Radio View.", "success")
    OpenRadioMenu() -- Reopen the main menu
end)

-- Event: Power Cycle Radio
RegisterNetEvent('radio:powerCycle', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local radioID = playerData.metadata["radio_id"]
    local codePlug = playerData.metadata["code_plug"]

    if radioID and radioID ~= "" and codePlug and codePlug ~= "" then
        radioID = string.upper(radioID)
        codePlug = string.lower(codePlug)
        ExecuteCommand("set_rid " .. radioID)
        ExecuteCommand("set_codeplug " .. codePlug)
        ExecuteCommand("power_toggle")
        QBCore.Functions.Notify("Power cycled the radio and set Radio ID to: " .. radioID, "success")
    else
        QBCore.Functions.Notify("You must set both Radio ID and CodePlug first.", "error")
    end

    -- Reopen the main menu
    OpenRadioMenu()
end)

-- Event: Focus Radio
RegisterNetEvent('radio:focusRadio', function()
    ExecuteCommand("toggle_radio_focus")
    QBCore.Functions.Notify("Focused on the radio.", "success")
    OpenRadioMenu() -- Reopen the main menu
end)

-- Event: Close Menu
RegisterNetEvent('radio:closeMenu', function()
    exports['qb-menu']:closeMenu()
end)

-- Command to open the menu
RegisterCommand(Config.MenuCommand, function()
    OpenRadioMenu()
end)

-- Helper function to check if a job is allowed for a CodePlug
function IsJobAllowedForCodePlug(playerJob, allowedJobs)
    for _, job in pairs(allowedJobs) do
        if playerJob == job then
            return true
        end
    end
    return false
end
