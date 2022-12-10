local QBCore = exports['qb-core']:GetCoreObject() 

local isLoggedIn = LocalPlayer.state['isLoggedIn']
local VehicleCoords = nil
local MissionVehicle = nil
local CurrentCops = 0
local currentJobId = nil
local CurrentJob = nil
local CurrentJobLocation = nil
local DropoffLocation = nil
local onRun = false
local case = nil
local DropoffSpot = nil
local DropoffSpotData = nil
local Entities = {}
local vehicleBlip = nil
local policeBlip = nil
local deliveryBlip = nil
local npcs = {
    ['npcguards'] = {},
    ['npccivilians'] = {}
}

local npcVehicles = {}

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

local function canInteract(value)
    if onRun then return false end
    local tokens = nil
    if Config.UseTokens then
        QBCore.Functions.TriggerCallback('cw-tokens:server:PlayerHasToken', function(result, value)
            tokens = result
        end)
        Wait(100)
        if tokens ~=nil and tokens[value] then return true else return false end
    end
    local itemInPockets = QBCore.Functions.HasItem('swap_token')
    if itemInPockets then return true else return false end
end

--- Create bosses
CreateThread(function()
    local boss = Config.Boss
    local animation
    if boss.animation then
        animation = boss.animation
    else
        animation = "WORLD_HUMAN_STAND_IMPATIENT"
    end
    
    RequestModel(boss.model)
    while not HasModelLoaded(boss.model) do
        Wait(1)
    end
    
    local options = {}
    for i,v in pairs(Config.Jobs) do
        local option = { 
            type = "client",
            event = "cw-boostjob:client:start",
            jobId = i,
            icon = "fas fa-circle",
            label = v.MissionDescription,
            canInteract = function()
                return canInteract(v.token)
            end
        }
        table.insert(options, option)
    end

    exports['qb-target']:SpawnPed({
        model = boss.model,
        coords = boss.coords,
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        scenario = animation,
        target = {
            options = options,
            distance = 3.0 
        },
        spawnNow = true,
    })

    --TODO add interaction with key box

end)




local function CleanUp()
    for i,npcType in pairs(npcs) do
        for j,v in pairs(npcType) do
            DeletePed(v)
        end
    end
    for i,vehicle in pairs(npcVehicles) do
        DeleteEntity(vehicle)
    end
    npcs = {
        ['npcguards'] = {},
        ['npccivilians'] = {}
    }
    
    npcVehicles = {}
end

RegisterCommand("cleanup", function(source)
    CleanUp()
end)

---Phone msgs
local function RunStart()
	Citizen.Wait(2000)

    local sender = Lang:t('mailstart.sender')
    local subject = Lang:t('mailstart.subject')
    local message = Lang:t('mailstart.message')

    if Config.Jobs[currentJobId].Messages then
        if Config.Jobs[currentJobId].Messages.First.Sender then 
            sender = Config.Jobs[currentJobId].Messages.First.Sender
        end
        if Config.Jobs[currentJobId].Messages.First.Subject then
            subject = Config.Jobs[currentJobId].Messages.First.Subject
        end
        if Config.Jobs[currentJobId].Messages.First.Message then
            message = Config.Jobs[currentJobId].Messages.First.Message
        end
    end

	TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
        subject = subject,
        message = message,
	})
	Citizen.Wait(3000)
end


local function CarTurnedInMessage()
    Citizen.Wait(2000)
    local sender = Lang:t('mailEnd.sender')
	local subject = Lang:t('mailEnd.subject')
	local message = Lang:t('mailEnd.message')

    if Config.Jobs[currentJobId].Messages then
        if Config.Jobs[currentJobId].Messages.Third then
            if Config.Jobs[currentJobId].Messages.Third.Sender then 
                sender = Config.Jobs[currentJobId].Messages.Third.Sender
            end
            if Config.Jobs[currentJobId].Messages.Third.Subject then
                subject = Config.Jobs[currentJobId].Messages.Third.Subject
            end
            if Config.Jobs[currentJobId].Messages.Third.Message then
                message = Config.Jobs[currentJobId].Messages.Third.Message
            end
        end
    end


	TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
	    subject = subject,
	    message = message,
	})

    QBCore.Functions.Notify(Lang:t("info.paperslip"), 'success')
    TriggerServerEvent('cw-boostjob:server:giveSlip', CurrentJob.Model)
    currentJobId = nil
    CurrentJobLocation = nil
    CurrentJob = nil
    DropoffSpot = nil
    DropoffSpotData = nil
