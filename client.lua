ESX = nil

-- Posizione con i nomi di tutte le telecamere
Telecamere = {
	[1] =  { ['x'] = 411.43,['y'] = -1032.6,['z'] = 32.68,['h'] = 298.86, ['info'] = ' Garage esterno', ["recent"] = false },
	[2] =  { ['x'] = 425.34,['y'] = -948.35,['z'] = 38.04,['h'] = 163.96, ['info'] = ' Ingresso principale', ["recent"] = false },
	[3] =  { ['x'] = 509.02,['y'] = -1021.61,['z'] = 30.99,['h'] = 88.15, ['info'] = ' Ingresso sul retro', ["recent"] = false },
	[4] =  { ['x'] = 34.26,['y'] = -1348.76,['z'] = 30.64,['h'] = 61.58, ['info'] = ' Negozietto Innocence Boulevard - 1', ["recent"] = false },
	[5] =  { ['x'] = 24.17,['y'] = -1342.55,['z'] = 30.64,['h'] = 233.41, ['info'] = ' Negozietto Innocence Boulevard - 2', ["recent"] = false },
	[6] =  { ['x'] = -717.93,['y'] = -915.94,['z'] = 20.42,['h'] = 309.75, ['info'] = ' Negozietto Ginger Street - 1', ["recent"] = false },
	[7] =  { ['x'] = -705.41,['y'] = -909.5,['z'] = 20.00,['h'] = 130.93, ['info'] = ' Negozietto Ginger Street - 2', ["recent"] = false },
	[8] =  { ['x'] = -57.27,['y'] = -1752.16,['z'] = 30.59,['h'] = 264.57, ['info'] = ' Negozietto Groove Street - 1', ["recent"] = false },
	[9] =  { ['x'] = -42.94,['y'] = -1755.06,['z'] = 29.99,['h'] = 92.2, ['info'] = ' Negozietto Groove Street - 2', ["recent"] = false },
	[10] =  { ['x'] = -1225.05,['y'] = -911.01,['z'] = 13.47,['h'] = 345.61, ['info'] = ' Negozietto San Andreas Avenue', ["recent"] = false },
	[11] =  { ['x'] = 381.8,['y'] = 322.52,['z'] = 104.3,['h'] = 24.54, ['info'] = ' Negozietto Clinton Avenue - 1', ["recent"] = false },
	[12] =  { ['x'] = 373.22,['y'] = 331.47,['z'] = 104.3,['h'] = 211.28, ['info'] = ' Negozietto Clinton Avenue - 2', ["recent"] = false },
	[13] =  { ['x'] = -1483.26,['y'] = -380.51,['z'] = 41.36,['h'] = 86.61, ['info'] = ' Negozietto Prosperity Street', ["recent"] = false },
	[14] =  { ['x'] = 1133.22,['y'] = -978.55,['z'] = 47.37,['h'] = 232.63, ['info'] = ' Negozietto El Rancho Boulevandd', ["recent"] = false },
	[15] =  { ['x'] = -2966.09,['y'] = 387.03,['z'] = 15.93,['h'] = 36.21, ['info'] = ' Negozietto Great Ocean Highway', ["recent"] = false },
	[16] =  { ['x'] = 2559.08,['y'] = 390.72,['z'] = 109.26,['h'] = 143.43, ['info'] = ' Negozietto Palomino Freeway - 1', ["recent"] = false },
	[17] =  { ['x'] = 2552.16,['y'] = 380.38,['z'] = 109.26,['h'] = 322.41, ['info'] = ' Negozietto Palomino Freeway - 2', ["recent"] = false },
	[18] =  { ['x'] = 1736.09,['y'] = 6409.54,['z'] = 35.98,['h'] = 24.2, ['info'] = ' Negozietto Senora Freeway - 1', ["recent"] = false },
	[19] =  { ['x'] = 1729.54,['y'] = 6419.86,['z'] = 35.98,['h'] = 202.47, ['info'] = ' Negozietto Senora Freeway - 2', ["recent"] = false },
}


-- Posizione di dove si trovano i marker
Computer = {
    { x = 442.95,  y = -998.87,  z = 33.97},
	{ x = 443.27,  y = -996.53,  z = 33.97}
}

Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(0)
	  PlayerData = ESX.GetPlayerData()
	end
end)

inCam = false
camAttuale = 0

RegisterNetEvent("cctv:camera")
AddEventHandler("cctv:camera", function(camNumber)
	camNumber = tonumber(camNumber)
	if inCam then
		inCam = false
		PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
		Wait(250)
		FreezeEntityPosition(GetPlayerPed(-1), false)
		ClearPedTasks(GetPlayerPed(-1))
		stopAnim()
	else
		PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
		TriggerEvent("cctv:startcamera",camNumber)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		startAnim()
	end
end)

