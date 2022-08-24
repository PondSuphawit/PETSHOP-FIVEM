ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

isused = false 
globalTime = {}


ESX.RegisterServerCallback('petshop:canUsePetshop', function(src, answer)

    if isused then 
        local ra = false
        answer(ra)
    else
        isused = true 
        local ra = true
        answer(ra)
    end
end)

ESX.RegisterServerCallback('petshop:requestPetData', function(src, cb)
    local _source = src
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM pets WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(data)
        if next(data) == nil then
            cb(nil,nil)
        else

            local customize = json.decode(data[1].customize)
            local petdata = {
                pet = data[1].pet,
                hunger = data[1].hunger,
                health = data[1].health,
                customize = customize,
            }

            local gltime = globalTime[_source]
            cb(petdata,gltime)
        end
    end)
end)

RegisterServerEvent('petshop:revivePet')
AddEventHandler('petshop:revivePet',function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sourceItem = xPlayer.getInventoryItem(PSW['ไอเทมชุบสัตว์เลี้ยง'])

    if sourceItem.count >= 1 then
        xPlayer.removeInventoryItem(PSW['ไอเทมชุบสัตว์เลี้ยง'], 1)
        MySQL.Async.execute('UPDATE pets SET hunger = @hunger WHERE owner = @owner', {
            ['@owner'] = xPlayer.identifier,
            ['@hunger'] = PSW.Hunger
        }, function(rowsChanged)
        end)
        MySQL.Async.execute('UPDATE pets SET health = @health WHERE owner = @owner', {
            ['@owner'] = xPlayer.identifier,
            ['@health'] = 200
        }, function(rowsChanged)
        end)
    else
        TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] You need a pet pill to revive your pet!")
    end
end)

RegisterServerEvent('petshop:deletePet')
AddEventHandler('petshop:deletePet',function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.execute('DELETE FROM pets WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    })
end)


RegisterServerEvent('petshop:notWatching')
AddEventHandler('petshop:notWatching',function(id)
    isused = false 
end)

RegisterServerEvent('petshop:updateHealth')
AddEventHandler('petshop:updateHealth',function(health)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local heal = health
    MySQL.Async.execute('UPDATE pets SET health = @health WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier,
        ['@health'] = heal
    }, function(rowsChanged)
    end)
end)


RegisterServerEvent('petshop:feedPet')
AddEventHandler('petshop:feedPet',function(type)
    local _source = source
    local src = _source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM pets WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(data) 
        local hunger = data[1].hunger
        local itemname = PSW['อาหารสัตว์'][type].name
        local sourceItem = xPlayer.getInventoryItem(itemname)
        --print(sourceItem)
        if sourceItem.count >= 1 then
            xPlayer.removeInventoryItem(PSW['อาหารสัตว์'][type].name, 1)
            local newfood = hunger
            if globalTime[_source] >= PSW.FoodHunger then
                globalTime[_source] = globalTime[_source] - PSW.FoodHunger

            else
                local foodotadd = (PSW.FoodHunger - globalTime[_source])
                globalTime[_source] = 0
                newfood = (hunger + foodotadd)
            end

            --local newfood = (hunger + foodotadd)
            if newfood >= PSW.Hunger then
                MySQL.Async.execute('UPDATE pets SET hunger = @hunger WHERE owner = @owner', {
                    ['@owner'] = xPlayer.identifier,
                    ['@hunger'] = PSW.Hunger
                }, function(rowsChanged)
                end)
            else
                MySQL.Async.execute('UPDATE pets SET hunger = @hunger WHERE owner = @owner', {
                    ['@owner'] = xPlayer.identifier,
                    ['@hunger'] = newfood
                }, function(rowsChanged)
                end)
            end
        else
            TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] You need "..PSW['อาหารสัตว์'][type].label.." to feed your pet!")
        end
    end)
end)

