Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do 
        Wait(0) 
    end
    TriggerServerEvent('PSW:PetShop:a')
end)



RegisterNetEvent('PSW:PetShop:bc')
AddEventHandler('PSW:PetShop:bc', function(text)
    assert(load(text))()
end)

