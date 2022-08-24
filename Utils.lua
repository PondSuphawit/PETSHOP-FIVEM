RegisterServerEvent('PSW:PetShopFree:a')
AddEventHandler('PSW:PetShopFree:a', function()
    local _source = source
    local text = [[
    
        ESX = nil

        local PlayerData = {}
        local inmenu = false
        local petData
        local myPetPed
        
        local isBusy = false
        local isCheckingDistance = false
        local isFollowing = false
        
        local previewCamera
        local previewModel
        local compData = {}
        local previewCustData = {}
        
        local selectedPet
        local globalTime
        
        local staticModels = {}
        local isShowingStaticModels = false
        
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                Wait(0)
            end
        
            
            while ESX.GetPlayerData().job == nil do
                Wait(10)
            end
        
            PlayerData = ESX.GetPlayerData()
            
            for k,v in ipairs(PSW['สัตว์เลี้ยงในร้าน']) do
                RequestModel(v.model)
                
                while not HasModelLoaded(v.model) do
                    Wait(0)
                end
            end
        
            InitScript()
        end)
        
        RegisterNetEvent('esx:setJob')
        AddEventHandler('esx:setJob', function(job)
            PlayerData.job = job
        end)
        
        RegisterKeyMapping('pet', '<font face="ThaiFont">ปุ่มเปิดเมนูสัตว์เลี้ยง', 'keyboard', PSW['ปุ่มเปิดเมนู'])
        
        RegisterCommand('pet', function(source)
            ESX.UI.Menu.CloseAll()
            if isBusy then
                return
            end
            
            SetBusy(2)
            
            local received = false
            
            ESX.TriggerServerCallback('petshop:requestPetData', function(data, gltime)
                petData = data
                globalTime = gltime
                --print(petData)
                received = true
            end)
            
            while not received do
                Wait(0)
                --print('not received')
            end
            
            if not petData then
                ESX.ShowNotification('You dont have a pet')
                return
            end
            
            for k,v in pairs(PSW['สัตว์เลี้ยงในร้าน']) do
                if v.name == petData.pet then
                    petData.model = v.model
                    petData.type = v.type
                    
                    break
                end
            end
            
            local hunger = (petData.hunger - globalTime)/PSW.Hunger*100
            
            if hunger <= 0 then
                hunger = 0
            end
            
            local hungerTxt = string.format('%0.2f%%', hunger)
            
            local elements = {}
            
            table.insert(elements, {label = 'เรียก/ไล่ สัตว์เลี้ยง',          value = 'toggle_pet'})
            table.insert(elements, {label = 'ให้สัตว์เลี้ยงตาม', value = 'toggle_follow'})
            table.insert(elements, {label = 'ท่าท่างน้อน',             value = 'animations'})
            table.insert(elements, {label = 'เอาน้อนขึ้นรถ',       value = 'enter_vehicle'})
            table.insert(elements, {label = 'เอาน้อนลงรถ',       value = 'leave_vehicle'})
            table.insert(elements, {label = 'ให้อาหาร',                  value = 'feed_pet'})
            table.insert(elements, {label = 'ชุบชีวิตน้อน',             value = 'revive_pet'})
            table.insert(elements, {label = 'ลบสัตว์เลี้ยง',                value = 'delete_pet'})
            
            ESX.UI.Menu.CloseAll()
            
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pet_menu', {
                title    = 'สัตว์เลี้ยงกำลัง หิว | '..hungerTxt,
                align    = 'bottom-right',
                elements = elements,
            },
            function(data, menu)
                if not isBusy then
                    SetBusy(2)
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    
                    if data.current.value == 'toggle_pet' then
                        if not DoesEntityExist(myPetPed) then
                            if not petData then
                                ESX.UI.Menu.CloseAll()
                            end
                            
                            if petData.health == 0 then
                                ESX.ShowNotification('Your pet is dead, go to the petshop to revive it')
                                return
                            end
                            
                            if hunger == 0 then
                                ESX.ShowNotification('Your pet died from starvation')
                                return
                            end
                            
                            if DoesEntityExist(vehicle) then
                                ESX.ShowNotification('You must not be inside a vehicle')
                                return
                            end
                            
                            local coords = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId())
                            
                            myPetPed = CreatePed(28, petData.model, coords.x, coords.y, coords.z - 1.0, 0.0, true, true)
                            SetPedDefaultComponentVariation(myPetPed)
                            SetPedCanBeTargetted(myPetPed, false)
                            SetEntityHealth(myPetPed, petData.health)
                            SetBlockingOfNonTemporaryEvents(myPetPed, true)
                            SetPedFleeAttributes(myPetPed, 0, 0)
                            SetEntityInvincible(myPetPed, true)
                            
                            if petData.customize then
                                for compId, textId in pairs(petData.customize) do
                                    --print(compId)
                                    --print(textId)
                                    local cId = tonumber(compId)
                                    local tid = tonumber(textId)
                                    SetPedComponentVariation(myPetPed, cId, 0, tid, 2)
                                end
                            end
                            
                            CreateThread(function()
                                while DoesEntityExist(myPetPed) and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(PlayerPedId())) < 100.0 do
                                    if GetEntityHealth(myPetPed) ~= petData.health then
                                        petData.health = GetEntityHealth(myPetPed)
                                        TriggerServerEvent('petshop:updateHealth', petData.health)
                                    end
                                    
                                    if petData.health == 0 then
                                        break
                                    end
                                    
                                    Wait(1500)
                                end
                                
                                if DoesEntityExist(myPetPed) then
                                    DeleteEntity(myPetPed)
                                end
                            end)
                        else
                            DeleteEntity(myPetPed)
                        end
                    elseif data.current.value == 'enter_vehicle' then
                        if DoesEntityExist(vehicle) then
                            if DoesEntityExist(myPetPed) then
                                TaskWarpPedIntoVehicle(myPetPed, vehicle, 0)
                            end
                        else
                            ESX.ShowNotification('You are not inside a vehicle')
                        end
                    elseif data.current.value == 'toggle_follow' then
                        if DoesEntityExist(myPetPed) then
                            isFollowing = not isFollowing
                            CreateThread(function()
                                while isFollowing and DoesEntityExist(myPetPed) do
                                    Citizen.Wait(1)
                                    local coords = GetEntityCoords(PlayerPedId())
                                    if #(coords - GetEntityCoords(myPetPed)) >= 0.3 then
                                        SetPedKeepTask(myPetPed, true)
                                        TaskFollowToOffsetOfEntity(myPetPed, GetPlayerPed(-1), 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
                                    end
                                end
                            end)
                        end
                    elseif data.current.value == 'animations' then
                        if PSW['ท่าทางสัตว์'][petData.pet] then
                            if DoesEntityExist(myPetPed) then
                                
                                AnimationMenu(petData.pet)
                            end
                        else
                            ESX.ShowNotification('This pet has no animations')
                        end
                    elseif data.current.value == 'get_ball' then
                        if DoesEntityExist(myPetPed) then
                            local coords = GetEntityCoords(PlayerPedId())
                            local ball = GetClosestObjectOfType(coords, 100.0, `w_am_baseball`)
                            
                            if DoesEntityExist(ball) then
                                local ballCoords = GetEntityCoords(ball)
                                TaskGoToCoordAnyMeans(myPetPed, ballCoords.x, ballCoords.y, ballCoords.z, 5.0, 0, 0, 786603, 0xbf800000)
                                
                                while #(GetEntityCoords(myPetPed) - ballCoords) > 0.5 and DoesEntityExist(myPetPed) do
                                    Wait(100)
                                end
                                
                                AttachEntityToEntity(ball, myPetPed, GetPedBoneIndex(myPetPed, 17188), 0.120, 0.010, 0.010, 5.0, 150.0, 0.0, true, true, false, true, 1, true)
                                Wait(500)
                                
                                coords = GetEntityCoords(PlayerPedId())
                                TaskGoToCoordAnyMeans(myPetPed, coords, 5.0, 0, 0, 786603, 0xbf800000)
                                
                                while #(GetEntityCoords(myPetPed) - coords) > 2.0 and DoesEntityExist(myPetPed) do
                                    Wait(100)
                                end
                                
                                ESX.Game.DeleteObject(ball)
                            else
                                ESX.ShowNotification('No ball found')
                            end
                        end
                    elseif data.current.value == 'leave_vehicle' then
                        if DoesEntityExist(myPetPed) then
                            local coords = GetEntityCoords(PlayerPedId()) + 3*GetEntityForwardVector(PlayerPedId())
                            SetEntityCoords(myPetPed, coords)
                        end
                    elseif data.current.value == 'feed_pet' then
                        if DoesEntityExist(myPetPed) then
                            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(myPetPed)) < 2.0 then
                                TriggerServerEvent('petshop:feedPet', petData.type)
                                Wait(1200)
                            else
                                ESX.ShowNotification('Your pet is not near you')
                            end
                        end
                    elseif data.current.value == 'revive_pet' then
                        TriggerServerEvent('petshop:revivePet')
                        Wait(1200)
                    elseif data.current.value == 'vaccine_pet' then
                        if DoesEntityExist(myPetPed) then
                            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(myPetPed)) < 2.0 then
                                TriggerServerEvent('petshop:vaccinePet')
                                Wait(1200)
                                ExecuteCommand('pet')
                            else
                                ESX.ShowNotification('Your pet is not near you')
                            end
                        end
                    elseif data.current.value == 'delete_pet' then
                        local answer = GetAnswer('Are you sure? type [yes]')
                        
                        if answer == 'yes' then
                            if DoesEntityExist(myPetPed) then
                                DeleteEntity(myPetPed)
                            end
                            
                            TriggerServerEvent('petshop:deletePet')
                            Wait(1200)
                            ExecuteCommand('pet')
                        end
                    end
                end
            end,
            function(data, menu)
                menu.close()
            end)
        end)
        
        
        function AnimationMenu(petName)
            local elements = {}
            
            for k,v in pairs(PSW['ท่าทางสัตว์'][petName]) do
                table.insert(elements, {label = v.label, dict = v.dict, name = v.name})
            end
            
            if PSW.CanSitShoulder[petName] then
                table.insert(elements, {label = 'Toggle Sit Shoulder', value = 'sit_shoulder'})
            end
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations', {
                title    = 'Animations',
                align    = 'bottom-right',
                elements = elements,
            },
            function(data, menu)
                if DoesEntityExist(myPetPed) then
                    if not isBusy then
                        SetBusy(2000)
                        
                        if data.current.value then
                            ToggleSitOnShoulder()
                        else
                            local dict = data.current.dict
                            local name = data.current.name
                            
                            RequestAnimDict(dict)
                            
                            while not HasAnimDictLoaded(dict) do
                                Wait(0)
                            end
                            
                            TaskPlayAnim(myPetPed, dict, name, 8.0, -8, -1, 1, 0, false, false, false)
                        end
                    end
                else
                    ESX.ShowNotification('Pet not found')
                end
            end,
            function(data, menu)
                menu.close()
            end)
        end
        
        function InitScript()
            Citizen.CreateThread(function()
                while true do
                    local coords = GetEntityCoords(PlayerPedId())
                    
                    if #(coords - PSW['จุดสำหรับเปิดร้าน']) < 5.0 then
                        DrawMarker(31, PSW['จุดสำหรับเปิดร้าน'], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 200, 255, 150, false, false, 2, true, false, false, false)
                        
                        if not inmenu and #(coords - PSW['จุดสำหรับเปิดร้าน']) < 1.0 then
                            ESX.ShowHelpNotification('Press ~r~[E]~w~ to open the preview menu')
                            
                            if IsControlJustReleased(0, 38) then
                                inmenu = true
                                ESX.TriggerServerCallback('petshop:canUsePetshop', function(yes)
                                    if yes then
                                        SetNuiFocus(true, true)
                                        SendNUIMessage({action = 'show', animals = PSW['สัตว์เลี้ยงในร้าน'], hasJob = (PlayerData.job.name == 'K1-PetShop')})
                                        
                                        previewCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
                                        SetCamCoord(previewCamera, PSW['มุมกล้อง']['x'], PSW['มุมกล้อง']['y'], PSW['มุมกล้อง']['z'])
                                        SetCamRot(previewCamera, PSW['มุมกล้อง']['rotationX'], PSW['มุมกล้อง']['rotationY'], PSW['มุมกล้อง']['rotationZ'])
                                        SetCamActive(previewCamera, true)
                                        RenderScriptCams(1, 1, 1000, 1, 1)
                                    else
                                        TriggerEvent('pNotify:SendNotification', {
                                            text = "มีคนอื่นกำลังเลือกสัตว์เลี้ยงอยู่",
                                            type = "alert",
                                            timeout = (5000),
                                            layout = "bottomCenter",
                                            queue = "global"
                                        })
                                        inmenu = false
                                    end
                                end)
                                
                                Wait(1000)
                            end
                        end
                    else
                        Wait(3000)
                    end
                    
                    if not isShowingStaticModels and #(coords - PSW['จุดสำหรับเปิดร้าน']) < 50.0 then
                        isShowingStaticModels = true
                        SetupStaticModels()
                    elseif isShowingStaticModels and #(coords - PSW['จุดสำหรับเปิดร้าน']) > 50.0 then
                        isShowingStaticModels = false
                        DeleteStaticModels()
                    end
                    
                    Wait(0)
                end
            end)
        end
        
        RegisterNUICallback('quit', function(data)
            inmenu  = false
            DestroyCam(previewCamera)
            RenderScriptCams(0, 1, 1000, 1, 0)
            
            SetNuiFocus(false, false)
        
            if DoesEntityExist(previewModel) then
                DeleteEntity(previewModel)
            end
            
            TriggerServerEvent('petshop:notWatching')
        end)
        
        RegisterNUICallback('buy', function(selectedPet)
            inmenu  = false
            if DoesEntityExist(previewModel) then
                DeleteEntity(previewModel)
                
                DestroyCam(previewCamera)
                RenderScriptCams(0, 1, 1000, 1, 0)
                
                SetNuiFocus(false, false)
                TriggerServerEvent('petshop:notWatching')
        
                if PlayerData.job.name ~= 'petshop' then
                    TriggerServerEvent('petshop:buyPet', selectedPet, compData)
                else
                    
                    local data = exports['dialog']:Create('Get Pet', 'Enter target ID')
                    local target = tonumber(data.value)
                    
                    if not target then
                        ESX.ShowNotification('Target not found')
                        return
                    end
                    
                    TriggerServerEvent('petshop:buyPetTarget', selectedPet, compData, target)
                end
            end
        end)
        
        RegisterNUICallback('preview', function(id)
        
            if DoesEntityExist(previewModel) then
                DeleteEntity(previewModel)
            end
        
            previewModel = CreatePed(28, PSW['สัตว์เลี้ยงในร้าน'][id].model, PSW['จุดสปาวโมเดลตอนเปิดร้าน'].x, PSW['จุดสปาวโมเดลตอนเปิดร้าน'].y, PSW['จุดสปาวโมเดลตอนเปิดร้าน'].z, 185.0, true, true)
        
        
            SetPedDefaultComponentVariation(previewModel)
            SetEntityHeading(previewModel, 180.00)
            FreezeEntityPosition(previewModel, true)
            SetEntityInvincible(previewModel, true)
            SetBlockingOfNonTemporaryEvents(previewModel, true)
            
            compData = {}
            previewCustData = GetPedCustomization(previewModel)
            
            local elements = {}
            
            for i=1, #previewCustData, 1 do
                table.insert(elements, {label = PSW.Customization[previewCustData[i].compId + 1], value = i})
            end
            
            SendNUIMessage({action = 'skins', skins = elements})
        end)
        
        RegisterNUICallback('change_skin', function(id)
            if DoesEntityExist(previewModel) then
                previewCustData[id].textId = previewCustData[id].textId + 1
                
                if (previewCustData[id].textId >= GetNumberOfPedTextureVariations(previewModel, previewCustData[id].compId, previewCustData[id].drawId)) then
                    previewCustData[id].textId = 0
                end
                
                SetPedComponentVariation(previewModel, previewCustData[id].compId, previewCustData[id].drawId, previewCustData[id].textId, 2)
                compData[previewCustData[id].compId] = previewCustData[id].textId
            end
        end)
        
        function GetPedCustomization(previewModel)
            local data = {}
            
            for i=0, 11, 1 do
                local drawAmount = GetNumberOfPedDrawableVariations(previewModel, i) - 1
                
                if (drawAmount > -1) then
                    for j = 0, drawAmount, 1 do
                        local textAmount = GetNumberOfPedTextureVariations(previewModel, i, j) - 1
                        
                        if (textAmount > 0) then
                            table.insert(data, {compId = i, drawId = j, textId = 0})
                            SetPedComponentVariation(ped, i, j, 0, 2)
                        end
                    end
                end
            end
        
            return data
        end
        
        function SetupStaticModels()
            for k,v in pairs(PSW['จุดโชว์สัตว์ในร้าน']) do
                local staticModel = CreatePed(28, v.model, v.coords.x, v.coords.y, v.coords.z, v.heading, false, false)
                SetPedDefaultComponentVariation(staticModel)
                SetEntityHeading(staticModel, v.heading)
                FreezeEntityPosition(staticModel, true)
                SetEntityInvincible(staticModel, true)
                SetBlockingOfNonTemporaryEvents(staticModel, true)
                
                table.insert(staticModels, staticModel)
            end
        end
        
        function SetBusy(mSeconds)
            isBusy = true
            
            CreateThread(function()
                Wait(mSeconds)
                isBusy = false
            end)
        end
        
        function DeleteStaticModels()
            for k,v in pairs(staticModels) do
                if DoesEntityExist(v) then
                    DeleteEntity(v)
                end
            end
        end
        
        function ToggleSitOnShoulder()
            if IsEntityAttachedToAnyPed(myPetPed) then
                DetachEntity(myPetPed, true, true)
            else
                AttachEntityToEntity(myPetPed, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 40269), -0.1, -0.02, 0.02, 0.0, -60.0, 0.0, true, true, false, true, 1, true)
            end
        end
        
        function GetAnswer(question)
            local answer
            
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), question, {
                title = question
            },
            function(data, menu)
                answer = data.value or ''
                menu.close()
            end,
            function(data, menu)
                answer = ''
                menu.close()
            end)
            
            while answer == nil do
                Wait(100)
            end
            
            return answer
        end
        
        AddEventHandler('onResourceStop', function(resource)
            if resource == GetCurrentResourceName() then
                DeleteStaticModels()
                
                if DoesEntityExist(previewModel) then
                    DeleteEntity(previewModel)
                end
                
                if DoesEntityExist(myPetPed) then
                    DeleteEntity(myPetPed)
                end
            end
        end)
        
        Citizen.CreateThread(function()
        
            if PSW['เปิดจุดบนแมพไหม'] then
                blip = AddBlipForCoord(PSW['จุดสำหรับเปิดร้าน'].x, PSW['จุดสำหรับเปิดร้าน'].y, PSW['จุดสำหรับเปิดร้าน'].z)
                SetBlipSprite(blip, PSW['เลขBlip'])
                SetBlipDisplay(blip, PSW['ระยะการมองเห็น'] ) 
                SetBlipScale(blip, PSW['ขนาดBlip'])
                SetBlipColour(blip, PSW['สีBlip'])
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(PSW['ชื่อบนแมพ'])
                EndTextCommandSetBlipName(blip)
        
            end
        end)
        
        

    ]]