end


local function carGps()
    -- TODO Fix police gps
    TriggerEvent('cw-boostjob:client:carTheftCall')
    if QBCore.Functions.GetPlayerData().job.name == 'police' then
        local vehicleCoords = GetEntityCoords(MissionVehicle)
        policeBlip = AddBlipForEntity(MissionVehicle)
        SetBlipSprite(policeBlip, 161)
        SetBlipScale(policeBlip, 1.4)
        PulseBlip(policeBlip)
        SetBlipColour(policeBlip, 1)
        SetBlipAsShortRange(policeBlip, true)
    end
end

local function TurnInCar()
    exports['qb-core']:HideText()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    CarTurnedInMessage()
    QBCore.Functions.DeleteVehicle(vehicle)
    RemoveBlip(deliveryBlip)
    CleanUp()
    onRun = false
end

local function CheckForKeypress()
    if next(DropoffSpotData) then
        CreateThread(function()
            while next(DropoffSpotData) do
                if IsControlJustReleased(0, 38) then TurnInCar() return end
                Wait(0)
            end
        end)
    end
end


local function SetupInteraction()
    local ped = PlayerPedId()
    if GetVehiclePedIsIn(ped, false) == MissionVehicle then
        local text = Lang:t('info.dropoff')
        text = '[E] '..text
        CheckForKeypress()
        exports['qb-core']:DrawText(text, 'left')
    end
end

local function getDropOffLocation()
    QBCore.Functions.Notify(Lang:t("success.car_beep_stop"), 'success')
    local rand = math.random(1,#Config.DropoffLocations)
    DropoffLocation = Config.DropoffLocations[rand]
    SetNewWaypoint(DropoffLocation.x, DropoffLocation.y)
    deliveryBlip = AddBlipForCoord(DropoffLocation)
    SetBlipSprite(deliveryBlip, 357)

    -- Create Dropoff
    -- PolyZone + Drawtext + Locations Management
    local _name = "dropoff-spot"
    DropoffSpot = BoxZone:Create(DropoffLocation, 10, 10, {
        name = _name,
        -- debugPoly = true,
        heading = DropoffLocation.w,
        minZ = DropoffLocation.z - 3.0,
        maxZ = DropoffLocation.z + 3.0,
    })
    DropoffSpot:onPlayerInOut(function(isPointInside, _)
        if isPointInside then
            -- print('is inside')
            DropoffSpotData = {
                ['spot'] = _name,
                ['coords'] = vector3(DropoffLocation.x, DropoffLocation.y, DropoffLocation.z),
                ['drawtextui'] = "Enter Dropoff Spot",
            }
        SetupInteraction()
        else
            DropoffSpotData = {}
            exports['qb-core']:HideText()
        end
    end)
end

local function CarAquiredMessage()
    Citizen.Wait(5000)
    local sender = Lang:t('mailSecond.sender')
	local subject = Lang:t('mailSecond.subject')
	local message = Lang:t('mailSecond.message')

    if Config.Jobs[currentJobId].Messages.Second then
        if Config.Jobs[currentJobId].Messages.Second.Sender then 
            sender = Config.Jobs[currentJobId].Messages.Second.Sender
        end
        if Config.Jobs[currentJobId].Messages.Second.Subject then
            subject = Config.Jobs[currentJobId].Messages.Second.Subject
        end
        if Config.Jobs[currentJobId].Messages.Second.Message then
            message = Config.Jobs[currentJobId].Messages.Second.Message
        end
    end

	TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
	    subject = subject,
	    message = message,
	})

    carGps()
    QBCore.Functions.Notify(Lang:t("success.car_beep"), 'success')
    Citizen.Wait(CurrentJob.Timer)
    RemoveBlip(policeBlip)
    getDropOffLocation()
