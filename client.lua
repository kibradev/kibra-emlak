ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
while true do 
Wait(0)
local ped = PlayerPedId()
local pkordinat = GetEntityCoords(ped)
for k,v in pairs(Config.EmlakMenu) do 
local dist = #(pkordinat - v)
if dist < 1 then 
    if ESX.GetPlayerData().job.grade_name == "Emlak" then 
    DrawText3D(v.x, v.y, v.z + 0.2, '~g~E~s~ - Emlak Menüsü')
    if IsControlJustPressed(0, 38) then 
        OpenMenu()
    else
        end
    end
end
end
end
end)

RegisterCommand("kasasifrem", function()
    ESX.TriggerServerCallback('kibra-sikis-gel', function(bilgi)
    exports['mythic_notify']:SendAlert('inform', 'Emlakçı Kasa Şifreniz: '..bilgi)
end)
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
local ped = PlayerPedId()
local pkordinat = GetEntityCoords(ped)
for k,v in pairs(Config.EmlakDepo) do 
    local dist2 = #(pkordinat - v)
    if dist2 < 1 then 

        DrawText3D(v.x, v.y, v.z + 0.2, '~g~E~s~ - Emlak Deposu')
        if IsControlJustPressed(0, 38) then 
        DepoAc()
        end
    
else 
end
end
    end
end)



RegisterNetEvent("kibra-emlak:DepoAciliyor")
AddEventHandler("kibra-emlak:DepoAciliyor", function() 
    TriggerEvent("mythic_progbar:client:progress", {
        name = "depoaciliyor",
        duration = 3000,
        label = "Depo Açılıyor",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistfbisetup1",
            anim = "unlock_loop_janitor",
            flags = 49,
        },
        prop = {
            model = "p_car_keys_01",
        }
    }, function(status)
        if not status then
            -- Do Something If Event Wasn't Cancelled
        end
    end)
    Citizen.Wait(3000)
    sifrekontrol()

end)

DepoAc = function()
    if IsControlJustPressed(0, 38) then 
        TriggerServerEvent("kibra-emlak:AnahtarKontrol")
    end
end

function OpenMenu()

	local elements = {
		{label = "Depo Şifresini Değiştir", value = 'sifredegistir'},
        {label = "Depo Anahtarı Çıkart", value = 'yedekanahtar'},
        {label = "Para Aklama", value = 'paraislem'}

	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'KibraDevWorks', {
		title    = "Emlak Patron Menüsü",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'sifredegistir' then
			sifrechange()
        elseif data.current.value == 'yedekanahtar' then 
            anahtarcikart()
        elseif data.current.value == 'paraislem' then 
            OpenParaMenu()
		end
	end, function(data, menu)
		menu.close()
	end)

end

function OpenParaMenu()
    ESX.TriggerServerCallback('kibra-emlak:KaraParaAkla', function(data)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'karapara',
    {
        title = "Para Aklama"
},
function(data5, menu5)

menu5.close()

local karapara = data5.value
      Citizen.Wait(300)
      TriggerServerEvent('kibra-emlak:paraakla', karapara)
Wait(1000)
ClearPedTasks(ped)
end, function(data5, menu5)
end)
menu5.close()
end)
end

sifrechange = function() 
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'aciklama',
    {
        title = "Depo Şifresi"
},
function(data4, menu4)

menu4.close()

local sifre = data4.value
      Citizen.Wait(300)
TriggerServerEvent("kibra-emlak:DepoSifreGuncelle", sifre)
exports['swt_notifications']:Success("Emlakçılık","Depo şifreniz güncellendi","top",2000,true)
Wait(1000)
ClearPedTasks(ped)
end, function(data4, menu4)
end)
menu4.close()
end

anahtarcikart = function()
    TriggerServerEvent("kibra-emlak:AnahtarVer")
end
 
Citizen.CreateThread(function()
      local blip = AddBlipForCoord(Config.BlipKord)
      SetBlipSprite(blip, 280)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, 0.6)
      SetBlipColour(blip, 1)
      SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Emlakçı")
      EndTextCommandSetBlipName(blip)
    
end)

sifrekontrol = function()
   
    ESX.TriggerServerCallback('kibra-sikis-gel', function(bilgi)
 
 
        
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Şifreniz',
    {
      title = "Şifrenizi Girin"
    },
function(data1, menu1)
  menu1.close()
  print(data1.value.." "..bilgi)
  if tonumber(data1.value) == tonumber(bilgi) then
    OpenDepo()
else
    print("şifre yanlış")
    exports['mythic_notify']:SendAlert('inform', 'Şifre Yanlış.')
end

end)
end)
end








OpenDepo = function()
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Emlak")
        TriggerEvent("inventory:client:SetCurrentStash", "Emlak")
end

DrawText3D = function (x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
