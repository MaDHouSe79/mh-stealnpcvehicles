--[[ ===================================================== ]]--
--[[        MH Steel Npc Vehicles Script by MaDHouSe       ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local zones = {}
local blips = {}
local isBusy = false
local isInScrapZone = false
local enable = true
local scrapTime = 0
local currentZone = nil
local homeZone = nil
local homeBlip = nil
local missionPlate = nil
local missionVehicle = nil
local isMissionEnable = false
local jobvehicleBlip = nil
local destroyVehicle = nil
local dropZone = nil
local dropVehPos = nil
local dropLocation = nil
local dropGround = nil
local dropHeading = nil
local homeLocation = nil
local homeGround = nil
local homeHeading = nil
local isvehicleDropped = false
local scrapType = nil
local scrapCombo = nil
local missionFailNotify = false
local cooldown = false
local fuelPrice = 0

local function DeleteBlips()
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}
end

local function UpdateBlips()
    PlayerData = QBCore.Functions.GetPlayerData()
    DeleteBlips()
    for _, zone in pairs(Config.Zones) do
        if zone.blip.show and not Config.IgnoreJobs[PlayerData.job.name] then
            local blip = AddBlipForCoord(zone.blip.coords)
            SetBlipSprite(blip, zone.blip.sprite)
            SetBlipColour(blip, zone.blip.color)
            SetBlipScale(blip, 0.6)
            SetBlipDisplay(blip, 4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(zone.blip.label)
            EndTextCommandSetBlipName(blip)
            blips[#blips + 1] = blip
        end
    end
end

local function RunCoolDown()
    cooldown = true
    SetTimeout(Config.CoolDownTime * 60, function()
        cooldown = false
    end)
end

local function Load()
    UpdateBlips()
    for k, v in pairs(Config.Zones) do
        zones[#zones + 1] = PolyZone:Create({table.unpack(v.zone.vectors)}, {name = v.zone.name, minZ = v.zone.minZ, maxZ = v.zone.maxZ})
    end
    scrapCombo = ComboZone:Create(zones, { name = "ScrapZone", debugPoly = Config.DebugPoly })
end

local function Reset()
    ClearAllPedProps(PlayerPedId())
    ClearPedTasks(PlayerPedId())
    isBusy = false
    isInScrapZone = false
    enable = true
    scrapTime = 0
    currentZone = nil
    missionPlate = nil
    isMissionEnable = false
    dropZone = nil
    dropVehPos = nil
    isvehicleDropped = false
    scrapType = nil
end

local function ResetMission()
    Reset()
    Citizen.Wait(1000)
    if destroyVehicle ~= nil and DoesEntityExist(destroyVehicle) then
        DeleteEntity(destroyVehicle)
        DeleteVehicle(destroyVehicle)
        destroyVehicle = nil
    end
    if missionVehicle ~= nil and DoesEntityExist(missionVehicle) then
        DeleteEntity(missionVehicle)
        DeleteVehicle(missionVehicle)
        missionVehicle = nil
    end
    if missionBlip ~= nil then 
        RemoveBlip(missionBlip)
        missionBlip = nil
    end
    if homeBlip ~= nil then 
        RemoveBlip(homeBlip)
        homeZone = nil
        homeBlip = nil
    end
    if jobvehicleBlip ~= nil then 
        RemoveBlip(jobvehicleBlip) 
        jobvehicleBlip = nil
    end
end

local function IsBlackListedVehicle(class)
    local isBlacklisted = false
    for k, v in pairs(Config.IgnoreVehicleClasses) do
        if v == class then isBlacklisted = true end
    end
    return isBlacklisted    
end

local function NPCVehicleOptions()
    if cooldown then 
        return QBCore.Functions.Notify(Lang:t('notify.active_cooldown'), "error", 5000) 
    else
        if IsBlackListedVehicle(GetVehicleClass(GetVehiclePedIsIn(PlayerPedId()))) then 
            QBCore.Functions.Notify(Lang:t('notify.vehicle_is_blacklisted'), "error", 5000)
            Reset()
        else
            local menu = {
                {
                    header = Lang:t('menu.menu_header'),
                    isMenuHeader = true,
                    icon = "fa-solid fa-circle-info",
                }
            }
            menu[#menu + 1] = {
                header = Lang:t('menu.menu_option_1'),
                txt = Lang:t('menu.menu_option_1_dec'),
                icon = "fa-solid fa-angle-right",
                params = {
                    event = 'mh-stealnpcvehicles:client:SteelNPCVehicle',
                    args = {}
                },
            }
            menu[#menu + 1] = {
                header = Lang:t('menu.menu_option_2'),
                txt = Lang:t('menu.menu_option_2_dec'),
                icon = "fa-solid fa-angle-right",
                params = {
                    event = 'mh-stealnpcvehicles:client:ScrapNPCVehicle',
                    args = {type = "parts"}
                },
            }
            menu[#menu + 1] = {
                header = Lang:t('menu.menu_option_3'),
                txt = Lang:t('menu.menu_option_3_dec'),
                icon = "fa-solid fa-angle-right",
                params = {
                    event = 'mh-stealnpcvehicles:client:ScrapNPCVehicle',
                    args = {type = "materials"}
                },
            }
            menu[#menu + 1] = {
                header = Lang:t('menu.menu_close'),
                icon = "fa-solid fa-angle-left",
                params = {
                    event = 'mh-carstealing:client:hideMenu',
                    args = {}
                }
            }
            exports['qb-menu']:openMenu(menu)
        end
    end
end

local function GetDistance(pos1, pos2)
    return #(vector3(pos1.x, pos1.y, pos1.z) - vector3(pos2.x, pos2.y, pos2.z))
end

local function CalculateFuelPrice(from, to)
    local route = CalculateTravelDistanceBetweenPoints(from.x, from.y, from.z, to.x, to.y, to.z)
    local price = math.floor((route / 1000) * Config.FuelPrice + 0.5)
    local total = price * 2
    return total
end

local function CreateMissionBlip(name, coords, sprite)
	blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, 5)
    SetBlipScale(blip, 0.5)
	SetBlipAsShortRange(blip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	SetBlipRoute(blip, 1)
	return blip
end

local function OpenAllDoors(veh)
    for i = 0, 5 do
        SetVehicleDoorOpen(veh, i, false, true)
        Citizen.Wait(100)
    end
end

local function CloseAllDoors(veh)
    for i = 0, 5 do
        SetVehicleDoorShut(veh, i, false)
        Citizen.Wait(100)
    end
end

local function BrakeAllWindowsSlow(veh)
    local countWindows = 0
    for i = 0, 7 do
        if countWindows <= 7 then
            SmashVehicleWindow(veh, i, false)
            Citizen.Wait(600)
            countWindows = countWindows + 1
        end
    end
end

local function BrakeAllWheelsSlow(veh)
    local countsWheels = 0
    SetVehicleTyresCanBurst(veh, true)
    for i = 0, 4 do
        if countsWheels <= 4 then
            SetVehicleTyreBurst(veh, i, true, 1000.0)
            Citizen.Wait(600)
            countsWheels = countsWheels + 1
        end
    end
end

local function BrakeAllDoorsSlow(veh)
    local countDoors = 0
    for i = 0, 5 do
        if countDoors <= 5 then
            SetVehicleDoorBroken(veh, i, false)
            Citizen.Wait(600)
            countDoors = countDoors + 1
        end
    end
end

local function DestroyVehicle(veh)
    BrakeAllWindowsSlow(veh) 
    BrakeAllWheelsSlow(veh) 
    BrakeAllDoorsSlow(veh) 
end

local function PrepereDroZone()
    dropZone = Config.Drops[math.random(1, #Config.Drops)]
    dropVehPos = vector3(dropZone.drop.x, dropZone.drop.y, dropZone.drop.z)
    dropLocation = vector3(dropZone.coords.x, dropZone.coords.y, dropZone.coords.z)
    dropGround = dropZone.ground
    dropHeading = dropZone.heading
    fuelPrice = CalculateFuelPrice(GetEntityCoords(PlayerPedId()), dropLocation)
end

local function TakeOutVehicle(data, entity) 
    ClearAreaOfVehicles(data.spawnpoint, 10000, false, false, false, false, false)   
    QBCore.Functions.SpawnVehicle(data.model, function(vehicle)
        missionVehicle = vehicle
        isMissionEnable = true
        jobvehicleBlip = CreateMissionBlip('Job Vehicle', data.spawnpoint, 477)
        SetVehicleNumberPlateText(vehicle, data.plate)
        SetEntityHeading(vehicle, data.heading)
        SetVehRadioStation(vehicle, 'OFF')
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleDoorsLocked(vehicle, 0)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleFuelLevel(vehicle, 100.0)
        DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
        missionPlate = QBCore.Functions.GetPlate(vehicle)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
    end, data.spawnpoint, true)
    Citizen.Wait(500)
    AttachEntityToEntity(entity, missionVehicle, 20, Config.JobVehicle.offset.x, Config.JobVehicle.offset.y, Config.JobVehicle.offset.z, 0.0, 0.0, 0.0, false, false, false, false, 20, true)   
end

local function GetRequiredItems()
    QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:GetMissingItems", function(items)
        QBCore.Functions.Notify(Lang:t('notify.not_enough_items'), "error", 5000)
        TriggerEvent('inventory:client:requiredItems', items, true)
        Citizen.Wait(5000)
        TriggerEvent('inventory:client:requiredItems', items, false)
    end)
end

local function ScrapNPCVehicle()
    local veh, distance = QBCore.Functions.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    if veh ~= nil then
        if distance <= Config.InteractDistance then
            local props = QBCore.Functions.GetVehicleProperties(veh)
            local displaytext = GetDisplayNameFromVehicleModel(props.model)
            if math.floor(GetVehicleBodyHealth(veh)) < Config.MinDamage then
                return QBCore.Functions.Notify("To much damage", "error", 5000)
            end
            FreezeEntityPosition(veh, true)
            SetVehicleEngineOn(veh, false, false, true)
            destroyVehicle = veh
            TaskLeaveVehicle(PlayerPedId(), veh)
            Citizen.Wait(1500)
            TaskTurnPedToFaceEntity(PlayerPedId(), veh, 5000)
            Citizen.Wait(1000)
            OpenAllDoors(veh)
            Citizen.Wait(500)
            scrapTime = Config.DestroyTime
            QBCore.Functions.Progressbar("animation1", Lang:t('progressbar.info1'), scrapTime, false, true,{
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
                anim = "weed_spraybottle_crouch_base_inspector"
            }, {}, {}, function() -- Done
                QBCore.Functions.Progressbar("animation2", Lang:t('progressbar.info2'), scrapTime, false, true,{
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped"
                }, {}, {}, function() -- Done
                    QBCore.Functions.Progressbar("animation2", Lang:t('progressbar.info3'), scrapTime, false, true,{
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
                        anim = "weed_spraybottle_crouch_base_inspector"
                    }, {}, {}, function() -- Done
                        RunCoolDown()
                        ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 10.0, 0)
                        ClearAllPedProps(PlayerPedId())
                        ClearPedTasks(PlayerPedId())
                        FreezeEntityPosition(veh, false)
                        local vehicleData = {
                            model = Config.JobVehicle.model,
                            plate = Config.JobVehicle.plate,
                            spawnpoint = Config.Zones[currentZone].flatbed.coords,
                            heading = Config.Zones[currentZone].flatbed.heading,
                        }
                        TakeOutVehicle(vehicleData, veh)                        
                    end, function() -- Cancel
                        Reset()
                        QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                    end)
                end, function() -- Cancel
                    Reset()
                    QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                end)
            end, function() -- Cancel
                Reset()
                QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
            end)
        end
    end
end

local function StealNPCVehicle()
    local veh, distance = QBCore.Functions.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    if veh ~= nil then
        if distance <= Config.InteractDistance then
            local props = QBCore.Functions.GetVehicleProperties(veh)
            local displaytext = GetDisplayNameFromVehicleModel(props.model)
            if math.floor(GetVehicleBodyHealth(veh)) < Config.MinDamage then
                return QBCore.Functions.Notify("To much damage", "error", 5000)
            end
            FreezeEntityPosition(veh, true)
            SetVehicleEngineOn(veh, false, false, true)
            TaskLeaveVehicle(PlayerPedId(), veh)
            Citizen.Wait(1500)
            TaskTurnPedToFaceEntity(PlayerPedId(), veh, 5000)
            Citizen.Wait(1000)
            OpenAllDoors(veh)
            Citizen.Wait(500)
            QBCore.Functions.Progressbar("animation1", Lang:t('progressbar.info1'), Config.DestroyTime, false, true,{
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
                anim = "weed_spraybottle_crouch_base_inspector"
            }, {}, {}, function() -- Done
                QBCore.Functions.Progressbar("animation2", Lang:t('progressbar.info2'), Config.DestroyTime, false, true,{
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped"
                }, {}, {}, function() -- Done
                    QBCore.Functions.Progressbar("animation2", Lang:t('progressbar.info3'), Config.DestroyTime, false, true,{
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
                        anim = "weed_spraybottle_crouch_base_inspector"
                    }, {}, {}, function() -- Done
                        RunCoolDown()
                        ClearAllPedProps(PlayerPedId())
                        ClearPedTasks(PlayerPedId())
                        FreezeEntityPosition(veh, false)
                        CloseAllDoors(veh)
                        TaskEnterVehicle(PlayerPedId(), veh, 20000, -1, 1.5, 1, 0)
                        Citizen.Wait(2000)
                        SetVehicleEngineOn(veh, true, false, true)
                        QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:savenpcvehicle", function(callback)
                        end, {props = props, model = props.model, plate = props.plate, modelname = displaytext:lower(), vehicle = veh})
                    end, function() -- Cancel
                        Reset()
                        QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                    end)
                end, function() -- Cancel
                    Reset()
                    QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                end)
            end, function() -- Cancel
                Reset()
                QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
            end)
        end
    end
end

local function DrawLocation(from, to, ground, heading)
    if to ~= nil then
        local location = vector3(to.x, to.y, to.z)
        if #(from - location) <= 50.0 or #(from - location) > 2.0 then
            DrawMarker(30, location.x, location.y, location.z - ground, 0, 0, 0, 90.0, heading, 0.0, 3.0, 1.0, 10.0, 255, 0, 0, 50, 0, 0, 0, 0)
        end
        if #(from - location) <= 2.0 then
            DrawMarker(30, location.x, location.y, location.z - ground , 0, 0, 0, 90.0, heading, 0.0, 3.0, 1.0, 10.0, 26, 255, 0, 50, 0, 0, 0, 0)
        end
    end
end

local function DetonateVehicle(veh)
    local coords = GetEntityCoords(veh)
    if DoesEntityExist(veh) then
        AddExplosion(coords.x, coords.y, coords.z, 5, 100.0, true, false, true)
        Citizen.Wait(5000)
        DeleteEntity(veh)
        DeleteVehicle(veh)
        destroyVehicle = nil
        dropLocation = nil
        dropGround = nil
        dropHeading = nil
        homeZone = Config.Zones[currentZone].flatbed
        homeBlip = CreateMissionBlip('Go Back', homeZone.coords, 309)
        homeLocation = vector3(homeZone.coords.x, homeZone.coords.y, homeZone.coords.z)
        homeGround = homeZone.ground
        homeHeading = homeZone.heading
    end
end

local function RunTimer(veh)
    local timer = 3000
    while timer > 0 do
        timer = timer - 1000
        Citizen.Wait(1000)
        if timer <= 0 then DetonateVehicle(veh) end
    end
end

local function DropVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local plate = QBCore.Functions.GetPlate(vehicle)
    if isMissionEnable and destroyVehicle ~= nil then
        isMissionEnable = false
        DetachEntity(destroyVehicle, true, true)
        Citizen.Wait(100)
        SetEntityCoords(destroyVehicle, dropVehPos, false, false, false, true)
        isvehicleDropped = true
        Citizen.Wait(2000)
        RemoveBlip(missionBlip)
        QBCore.Functions.Notify(Lang:t('notify.wreck_is_bumped'), "success", 10000)
        if Config.UseHunters then
            Citizen.Wait(Config.HunterDelay)
            TriggerServerEvent("police:server:policeAlert", "Illegale Dumping: Iemand heeft een voertuig gedump in zee!")
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Load()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteBlips()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    Load()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData = data
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    DeleteBlips()
    Citizen.Wait(100)
    UpdateBlips()
end)

RegisterNetEvent('mh-carstealing:client:delete', function(netID)
    local vehicle = NetToVeh(netID)
    DeleteEntity(vehicle)
    DeleteVehicle(vehicle)
end)

RegisterNetEvent('mh-carstealing:client:hideMenu', function()
    isBusy = false
    exports['qb-core']:HideText()
    if isInScrapZone then
        if not isBusy then
            exports['qb-core']:DrawText(Lang:t('notify.press_for_menu'))
        end
    end
end)

RegisterNetEvent('mh-stealnpcvehicles:client:ScrapNPCVehicle', function(args)
    if IsPedInAnyVehicle(PlayerPedId()) then
        PrepereDroZone()
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        local props = QBCore.Functions.GetVehicleProperties(vehicle)
        QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:hasOwner", function(hasOwner)
            if hasOwner then
                QBCore.Functions.Notify(Lang:t('notify.can_not_steel_player_vehicle'), "error", 5000)
                TriggerEvent('mh-carstealing:client:hideMenu')
            else
                QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:hasItems", function(count)
                    if count == #Config.NeededItems then
                        QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:payRent", function(hasPaid)
                            if hasPaid then
                                scrapType = args.type
                                ScrapNPCVehicle()
                            else
                                QBCore.Functions.Notify(Lang:t('notify.not_enough_money_to_rent'), "error")
                            end
                        end, fuelPrice)
                    else
                        TriggerEvent('mh-carstealing:client:hideMenu')
                        GetRequiredItems()
                    end
                end)
            end
        end, props.plate)
    end
