local QBCore = exports['qb-core']:GetCoreObject()

local lastPress = 0
local npcPed

Citizen.CreateThread(function()
    local npcModel = GetHashKey("mp_m_shopkeep_01") 

    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Citizen.Wait(100)
    end
    npcPed = CreatePed(4, npcModel, baTu.PatlicanSatmaKonumu.x, baTu.PatlicanSatmaKonumu.y, baTu.PatlicanSatmaKonumu.z - 1.0, baTu.PatlicanSatmaKonumu.w, false, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    TaskStartScenarioInPlace(npcPed, "WORLD_HUMAN_STAND_IMPATIENT", 0, true) 
    FreezeEntityPosition(npcPed, true)
end)

local function CheckSpam()
    local currentTime = GetGameTimer()
    if currentTime - lastPress < baTu.SpamUyariZamani then
        QBCore.Functions.Notify(baTu.NotifySpamUyarisi, "error")
        return true
    else
        lastPress = currentTime
        return false
    end
end

local function ToplaPatlican()
    if CheckSpam() then return end

    QBCore.Functions.Progressbar("topla_patlican", baTu.NotifyPatlicanTopla, baTu.ProgressToplamaSure * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('baTu-patlican:toplaPatlican')
    end)
end

local function IslePatlican()
    if CheckSpam() then return end

    QBCore.Functions.Progressbar("isle_patlican", baTu.NotifyPatlicanIsleme, baTu.ProgressIslemeSure * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('baTu-patlican:islePatlican')
    end)
end

local function SatPatlican()
    if CheckSpam() then return end

    local menuOptions = {
        {
            header = "Patlıcan Satışı",
            isMenuHeader = true
        },
        {
            header = "Patlıcan Sat",
            txt = "Patlıcanları satmak için tıklayın",
            params = {
                event = "baTu-patlican:satPatlican"
            }
        },
        {
            header = "İptal",
            txt = "İşlemi iptal et",
            params = {
                event = ""
            }
        }
    }

    exports['qb-menu']:openMenu(menuOptions)
end

RegisterNetEvent('baTu-patlican:satPatlican', function()
    local input = exports['qb-input']:ShowInput({
        header = "Patlıcan Satışı",
        submitText = "Onayla",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'patlicanAdet',
                text = 'Kaç adet patlıcan satmak istiyorsun?'
            }
        }
    })

    if input ~= nil then
        local patlicanAdet = tonumber(input.patlicanAdet)
        if patlicanAdet and patlicanAdet > 0 then
            exports['ps-ui']:OpenMiniGame({
                keys = baTu.PsUiKeys,
                correctKey = math.random(1, #baTu.PsUiKeys)
            }, function(success)
                if success then
                    TriggerServerEvent('baTu-patlican:satPatlican', patlicanAdet)
                else
                    QBCore.Functions.Notify("Başarısız!", "error")
                end
            end)
        else
            QBCore.Functions.Notify("Geçersiz miktar!", "error")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, konum in pairs(baTu.PatlicanToplaKonumlari) do
            if #(playerCoords - konum) < 2.0 then
                DrawText3D(konum.x, konum.y, konum.z, "[E] Patlıcan Topla")
                if IsControlJustPressed(0, 38) then
                    ToplaPatlican()
                end
            end
        end

        if #(playerCoords - baTu.PatlicanIslemeKonumu) < 2.0 then
            DrawText3D(baTu.PatlicanIslemeKonumu.x, baTu.PatlicanIslemeKonumu.y, baTu.PatlicanIslemeKonumu.z, "[E] Patlıcanları İşle")
            if IsControlJustPressed(0, 38) then
                IslePatlican()
            end
        end

        if #(playerCoords - baTu.PatlicanSatmaKonumu) < 2.0 then
            DrawText3D(baTu.PatlicanSatmaKonumu.x, baTu.PatlicanSatmaKonumu.y, baTu.PatlicanSatmaKonumu.z, "[E] Patlıcanları Sat")
            if IsControlJustPressed(0, 38) then
                SatPatlican()
            end
        end

        Citizen.Wait(0)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0, 0, 0, 75)
end