end

---
local function SpawnVehicles()
    -- Mission car
    VehicleCoords = CurrentJobLocation.VehiclePosition
    RequestModel(CurrentJob.Model)
    while not HasModelLoaded(CurrentJob.Model) do
        Citizen.Wait(0)
    end

    ClearAreaOfVehicles(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 1.0, false, false, false, false, false)
    MissionVehicle = CreateVehicle(CurrentJob.Model, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, VehicleCoords.w, true, true)   
    SetNewWaypoint(VehicleCoords.x, VehicleCoords.y)
    vehicleBlip = AddBlipForEntity(MissionVehicle)
    SetBlipSprite(vehicleBlip, 225)

    -- Bad Guys cars
    local vehicles = CurrentJobLocation.GuardCars
    if vehicles then 
        for i,v in pairs(vehicles) do
            local GuardVehicleCoords = v.coords
            RequestModel(v.model)
            while not HasModelLoaded(v.model) do
                Citizen.Wait(0)
            end

            ClearAreaOfVehicles(GuardVehicleCoords.x, GuardVehicleCoords.y, GuardVehicleCoords.z, 1.0, false, false, false, false, false)
            local transport = CreateVehicle(v.model, GuardVehicleCoords.x, GuardVehicleCoords.y, GuardVehicleCoords.z, GuardVehicleCoords.w, true, true)
            table.insert(npcVehicles,transport)
        end
    end
end

-- local function SpawnCase()
--     local caseLocation = Config.Jobs[currentJobId].Items.FetchItemLocation
--     case = CreateObject(Config.Jobs[currentJobId].Items.FetchItemProp, caseLocation.x, caseLocation.y, caseLocation.z, true,  true, true)
--     SetNewWaypoint(caseLocation.x, caseLocation.y)
--     SetEntityHeading(case, caseLocation.w)
--     CreateObject(case)
--     FreezeEntityPosition(case, true)
--     SetEntityAsMissionEntity(case)
--     case = AddBlipForEntity(case)
--     SetBlipSprite(case, 457)
--     SetBlipColour(case, 2)
--     SetBlipFlashes(case, false)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString('Case')
--     EndTextCommandSetBlipName(case)
-- end

local function loadModel(model)
    if type(model) ~= 'number' then
        model = GetHashKey(model)
    end

    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