end)

RegisterNetEvent('mh-stealnpcvehicles:client:SteelNPCVehicle', function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        PrepereDroZone()
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        local props = QBCore.Functions.GetVehicleProperties(vehicle)
        QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:hasOwner", function(hasOwner)
            if hasOwner then
                QBCore.Functions.Notify(Lang:t('notify.can_not_steel_player_vehicle'), "error", 5000)
                TriggerEvent('mh-carstealing:client:hideMenu')
            else
                QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:hasItems", function(count)
                    if count == #Config.NeededItems then
                        QBCore.Functions.TriggerCallback("mh-stealnpcvehicles:server:payRent", function(hasPaid)
                            if hasPaid then
                                StealNPCVehicle()
                            else
                                QBCore.Functions.Notify(Lang:t('notify.not_enough_money_to_rent'), "error")
                            end
                        end, fuelPrice)
                    else
                        TriggerEvent('mh-carstealing:client:hideMenu')
                        GetRequiredItems()
                    end
                end)
            end
        end, props.plate)
    end
end)

-- Draw drop location
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local from = GetEntityCoords(PlayerPedId())
            if isMissionEnable and destroyVehicle ~= nil then
                DrawLocation(from, dropLocation, dropGround, dropHeading)
            end
            if homeZone ~= nil and isvehicleDropped then
                DrawLocation(from, homeLocation, homeGround, homeHeading)
            end
        end
        Citizen.Wait(0)
    end
