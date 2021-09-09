ESX = nil
local display = false
local objeSet = false
local obje = nil
local objeLocked = false
local editMode = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("buildon")
AddEventHandler("buildon",function ()
	SetDisplay(not display)
end)

RegisterNetEvent("clearall")
AddEventHandler("clearall", function()
	local coord = GetEntityCoords(PlayerPedId())
	FreezeEntityPosition(obje, false)
	objeSet = false
	ClearAreaOfEverything(coord.x, coord.y, coord.z, 20.0, 0, 0, 0, 0)
	end)


RegisterNetEvent("editmode")
AddEventHandler("editmode",function ()
	editMode = not editMode
end)

RegisterNUICallback("objectspawn", function(data)
		local playerCoords = GetEntityCoords(PlayerPedId())
		obje = CreateObject(data.objname, playerCoords.x + 1.25, playerCoords.y, playerCoords.z -1, true, true, true)
		print(obje)
		ESX.ShowNotification('Obje çıkartıldı')
		FreezeEntityPosition(obje, true)
		SetEntityAsMissionEntity(obje,true,true)
		objeSet = true
		editMode = true
		objeLocked = false
		SetDisplay(not display)
end)

RegisterNUICallback("error", function(data)
	exports["mythic_notify"]:SendAlert("error", data.error, 5000)
end)

RegisterNUICallback("deleteobj", function(data)
	local playerPed = PlayerPedId()
    local obbje = GetHashKey(data.objname)
	local playercoords = GetEntityCoords(playerPed)
    if DoesObjectOfTypeExistAtCoords(playercoords, 4.5, obbje, true) then
		FreezeEntityPosition(obbje,false)
		-- ESX.ShowNotification('yakın')
        local obj = GetClosestObjectOfType(playercoords, 4.5, obbje, false, false, false)
        DeleteObject(obj)
		ESX.ShowNotification('Obje silindi')
	else
		ESX.ShowNotification('Yakında obje yok')
    end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
	editMode = false
end)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Citizen.Wait(500)
	end
	while true do
		local sleep = 1500
		if objeSet and editMode then
			sleep  = 1
			local playerPed = PlayerPedId()
			local playercoords = GetEntityCoords(playerPed)
			local objecoords = GetEntityCoords(obje)
			local Waiting = 1500
			while #(objecoords - playercoords) < 4.0 and editMode and  not objeLocked do
				Waiting = 1
				ESX.ShowHelpNotification('~INPUT_VEH_FLY_PITCH_UD~ : Yukarı & Aşağı ~n~~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ ~INPUT_CELLPHONE_DOWN~ : Yönlendir ~n~~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ : Yön ~n~~INPUT_WEAPON_WHEEL_NEXT~ ~INPUT_WEAPON_WHEEL_PREV~ : Rotasyon ~n~~INPUT_FRONTEND_RDOWN~ : Objeyi Kilitle', true)
				if IsControlPressed(0, 111) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, 0.0, 0.05))
				end
				if IsControlPressed(0, 110) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, 0.0, -0.05))
				end
				if IsControlPressed(0, 172) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, 0.05, 0.0))
				end
				if IsControlPressed(0, 173) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, -0.05, 0.0))
				end
				if IsControlPressed(0, 174) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, -0.05, 0.0, 0.0))
				end
				if IsControlPressed(0, 175) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.05, 0.0, 0.0))
				end
				if IsControlPressed(0, 117) then
					SetEntityHeading(obje, GetEntityHeading(obje) + 0.5)
				end
				if IsControlPressed(0, 118) then
					SetEntityHeading(obje, GetEntityHeading(obje) - 0.5)
				end
				if IsControlPressed(0, 14) then
					SetEntityRotation(obje, GetEntityRotation(obje) - 0.5)
				end
				if IsControlPressed(0, 15) then
					SetEntityRotation(obje, GetEntityRotation(obje) + 0.5)
				end
				if IsControlJustReleased(0, 191) then
					objeLocked = true
					editMode = not editMode
					SetDisplay(not display)
					FreezeEntityPosition(obje, true)
				end
				Citizen.Wait(Waiting)
			end
			 playerPed = PlayerPedId()
			 playercoords = GetEntityCoords(playerPed)
			 objecoords = GetEntityCoords(obje)
			while #(objecoords - playercoords) < 2.0 and editMode and objeLocked do
				Citizen.Wait(0)
				ESX.ShowHelpNotification('~INPUT_FRONTEND_RDOWN~ : Obje kilidini aç', true)
				if IsControlJustReleased(0, 191) then
					objeLocked = false
					FreezeEntityPosition(obje, true)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)
