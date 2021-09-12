local display = false
local objeSet = false
local obje = nil
local objeLocked = false
local editMode = false
-- local deneme = false
local openhelp = false

function msg(text,type) --Your notfy trigger or exports
	exports["mythic_notify"]:SendAlert(type, text, 5000)
end

RegisterNetEvent("buildon")
AddEventHandler("buildon",function ()
	SetDisplay(not display)
	-- deneme = true
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
	local playerCoords = GetEntityCoords(PlayerPedId()) --If you want it to spawn in the direction you are looking at, comment it and open the other lines. / Baktığınız yöne spawn olmasını isterseniz bunu yoruma alıp diğer satırları açın
	obje = CreateObject(data.objname, playerCoords.x + 1.25, playerCoords.y, playerCoords.z, false, false, false) -->  ""     ""           ""
		-- local hit, coords, entity = RayCastGamePlayCamera(1000.0) -- If you want it to spawn in the direction you are looking at, open this and the comments below. / Baktığınız yöne spawnlamasını isterseniz bu ve alttaki yorum satırlarını açın.
		-- obje = CreateObject(data.objname, coords.x, coords.y, coords.z, false, false, false)
		-- ESX.ShowNotification('Obje çıkartıldı')
		msg("Obje çıkartıldı","success")
		FreezeEntityPosition(obje, true)
		objeSet = true
		editMode = true
		objeLocked = false
		SetDisplay(not display)
end)

RegisterNUICallback("error", function(data)
	-- exports["mythic_notify"]:SendAlert("error", data.error, 5000)
	msg(data.error,"error")
end)

RegisterNUICallback("deleteobj", function(data)
	local playerPed = PlayerPedId()
    local obbje = GetHashKey(data.objname)
	local playercoords = GetEntityCoords(playerPed)
    if DoesObjectOfTypeExistAtCoords(playercoords, 1.5, obbje, true) then
		FreezeEntityPosition(obbje,false)
		-- ESX.ShowNotification('yakın')
        local obj = GetClosestObjectOfType(playercoords, 1.5, obbje, false, false, false)
        DeleteObject(obj)
		-- ESX.ShowNotification('Obje silindi')
	msg("Obje silindi","successs")
	else
		-- ESX.ShowNotification('Yakında obje yok')
	msg("Yakında obje yok","error")
    end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
	editMode = false
end)

Citizen.CreateThread(function()
	local helpntf = false
	while not NetworkIsSessionStarted() do
		Citizen.Wait(500)
	end
	while true do
		local sleep = 1500
		helpntf = false
		if objeSet and editMode then
			sleep  = 1
			local playerPed = PlayerPedId()
			local playercoords = GetEntityCoords(playerPed)
			local objecoords = GetEntityCoords(obje)
			local Waiting = 1500
			while #(objecoords - playercoords) < 4.0 and editMode and  not objeLocked do
				Waiting = 1
				helpntf = false
				if not helpntf then
					print("ben burda")
					helpntf = true 
				end
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
				if helpntf and not openhelp then 
					print("sasasasas")
					SendNUIMessage({
						type = "help",
						status = true,
					})
					openhelp = true
				end
				Citizen.Wait(Waiting)
			end
		end
		if not helpntf and openhelp then
			SendNUIMessage({
				type = "help",
				status = false,
			})
			openhelp = false
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

--  function RotationToDirection(rotation)
-- 	local adjustedRotation = 
-- 	{ 
-- 		x = (math.pi / 180) * rotation.x, 
-- 		y = (math.pi / 180) * rotation.y, 
-- 		z = (math.pi / 180) * rotation.z 
-- 	}
-- 	local direction = 
-- 	{
-- 		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
-- 		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
-- 		z = math.sin(adjustedRotation.x)
-- 	}
-- 	return direction
-- end

--  function RayCastGamePlayCamera(distance)
-- 	local cameraRotation = GetGameplayCamRot()
-- 	local cameraCoord = GetGameplayCamCoord()
-- 	local direction = RotationToDirection(cameraRotation)
-- 	local destination = 
-- 	{ 
-- 		x = cameraCoord.x + direction.x * distance, 
-- 		y = cameraCoord.y + direction.y * distance, 
-- 		z = cameraCoord.z + direction.z * distance 
-- 	}
-- 	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
-- 	return b, c, e
-- end

-- Citizen.CreateThread(function()
-- 	while not NetworkIsPlayerActive do
-- 		Citizen.Wait(0)
-- 	end
	
-- 	while true do
-- 		Citizen.Wait(0)

-- 		local hit, coords, entity = RayCastGamePlayCamera(1000.0)

-- 			local position = GetEntityCoords(PlayerPedId())
-- 			DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
-- 	end
-- end)