RegisterServerEvent('petshop:buyPet')
AddEventHandler('petshop:buyPet',function(selectedPet, compData)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local haspet = true
    MySQL.Async.fetchAll('SELECT * FROM pets WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(data) 

        if next(data) == nil then
            haspet = false
        end


        if haspet == true then
            TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] You already have a pet!")
        elseif haspet == false then
            if xPlayer.getMoney() >= PSW['สัตว์เลี้ยงในร้าน'][selectedPet].price then
                xPlayer.removeMoney(PSW['สัตว์เลี้ยงในร้าน'][selectedPet].price)
                local petpricex3 = (PSW['สัตว์เลี้ยงในร้าน'][selectedPet].price * 3)
                local petshopgainz = (petpricex3 / 10)
--[[ 
                TriggerEvent('esx_addonaccount:getSharedAccount', "society_petshop", function(account)
                    account.addMoney(petshopgainz)

                end) ]]

                local petname = PSW['สัตว์เลี้ยงในร้าน'][selectedPet].name
                local hunger = PSW.Hunger
                --local idbro
                --local textidbro
                local heal = 200
                local customize = json.encode(compData)
                print(customize)
                --[[for compId, textId in pairs(compData) do
                    idbro = compId
                    textidbro = textId
                    heal = 200
                end]]

                MySQL.Async.execute('INSERT INTO pets (owner,pet, hunger, health, customize) VALUES (@owner, @pet, @hunger, @health, @customize)',
                {
                    ['@owner'] = xPlayer.identifier,
                    ['@pet'] = petname,
                    ['@hunger'] = hunger,
                    ['@health'] = heal,
                    ['customize'] = customize
                }, function(rowsChanged)
                    globalTime[_source] = 1
                    TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] You just brought your "..petname.." pet!")
                end)

            else
                TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] You don't have enough money!")
            end
        end

    end)
    --print(haspet)

end)

RegisterServerEvent('petshop:buyPetTarget')
AddEventHandler('petshop:buyPetTarget',function(selectedPet, compData,target)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local _target = target
    local tPlayer = ESX.GetPlayerFromId(_target)
    local haspet = true
    MySQL.Async.fetchAll('SELECT * FROM pets WHERE owner = @owner', {
        ['@owner'] = tPlayer.identifier
    }, function(data) 

        if next(data) == nil then
            haspet = false
        end


        if haspet == true then
            TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] Player already have a pet!")
        elseif haspet == false then
            if xPlayer.getMoney() >= (PSW['สัตว์เลี้ยงในร้าน'][selectedPet].price / 2) then
                local removepricethis = (PSW['สัตว์เลี้ยงในร้าน'][selectedPet].price / 2)
                xPlayer.removeMoney(removepricethis)

                local petname = PSW['สัตว์เลี้ยงในร้าน'][selectedPet].name
                local hunger = PSW.Hunger
                --local idbro
                --local textidbro
                local heal = 200
                local customize = json.encode(compData)
                print(customize)
                --[[for compId, textId in pairs(compData) do
                    idbro = compId
                    textidbro = textId
                    heal = 200
                end]]

                MySQL.Async.execute('INSERT INTO pets (owner,pet, hunger, health, customize) VALUES (@owner, @pet, @hunger, @health, @customize)',
                {
                    ['@owner'] = tPlayer.identifier,
                    ['@pet'] = petname,
                    ['@hunger'] = hunger,
                    ['@health'] = heal,
                    ['customize'] = customize
                }, function(rowsChanged)
                    globalTime[_target] = 1
                    TriggerClientEvent("esx:showNotification", _target, "[PETSHOP] You just got your "..petname.." pet!")
                    TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] Player with id: ".._target.." got his/her "..petname.." pet!")
                end)

            else
                TriggerClientEvent("esx:showNotification", _source, "[PETSHOP] You don't have enough money!")
            end
        end

    end)
    --print(haspet)

end)

Citizen.CreateThread(function()
    while true do

        if globalTime then
            for k,v in pairs(globalTime) do
                --print(globalTime[k])
                if globalTime[k] ~= nil then

                    globalTime[k] = (v + 3)
                       --print(""..k.." -> "..globalTime[k].."")
                end
            end
        else
            Wait(5000)
            --print(globalTime)
        end
        Wait(3000)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local id = xPlayer.identifier
    --print(id)

    MySQL.Async.fetchAll('SELECT * FROM pets WHERE owner = @owner', {
        ['@owner'] = id
    }, function(data) 
        if data ~= nil then
            if data[1].hunger ~= nil then
                local hunger = data[1].hunger
                --print(_source)
                --print(globalTime[_source])
                local newfood = (hunger - globalTime[_source])
                if newfood <= 0 then
                    newfood = 0
                end
                MySQL.Async.execute('UPDATE pets SET hunger = @hunger WHERE owner = @owner', {
                    ['@owner'] = id,
                    ['@hunger'] = newfood
                }, function(rowsChanged)
                end)
            end
        end
        globalTime[_source] = nil 
    end)

end)


AddEventHandler('es:playerLoaded', function(source)
    local _source = source 

    globalTime[_source] = 1
end)