function startAnim()
	Citizen.CreateThread(function()
	  RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
	  while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
	    Citizen.Wait(0)
	  end
		FreezeEntityPosition(GetPlayerPed(-1), true)
		tablet = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
		AttachEntityToEntity(tablet, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
		TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end
function stopAnim()
	FreezeEntityPosition(GetPlayerPed(-1), false)
	StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteEntity(tablet)
end

RegisterNetEvent("cctv:startcamera")
AddEventHandler("cctv:startcamera", function(camNumber)

	local x = camNumber["x"]
	local y = camNumber["y"]
	local z = camNumber["z"]
	local h = camNumber["h"]

	inCam = true
	SetTimecycleModifier("heliGunCam")
	SetTimecycleModifierStrength(1.0)
	local scaleform = RequestScaleformMovie("TRAFFIC_CAM")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	
	local lPed = GetPlayerPed(-1)
	camAttuale = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(camAttuale,x,y,z+1.2)						
	SetCamRot(camAttuale, -15.0,0.0,h)
	SetCamFov(camAttuale, 110.0)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(scaleform, "PLAY_CAM_MOVIE")
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	PopScaleformMovieFunctionVoid()

	while inCam do
		SetCamCoord(camAttuale,x,y,z+1.2)						
		-- SetCamRot(camAttuale, -15.0,0.0,h)
		PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
		PushScaleformMovieFunctionParameterFloat(GetEntityCoords(h).z)
		PushScaleformMovieFunctionParameterFloat(1.0)
		PushScaleformMovieFunctionParameterFloat(GetCamRot(camAttuale, 2).z)
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Citizen.Wait(1)
	end
	ClearFocus()
	ClearTimecycleModifier()
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(camAttuale, false)
	SetNightvision(false)
	SetSeethrough(false)
end)

function IsJobTrue()
    local IsJobTrue = false 
    if PlayerData ~= nil and PlayerData.job ~= nil then
        if PlayerData.job.name == 'police' then
            return true
        end
    end
    return IsJobTrue
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		
		if IsJobTrue() then
            for k,v in pairs(Computer) do
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 100 then
                    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 100, false, false, 2, false, false, false, false)
                end              
            end
        end

		if CurrentAction ~= nil then
			if not inCam then
				SetTextComponentFormat('STRING')
				AddTextComponentString('Premi ~INPUT_CONTEXT~ per visualizzare le telecamere')
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end

			if IsControlJustReleased(0, 38) and IsJobTrue() then
				if CurrentAction == 'menu' then
					Menu()
				end
			end
      	end

		if inCam then
			local rotazione = GetCamRot(camAttuale, 2)
			if IsControlPressed(1, 175) then --destra
				SetCamRot(camAttuale, rotazione.x, 0.0, rotazione.z + 0.7, 2)
			elseif IsControlPressed(1, 174) then -- sinistra
				SetCamRot(camAttuale, rotazione.x, 0.0, rotazione.z - 0.7, 2)
			elseif IsControlPressed(1, 172) then -- sopra
				SetCamRot(camAttuale, rotazione.x + 0.7, 0.0, rotazione.z, 2)
			elseif IsControlPressed(1, 173) then -- sotto
				SetCamRot(camAttuale, rotazione.x - 0.7, 0.0, rotazione.z, 2)
			end
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)
  
function Menu()
  
    local elements = {}

	for i=1, #Telecamere, 1 do
		table.insert(elements, { label = Telecamere[i]["info"], value = Telecamere[i] })
	end
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'frk_videosorveglianza',
        {
            title    = 'Videosorveglianza',
            elements = elements
        },
        function(data, menu)
			if not inCam then
				PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
				TriggerEvent("cctv:startcamera", data.current.value)
				startAnim()
			else
				inCam = false
				PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
				Wait(250)
				ClearPedTasks(GetPlayerPed(-1))
				stopAnim()
			end
        end,
        function(data, menu)
            menu.close()
			if inCam then
				inCam = false
				PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
				Wait(250)
				ClearPedTasks(GetPlayerPed(-1))
				stopAnim()
			end
        end
      )
  
end

AddEventHandler('frk_videosorveglianza:dentromarker', function(zone)
    CurrentAction     = 'menu'
end)
  
AddEventHandler('frk_videosorveglianza:uscitomarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
	if inCam then
		inCam = false
		PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
		Wait(250)
		FreezeEntityPosition(GetPlayerPed(-1), false)
		ClearPedTasks(GetPlayerPed(-1))
		stopAnim()
	end
end)
 
Citizen.CreateThread(function()
	while true do
		Wait(500)
		if IsJobTrue() then
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local dentro  = false
			local attuale = nil

			for k,v in pairs(Computer) do
				if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.5) then
					dentro  = true
					attuale = k
				end
			end

			if (dentro and not giastato) or (dentro and ultima ~= attuale) then
				giastato = true
				ultima = attuale
				CurrentAction     = 'menu'
			end

			if not dentro and giastato then
				giastato = false
				CurrentAction = nil
			end
		end
	end
end)