end)

-- If vehicle is dropped at drop location
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if isvehicleDropped and destroyVehicle ~= nil then 
                RunTimer(destroyVehicle) 
            end
        end
        Citizen.Wait(1000)
    end
end)

-- Scrap locations
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if not Config.IgnoreJobs[PlayerData.job.name] then
                if scrapCombo:isPointInside(pos) then
                    isInScrapZone = true
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        if not isBusy then
                            exports['qb-core']:DrawText(Lang:t('notify.press_for_menu'))
                        end
                        if IsControlJustPressed(0, 38) and isInScrapZone and not isBusy then -- E
                            if cooldown then
                                isBusy = false
                                exports['qb-core']:HideText()
                                return QBCore.Functions.Notify(Lang:t('notify.active_cooldown'), "error", 5000) 
                            else
                                isBusy = true
                                exports['qb-core']:HideText()
                                NPCVehicleOptions()
                            end
                        end
                    end
                else
                    if isInScrapZone then exports['qb-core']:HideText() end
                    isInScrapZone = false
                end
            end
        end
        Wait(1)
    end
end)

-- Go to dump location
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if not Config.IgnoreJobs[PlayerData.job.name] then
                if isMissionEnable then
                    local vehicle = GetVehiclePedIsIn(PlayerPedId())
                    local plate = QBCore.Functions.GetPlate(vehicle)
                    if plate == missionPlate and jobvehicleBlip ~= nil then
                        missionBlip = CreateMissionBlip("Drop Zone", dropLocation, 527)
                        QBCore.Functions.Notify(Lang:t('notify.go_to_dump_location'), "success", 10000)
                        RemoveBlip(jobvehicleBlip)
                        jobvehicleBlip = nil 
                    end
                end
            end
        end
        Citizen.Wait(100)
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(10)
        if LocalPlayer.state.isLoggedIn then
            if not Config.IgnoreJobs[PlayerData.job.name] then
                local playerCoords = GetEntityCoords(PlayerPedId())
                if currentZone == nil then
                    for k, zone in pairs(Config.Zones) do 
                        local zoneCoords = vector3(zone.coords.x, zone.coords.y, zone.coords.z)
                        if GetDistance(playerCoords, zoneCoords) < 5 then
                            currentZone = k
                        end
                    end
                end
                if dropLocation ~= nil then
                    local vehicle = GetVehiclePedIsIn(PlayerPedId())
                    local vehicleHeadinhg = GetEntityHeading(vehicle)
                    local currentHeading = vehicleHeadinhg - dropHeading
                    if GetDistance(playerCoords, dropLocation) < 25.0 and not isvehicleDropped then
                        if currentHeading > 1.05 then 
                            exports['qb-core']:DrawText("Je moet achteruit rijden en op het vlak staan.")
                        end
                    end
                    if GetDistance(playerCoords, dropLocation) <= 1.0 and not isvehicleDropped then
                        if currentHeading < 1 then 
                            exports['qb-core']:DrawText(Lang:t('notify.drop_vehicle'))
                        end
                        if IsControlJustPressed(0, 38) then -- E
                            if currentHeading < 1 then 
                                exports['qb-core']:HideText()
                                DropVehicle()
                            else
                                exports['qb-core']:DrawText("Je moet achteruit op het vlak staan.")
                            end
                        end
                    end
                end
                if homeZone ~= nil and isvehicleDropped then
                    if GetDistance(playerCoords, homeLocation) <= 1.0 then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId())
                        local plate = QBCore.Functions.GetPlate(vehicle)
                        if plate == missionPlate then
                            homeLocation = nil
                            homeGround = nil
                            homeHeading = nil
                            PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
                            FreezeEntityPosition(vehicle, true)
                            Citizen.Wait(500)
                            SetVehicleEngineOn(vehicle, false, false, true)
                            TaskLeaveVehicle(PlayerPedId(), vehicle)
                            Citizen.Wait(2000)
                            QBCore.Functions.Notify(Lang:t('notify.job_done_good_work'), "success", 10000)
                            TriggerServerEvent("mh-stealnpcvehicles:server:GetItems", scrapType)
                            ResetMission()
                        end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if destroyVehicle ~= nil and scrapTime > 0 and enable then
            enable = false
            DestroyVehicle(destroyVehicle)
        end
    end
end)

-- If player is in laststand or dead the mission fails
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if isMissionEnable then
                if PlayerData.metadata['isdead'] or PlayerData.metadata['inlaststand'] then
                    if not missionFailNotify then
                        missionFailNotify = true
                        ResetMission()
                        PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 0)
                        QBCore.Functions.Notify(Lang:t('notify.job_failed'), "error", 10000)
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)