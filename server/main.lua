--[[ ===================================================== ]]--
--[[        MH Steel Npc Vehicles Script by MaDHouSe       ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()

local function IsVehicleOwner(citizenid, plate)
    local retval = false
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE citizenid = ? AND plate = ?', {citizenid, plate})
    if result then retval = true end
    return retval
end

local function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then return GeneratePlate() else return plate:upper() end
end

local function GiveCarParts(id)
    local Player = QBCore.Functions.GetPlayer(id)
    if Player then
        for k, item in pairs(Config.CarItems) do
            local amount = 1
            if item == "skirts" then amount = 2 end
            if item == "bumper" then amount = 2 end
            if item == "headlights" then amount = 2 end
            if item == "brakes1" then amount = 4 end
            if item == "stockrim" then amount = 4 end
            if item == "tire" then amount = 4 end
            if item == "seat" then amount = 4 end
            if item == "door" then amount = 4 end
            if item == "wheel" then amount = 4 end
            if item == "suspension1" then amount = 4 end
            if item == "sparkplugs" then amount = 4 end
            Player.Functions.AddItem(item, amount)
            TriggerClientEvent('qb-inventory:client:ItemBox', id, QBCore.Shared.Items[item], 'add', amount)
            Citizen.Wait(500)
        end

        if math.random(1, 8) == math.random(1, 8) then
            Player.Functions.AddItem("turbo", 1)
            TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["turbo"], 'add', 1)
        end
        
        for i = 1, math.random(4, 8), 1 do
            local item = Config.ScrapItems[math.random(1, #Config.ScrapItems)]
            local amount = math.random(Config.MinItems, Config.MaxItems)
            Player.Functions.AddItem(item, amount)
            TriggerClientEvent('qb-inventory:client:ItemBox', id, QBCore.Shared.Items[item], 'add', amount)
            Citizen.Wait(800)
        end

    end
end

local function GiveRawMetarials(id)
    local Player = QBCore.Functions.GetPlayer(id)
    if Player then
        for i = 1, math.random(2, 4), 1 do
            local item = Config.ScrapItems[math.random(1, #Config.ScrapItems)]
            local amount = math.random(Config.MinItems, Config.MaxItems)
            Player.Functions.AddItem(item, amount)
            TriggerClientEvent('qb-inventory:client:ItemBox', id, QBCore.Shared.Items[item], 'add', amount)
            Citizen.Wait(800)
        end
        if math.random(1, 8) == math.random(1, 8) then
            local random = math.random(10, 20)
            Player.Functions.AddItem("rubber", random)
            TriggerClientEvent('qb-inventory:client:ItemBox', id, QBCore.Shared.Items["rubber"], 'add', random)
        end
    end
end

QBCore.Functions.CreateCallback("mh-stealnpcvehicles:server:payRent", function(source, cb, fuelPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.UsePayment then
        if Player.Functions.GetMoney('cash') >= fuelPrice then
            Player.Functions.RemoveMoney("cash", fuelPrice, "flatbed-rent-paid")
            cb(true)
        else
            if Player.Functions.GetMoney('bank') >= fuelPrice then
                Player.Functions.RemoveMoney("cash", fuelPrice, "flatbed-rent-paid")
                cb(true)
            else
                cb(false)
            end
        end
    else
        cb(true)
    end
end)

QBCore.Functions.CreateCallback("mh-stealnpcvehicles:server:hasOwner", function(source, cb, plate)
    local founded = false
    MySQL.Async.fetchAll("SELECT * FROM player_vehicles", {}, function(vehicles)
        for k, v in pairs(vehicles) do
            if v.plate == plate then founded = true end
        end
        cb(founded)
    end)
end)

QBCore.Functions.CreateCallback("mh-stealnpcvehicles:server:hasItems", function(source, cb, actionType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local hasItems = 0
    if Player then
        local tmpData = {}
        for i = 1, #Config.NeededItems do
            if Player.Functions.GetItemByName(Config.NeededItems[i].name) then
                if Player.Functions.GetItemByName(Config.NeededItems[i].name).amount >= Config.NeededItems[i].needed then
                    hasItems = hasItems + 1
                end
            else
                hasItems = hasItems - 1
            end
        end
    end
    if hasItems <= 0 then hasItems = 0 end
    cb(hasItems)
end)

QBCore.Functions.CreateCallback("mh-stealnpcvehicles:server:GetMissingItems", function(source, cb)
    local items = {}
    for k, item in pairs(Config.NeededItems) do
        items[#items + 1] = {name = item.name, image = QBCore.Shared.Items[item.name].image}
    end
    cb(items)
end)

QBCore.Functions.CreateCallback("mh-stealnpcvehicles:server:savenpcvehicle", function(source, cb, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local plate = GeneratePlate()
    Citizen.Wait(500)
    MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license, Player.PlayerData.citizenid, data.modelname, GetHashKey(data.model), json.encode(data.props), plate, 0, 'pillboxgarage'
    })
    Citizen.Wait(20)
    if IsVehicleOwner(Player.PlayerData.citizenid, plate) then
        MySQL.update('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(data.props), plate})
    end
    Citizen.Wait(50)
    TriggerClientEvent('mh-stealnpcvehicles:client:hideMenu', src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.own_the_vehicle'), 'success')
end)

RegisterNetEvent('mh-stealnpcvehicles:server:delete', function(netID)
    TriggerClientEvent('mh-stealnpcvehicles:client:delete', -1, netID)
    TriggerClientEvent('mh-stealnpcvehicles:client:hideMenu', src)
end)

RegisterNetEvent('mh-stealnpcvehicles:server:GetItems', function(scrapType)
    local src = source
    if scrapType == "materials" then GiveRawMetarials(src) end
    if scrapType == "parts" then GiveCarParts(src) end
end)
