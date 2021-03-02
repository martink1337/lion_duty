local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


--- Functions
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil


--- ESX
local GUI = {}
ESX                           = nil
GUI.Time                      = 0
local PlayerData              = {}

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(500)
 	PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- Zones Check
AddEventHandler('lion_duty:hasEnteredMarker', function (zone)
  if zone == 'AmbulanceDuty' then
    CurrentAction     = 'ambulance_duty'
    CurrentActionMsg  = _U('duty')
    CurrentActionData = {}
  end
  if zone == 'PoliceDuty' or zone == 'PoliceDuty2' or zone == 'PoliceDuty3' or zone == 'PoliceDuty4' then
    CurrentAction     = 'police_duty'
    CurrentActionMsg  = _U('duty')
    CurrentActionData = {}
  end
  if zone == 'MecanoDuty' then
    CurrentAction     = 'mechanic_duty'
    CurrentActionMsg  = _U('duty')
    CurrentActionData = {}
  end
  if zone == 'TaxiDuty' then
    CurrentAction     = 'taxi_duty'
      CurrentActionMsg  = _U('duty')
      CurrentActionData = {}
    end
end)

AddEventHandler('lion_duty:hasExitedMarker', function (zone)
  CurrentAction = nil
end)


--key controls
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(50)

      local playerPed = GetPlayerPed(-1)

    if CurrentAction ~= nil then
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0, Keys['E']) then

        -- Cooldown
        Citizen.Wait(50)
        -- Debug Print
        print("[lion_duty] - Someone changed duty status!")
		
        if CurrentAction == 'mechanic_duty' then
          if PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'offjob' then
            TriggerServerEvent('duty:mechanic')
          if PlayerData.job.name == 'mechanic' then
            ESX.ShowNotification(_U('offduty'), 'success', 2500)
            Wait(1000)
          else
            ESX.ShowNotification(_U('onduty'), 'success', 2500)
            Wait(1000)
          end
        else
          ESX.ShowNotification(_U('notwljob'), 'error', 5000)
          Wait(1000)
        end
      end
	  
        if CurrentAction == 'ambulance_duty' then
          if PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offjob' then
            TriggerServerEvent('duty:ambulance')
          if PlayerData.job.name == 'ambulance' then
            ESX.ShowNotification(_U('offduty'), 'success', 2500)
            Wait(1000)
          else
            ESX.ShowNotification(_U('onduty'), 'success', 2500)
            Wait(1000)
          end
        else
          ESX.ShowNotification(_U('notwljob'), 'error', 5000)
          Wait(1000)
        end
      end

      if CurrentAction == 'taxi_duty' then
        if PlayerData.job.name == 'taxi' or PlayerData.job.name == 'offjob' then
          TriggerServerEvent('duty:taxi')
        if PlayerData.job.name == 'taxi' then
          ESX.ShowNotification(_U('offduty'), 'success', 2500)
          Wait(1000)
        else
          ESX.ShowNotification(_U('onduty'), 'success', 2500)
          Wait(1000)
        end
      else
        ESX.ShowNotification(_U('notwljob'), 'error', 5000)
        Wait(1000)
      end
    end

        if CurrentAction == 'police_duty' then
          if PlayerData.job.name == 'police' or PlayerData.job.name == 'offjob' then
            TriggerServerEvent('duty:police')
          if PlayerData.job.name == 'police' then
            ESX.ShowNotification(_U('offduty'), 'success', 2500)
            Wait(1000)
          else
            ESX.ShowNotification(_U('onduty'), 'success', 2500)
            Wait(1000)
          end
        else
          ESX.ShowNotification(_U('notwljob'), 'error', 5000)
          Wait(1000)
          end
        end
      end
    end
  end       
end)

-- Display markers (Uncomment it if you going to use it [Not Recommended - High Client Side Usage])

--[[
Citizen.CreateThread(function ()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k,v in pairs(Config.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end
  end
end)
]]--

-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while true do
    Wait(500)

    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker  = true
        currentZone = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('lion_duty:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('lion_duty:hasExitedMarker', LastZone)
    end
  end
end)

-- Shows Notification
function sendNotification(xSource, message, messageType, messageTimeout)
  TriggerClientEvent("pNotify:SendNotification", xSource, {
      text = message,
      type = messageType,
      queue = "qalle",
      timeout = messageTimeout,
      layout = "bottomCenter"
  })
end