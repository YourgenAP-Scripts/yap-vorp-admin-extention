local VORPwl = {}

TriggerEvent("getWhitelistTables", function(cb)
    VORPwl = cb
end)

RegisterCommand("add_perm", function(source, args, rawCommand)
    local _source = source
    local ace = IsPlayerAceAllowed(_source, "vorp.staff.AddAdmin")

    if ace then
        local targetId, newAce = tonumber(args[1]), args[2]

        if targetId then
            local _wlTable = VORPwl.getEntries()
            local steamIdent = _wlTable[targetId].GetEntry().getIdentifier()
            if newAce then
                ExecuteCommand("add_principal identifier."..steamIdent.." group".."."..newAce)
                exports.ghmattimysql:executeSync("INSERT INTO permissions (identifier, role) VALUES (@identifier, @role)",
                                    {['@identifier'] = steamIdent, ['@role']=newAce})
                for _, player in ipairs(GetPlayers()) do
                    if steamIdent == GetPlayerIdentifiers(player)[1] then
                        TriggerClientEvent("chat:addSuggestion", player, "/add_perm", "Extension command add ace permission for user.", {
                            { name = "UserId", help = 'Static user id' },
                            { name = "Role", help = 'Role name for ace perm' },
                        })
                        
                        TriggerClientEvent("chat:addSuggestion", player, "/remove_perm", "Extension command revome ace permission from user.", {
                            { name = "UserId", help = 'Static user id' },
                            { name = "Role", help = 'Role name for ace perm' },
                        })
                    end
                end
            end
        end
    end
end, false)

RegisterCommand("remove_perm", function(source, args, rawCommand)
    local _source = source
    local ace = IsPlayerAceAllowed(_source, "vorp.staff.AddAdmin")

    if ace then
        local targetId, oldAce = tonumber(args[1]), args[2]

        if targetId then
            local _wlTable = VORPwl.getEntries()
            local steamIdent = _wlTable[targetId].GetEntry().getIdentifier()
            if oldAce then
                ExecuteCommand("remove_principal identifier."..steamIdent.." group".."."..oldAce)
                exports.ghmattimysql:executeSync("DELETE FROM permissions WHERE `identifier`=@identifier", {['@identifier'] = steamIdent})
                for _, player in ipairs(GetPlayers()) do
                    if steamIdent == GetPlayerIdentifiers(player)[1] then
                        TriggerClientEvent("chat:removeSuggestion", player, "/add_perm")

                        TriggerClientEvent("chat:removeSuggestion", player, "/remove_perm")
                    end
                end
            end
        end
    end
end, false)

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local retvalList = exports.ghmattimysql:executeSync("SELECT * FROM permissions")
    if #retvalList>0 then
        for k,v in pairs(retvalList) do
            ExecuteCommand("add_principal identifier."..v["identifier"].." group".."."..v["role"])
        end
    end
end)

AddEventHandler("playerJoining", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local _source = source
    local ace = IsPlayerAceAllowed(_source, "vorp.staff.AddAdmin")
    if ace then
        TriggerClientEvent("chat:addSuggestion", _source, "/add_perm", "Extension command add ace permission for user.", {
            { name = "UserId", help = 'Static user id' },
            { name = "Role", help = 'Role name for ace perm' },
        })

        TriggerClientEvent("chat:addSuggestion", _source, "/remove_perm", "Extension command revome ace permission from user.", {
            { name = "UserId", help = 'Static user id' },
            { name = "Role", help = 'Role name for ace perm' },
        })
    else
        TriggerClientEvent("chat:removeSuggestion", _source, "/add_perm")

        TriggerClientEvent("chat:removeSuggestion", _source, "/remove_perm")
    end
end)