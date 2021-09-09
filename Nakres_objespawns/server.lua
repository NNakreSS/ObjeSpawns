ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local perms = 
{
	"steam:11000011513da03",
	"steam:...",
	"steam:...",
	"steam:...",
}

RegisterCommand("build",function (source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
    if checkperm(identifier) then
        TriggerClientEvent("buildon",source)
    else
		msg(xPlayer.source)
    end
end)

RegisterCommand('edit', function(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
    if checkperm(identifier) then
		TriggerClientEvent("editmode",source)
    else
		msg(xPlayer.source)
    end
end)

RegisterCommand('nesnelerisil', function(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
    if checkperm(identifier) then
        TriggerClientEvent('clearall',source)
    else
		msg(xPlayer.source)
    end
end)

function checkperm(psteam)
	for i, v in pairs(perms) do
		if psteam == v then
			return true
		end
	end
	return false
end

function msg(player)
	TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = "Bunun için yetkin yok!!"},4000)	
end