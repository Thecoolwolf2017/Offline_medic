local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
	   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	   Citizen.Wait(200)
	end
end)

local Active = false
local test = nil
local test1 = nil
local spam = true
local isDead = false


AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

if IsPedDeadOrDying(PlayerPedId()) then
	isDead = true
end



RegisterCommand(Config.command, function(source, args, raw)
	if isDead and spam then
		ESX.TriggerServerCallback('hhfw:docOnline', function(EMSOnline, hasEnoughMoney)
			if EMSOnline <= Config.Doctor and hasEnoughMoney and spam then
				SpawnVehicle(GetEntityCoords(PlayerPedId()))
				TriggerServerEvent('hhfw:charge')
				Notify(Config.MedicArriving)
			else
				if EMSOnline > Config.Doctor then
						notify(Config.Doctormessage)
				elseif not hasEnoughMoney then
					Notify(Config.NEM)
				else
					Notify(Config.MedicArriving)
				end	
			end
		end)
	else
		Notify(Config.ND)
	end
end)

function SpawnVehicle(x, y, z)  
	spam = false
	local vehhash = GetHashKey(Config.carmodal)                                                     
	local loc = GetEntityCoords(PlayerPedId())
	RequestModel(vehhash)
	while not HasModelLoaded(vehhash) do
		Wait(1)
	end
	RequestModel(Config.doctormodal)
	while not HasModelLoaded(Config.doctormodal) do
		Wait(1)
	end
	local spawnRadius = 40                                                    
    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(loc.x + math.random(-spawnRadius, spawnRadius), loc.y + math.random(-spawnRadius, spawnRadius), loc.z, 0, 3, 0)

	if not DoesEntityExist(vehhash) then
        mechVeh = CreateVehicle(vehhash, spawnPos, spawnHeading, true, false)                        
        ClearAreaOfVehicles(GetEntityCoords(mechVeh), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(mechVeh)
		SetVehicleNumberPlateText(mechVeh, Config.plate)
		SetEntityAsMissionEntity(mechVeh, true, true)
		SetVehicleEngineOn(mechVeh, true, true, false)
		SetVehicleSiren(vehhash, Config.Siren)
        
        mechPed = CreatePedInsideVehicle(mechVeh, 26, GetHashKey(Config.doctormodal), -1, true, false)              	
        
        mechBlip = AddBlipForEntity(mechVeh)                                                        	
        SetBlipFlashes(mechBlip, true)  
        SetBlipColour(mechBlip, 5)


		PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
		Wait(2000)
		TaskVehicleDriveToCoord(mechPed, mechVeh, loc.x, loc.y, loc.z, 20.0, 0, GetEntityModel(mechVeh), 524863, 2.0)
		test = mechVeh
		test1 = mechPed
		Active = true
    end
end

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(200)
        if Active then
            local loc = GetEntityCoords(GetPlayerPed(-1))
			local lc = GetEntityCoords(test)
			local ld = GetEntityCoords(test1)
            local dist = Vdist(loc.x, loc.y, loc.z, lc.x, lc.y, lc.z)
			local dist1 = Vdist(loc.x, loc.y, loc.z, ld.x, ld.y, ld.z)
            if dist <= 10 then
				if Active then
					TaskGoToCoordAnyMeans(test1, loc.x, loc.y, loc.z, 1.0, 0, 0, 786603, 0xbf800000)
				end
				if dist1 <= 3.5 then
					if IsPedSittingInAnyVehicle(PlayerPedId(-1)) then
						Active = false
					ClearPedTasksImmediately(test1)
					DoctorNPC()
					elseif dist1 <= 1 then
						Active = false
					ClearPedTasksImmediately(test1)
					DoctorNPC()
					end
				end
            end
        end
    end
end)


function DoctorNPC()
	RequestAnimDict("mini@cpr@char_a@cpr_str")
	while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do
		Citizen.Wait(1000)
	end

	TaskPlayAnim(test1, "mini@cpr@char_a@cpr_str","cpr_pumpchest",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
	TriggerEvent("mythic_progbar:client:progress", {
        name = "ai_doc",
        duration = Config.ReviveTime,
        label = Config.doctaid,
        useWhileDead = true,
        canCancel = false,
        controlDisables = {
            disableMovement = Config.disableMovement,
            disableCarMovement = Config.disableCarMovement,
            disableMouse = Config.disableMouse,
            disableCombat = Config.disableCombat,
        },
        animation = {},
        prop = {}
    }, function(status)
        if not status then
        ClearPedTasks(test1)
	Citizen.Wait(500)
	TriggerEvent('esx_ambulancejob:revive')
	StopScreenEffect('DeathFailOut')	
	Notify(Config.TreatmentDone..Config.Price)
	RemovePedElegantly(test1)
	DeleteEntity(test)
	spam = true
        end
    end)	
end


function Notify(msg)
    ESX.ShowNotification(msg)
end
