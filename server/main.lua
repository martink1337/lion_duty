ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:police')
AddEventHandler('duty:police', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.name == "police" or "offjob" then
		xPlayer.setJob(xPlayer.job.name=="police" and "offjob" or "police", xPlayer.job.grade)
	end
	
end)

RegisterServerEvent('duty:ambulance')
AddEventHandler('duty:ambulance', function(job)

		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.job.name == "ambulance" or "offjob" then
		xPlayer.setJob(xPlayer.job.name=="ambulance" and "offjob" or "ambulance", xPlayer.job.grade)
	end
	
end)

RegisterServerEvent('duty:mechanic')
AddEventHandler('duty:mechanic', function(job)
	
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.name == "mechanic" or "offjob" then
		xPlayer.setJob(xPlayer.job.name=="mechanic" and "offjob" or "mechanic", xPlayer.job.grade)
	end
	
end)

RegisterServerEvent('duty:taxi')
AddEventHandler('duty:taxi', function(job)
	
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.name == "taxi" or "offjob" then
		xPlayer.setJob(xPlayer.job.name=="taxi" and "offjob" or "taxi", xPlayer.job.grade)
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