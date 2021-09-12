local approved =
{
	"steam:11000011513da03",
}

RegisterCommand("build",function (source)
	local identifier = GetPlayerIdentifiers(source)[1]
	-- local xPlayer = ESX.GetPlayerFromId(source) 
    if checkperm(identifier) then
        TriggerClientEvent("buildon",source)
    else
		-- msg(xPlayer.source)
		msg(source)
    end
end)

RegisterCommand('edit', function(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	-- local xPlayer = ESX.GetPlayerFromId(source)
    if checkperm(identifier) then
		TriggerClientEvent("editmode",source)
    else
		-- msg(xPlayer.source)
		msg(source)
    end
end)

RegisterCommand('nesnelerisil', function(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	-- local xPlayer = ESX.GetPlayerFromId(source)
    if checkperm(identifier) then
        TriggerClientEvent('clearall',source)
    else
		-- msg(xPlayer.source)
		msg(source)
    end
end)

function checkperm(psteam)
	for i, v in pairs(approved) do
		if psteam == v then
			return true
		end
	end
	return false
end

function msg(player) --Your notify trigger
	TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = "Bunun için yetkin yok!!"},4000)	
end