local function SpawnGuards()
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, 'PLAYER')
    AddRelationshipGroup('npcguards')
    
    local listOfGuardPositions = nil
    if CurrentJobLocation.GuardPositions ~= nil then
        listOfGuardPositions = shallowCopy(CurrentJobLocation.GuardPositions) -- these are used if random positions
    end

    for k, v in pairs(CurrentJobLocation.Guards) do
        local guardPosition = v.coords
        local animation = nil
        if guardPosition == nil then
            if listOfGuardPositions == nil then
                print('Someone made an oopsie when making guard positions!')
            else
                local random = math.random(1,#listOfGuardPositions)
                guardPosition = listOfGuardPositions[random]
                table.remove(listOfGuardPositions,random)
            end
        end
        local accuracy = Config.DefaultValues.accuracy
        if v.accuracy then
            accuracy = v.accuracy
        end
        local armor =  Config.DefaultValues.armor
        if v.armor then
            armor = v.armor
        end
        -- print('Guard location: ', guardPosition)
        loadModel(v.model)
        npcs['npcguards'][k] = CreatePed(26, GetHashKey(v.model), guardPosition, true, true)
        NetworkRegisterEntityAsNetworked(npcs['npcguards'][k])
        local networkID = NetworkGetNetworkIdFromEntity(npcs['npcguards'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(npcs['npcguards'][k], 0)
        SetPedRandomProps(npcs['npcguards'][k])
        SetEntityAsMissionEntity(npcs['npcguards'][k])
        SetEntityVisible(npcs['npcguards'][k], true)
        SetPedRelationshipGroupHash(npcs['npcguards'][k], 'npcguards')
        SetPedAccuracy(npcs['npcguards'][k], accuracy)
        SetPedArmour(npcs['npcguards'][k], armor)
        SetPedCanSwitchWeapon(npcs['npcguards'][k], true)
        SetPedDropsWeaponsWhenDead(npcs['npcguards'][k], false)
        SetPedFleeAttributes(npcs['npcguards'][k], 0, false)
        SetPedCombatAttributes(npcs['npcguards'][k], 46, true)
        local weapon = 'WEAPON_PISTOL'
        if v.weapon then
            weapon = v.weapon
        end
        GiveWeaponToPed(npcs['npcguards'][k], v.weapon, 255, false, false)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(npcs['npcguards'][k], 10.0, 10.0, 1)
        end
        Wait(1000)
    end

    SetRelationshipBetweenGroups(0, 'npcguards', 'npcguards')
    SetRelationshipBetweenGroups(5, 'npcguards', 'PLAYER')
    SetRelationshipBetweenGroups(5, 'PLAYER', 'npcguards')
end

local function SpawnCivilians()
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, 'PLAYER')
    AddRelationshipGroup('npccivilians')
    
    if CurrentJobLocation.Civilians then

        local listOfCivilianPositions = nil
        if CurrentJobLocation.CivilianPositions ~= nil then
            listOfCivilianPositions = shallowCopy(CurrentJobLocation.CivilianPositions) -- these are used if random positions
        end
        
        for k, v in pairs(CurrentJobLocation.Civilians) do
            local civPosition = v.coords
            if civPosition == nil then
                if listOfCivilianPositions == nil then
                    print('Someone made an oopsie when making civilian positions!')
                else
                    local random = math.random(1,#listOfCivilianPositions)
                    civPosition = listOfCivilianPositions[random]
                    table.remove(listOfCivilianPositions,random)
                end
            end
            -- print('Civ location: ', civPosition)
            loadModel(v.model)
            npcs['npccivilians'][k] = CreatePed(26, GetHashKey(v.model), civPosition, true, true)
            NetworkRegisterEntityAsNetworked(npcs['npccivilians'][k])
            local networkID = NetworkGetNetworkIdFromEntity(npcs['npccivilians'][k])
            SetNetworkIdCanMigrate(networkID, true)
            SetNetworkIdExistsOnAllMachines(networkID, true)
            SetPedRandomComponentVariation(npcs['npccivilians'][k], 0)
            SetPedRandomProps(npcs['npccivilians'][k])
            SetEntityAsMissionEntity(npcs['npccivilians'][k])
            SetEntityVisible(npcs['npccivilians'][k], true)
            SetPedRelationshipGroupHash(npcs['npccivilians'][k], 'npccivilians')
            SetPedArmour(npcs['npccivilians'][k], 10)
            SetPedFleeAttributes(npcs['npccivilians'][k], 0, true)

            local animation = "CODE_HUMAN_COWER"
            if v.animation then
                animation = v.animation
            end
            TaskStartScenarioInPlace(npcs['npccivilians'][k],  animation, 0, true)
            Wait(1000)
        end

        SetRelationshipBetweenGroups(3, 'npccivilians', 'npccivilians')
        SetRelationshipBetweenGroups(3, 'npccivilians', 'PLAYER')
        SetRelationshipBetweenGroups(3, 'PLAYER', 'npccivilians')
    end
end

local function CheckForCar()
    local ped = PlayerPedId()
    CreateThread(function()
        local isInVehicle = false
        while not isInVehicle do
            Wait(2000)
            -- print(GetVehiclePedIsIn(ped, false) == MissionVehicle)
            if ped then    
                if GetVehiclePedIsIn(ped, false) == MissionVehicle then 
                    RemoveBlip(vehicleBlip)
                    CarAquiredMessage()
                    isInVehicle = true
                end

            end
        end
    end)
end

RegisterNetEvent('cw-boostjob:client:runactivate', function()
    onRun = true
    RunStart()
    Citizen.Wait(4)
    SpawnGuards()
    SpawnCivilians()
    -- TODO ADD KEY CASE
    -- SpawnCase()
    SpawnVehicles()
    CheckForCar()
end)

RegisterNetEvent('cw-boostjob:client:start', function (data)
    if CurrentCops >= Config.Jobs[data.jobId].MinimumPolice then
        currentJobId = data.jobId

        CurrentJob = Config.Jobs[currentJobId]
        local rand = math.random(1, #CurrentJob.Locations)
        CurrentJobLocation = CurrentJob.Locations[rand]

        QBCore.Functions.TriggerCallback("cw-boostjob:server:coolc",function(isCooldown)
            if not isCooldown then
                TriggerEvent('animations:client:EmoteCommandStart', {"idle11"})
                QBCore.Functions.Progressbar("start_job", Lang:t('info.talking_to_boss'), 10000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                }, {}, {}, function() -- Done
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    TriggerServerEvent('cw-boostjob:server:startr', currentJobId)
                end, function() -- Cancel
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
                end)
            else
                QBCore.Functions.Notify(Lang:t("error.someone_recently_did_this"), 'error')
            end
        end)    
    else
        QBCore.Functions.Notify(Lang:t("error.cannot_do_this_right_now"), 'error')
    end
end)

local function MinigameSuccess()
    TriggerEvent('animations:client:EmoteCommandStart', {"type3"})
    QBCore.Functions.Progressbar("grab_case", "Unlocking case", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        RemoveBlip(case)
        TriggerServerEvent('cw-boostjob:server:unlock')

        local playerPedPos = GetEntityCoords(PlayerPedId(), true)
        local case = GetClosestObjectOfType(playerPedPos, 10.0, Config.Jobs[currentJobId].Items.FetchItemProp, false, false, false)
        if (IsPedActiveInScenario(PlayerPedId()) == false) then
        SetEntityAsMissionEntity(case, 1, 1)
        DeleteEntity(case)
        QBCore.Functions.Notify(Lang:t("success.you_removed_first_security_case"), 'success')
        Itemtimemsg()
        case = nil
    end
    end, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
    end)  
end

local function MinigameFailiure()
    QBCore.Functions.Notify(Lang:t("error.you_failed"), 'error')
end

local function StartMinigame()
    if Config.Jobs[currentJobId].Items.FetchItemMinigame then
        local type = Config.Jobs[currentJobId].Items.FetchItemMinigame.Type
        local variables = Config.Jobs[currentJobId].Items.FetchItemMinigame.Variables
        if type == "Circle" then
            exports['ps-ui']:Circle(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2]) -- NumberOfCircles, MS
        elseif type == "Maze" then
            exports['ps-ui']:Maze(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1]) -- Hack Time Limit
        elseif type == "VarHack" then
            exports['ps-ui']:VarHack(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
             end, variables[1], variables[2]) -- Number of Blocks, Time (seconds)
        elseif type == "Thermite" then 
            exports["ps-ui"]:Thermite(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2], variables[3]) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
        elseif type == "Scrambler" then
            exports['ps-ui']:Scrambler(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2], variables[3]) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
        end
    else
        exports["ps-ui"]:Thermite(function(success)
            if success then
                MinigameSuccess()
            else
                MinigameFailiure()
            end
        end, 8, 5, 3) -- Success       
    end
end

RegisterNetEvent('cw-boostjob:client:carTheftCall', function()
    if not isLoggedIn then return end
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == "police" and PlayerJob.onduty then
        local bank
        bank = "Fleeca"
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local vehicleCoords = GetEntityCoords(MissionVehicle)
        local s1, s2 = GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local streetLabel = street1
        if street2 then streetLabel = streetLabel .. " " .. street2 end
        local plate = GetVehicleNumberPlateText(MissionVehicle)
        TriggerServerEvent('police:server:policeAlert', Lang:t("police.alert")..plate)
    end
end)


RegisterCommand('swap', function (input)
    TriggerEvent('cw-boostjob:client:start', input)
end)