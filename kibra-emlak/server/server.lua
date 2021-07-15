ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('kibra-emlak:DepoSifreGuncelle')
AddEventHandler('kibra-emlak:DepoSifreGuncelle', function(sifre)
  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.execute('UPDATE kibra_emlak SET sifre = @sifre', {
          ['@sifre'] = sifre
      })
end)

ESX.RegisterServerCallback('kibra-emlak:SifreKontrol', function(source, sifree, cb)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT sifre FROM kibra_emlak WHERE id = 1',  { }, function(result)
        local sifree = result[1].sifre
    end)
end)

ESX.RegisterServerCallback('kibra-emlak:SifreKontrol', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    
end)


ESX.RegisterServerCallback('kibra-sikis-gel', function(source, cb) 
    local sifrex = nil
    --[[MySQL.Async.fetchAll('',  { }, function(result)
        sifrex = result[1].sifre
        print(sifrex)
    end) ]]
    local player = exports.ghmattimysql:executeSync("SELECT sifre FROM kibra_emlak ", {})
    if player[1] then
       sifrex = player[1].sifre
       cb(sifrex)
    end
end)

ESX.RegisterServerCallback("kibra-emlak:KasaSifrem", function(source, cb)
    local kasasifre = exports.ghmattimysql:executeSync("SELECT sifre FROM kibra_emlak", {})
    if kasasifre[1] then
        kasasifrex = kasasifre[1].sifre
    cb(kasasifrex)
    end
end)

RegisterServerEvent("kibra-emlak:AnahtarKontrol")
AddEventHandler("kibra-emlak:AnahtarKontrol", function()
local x = ESX.GetPlayerFromId(source)
if x.getQuantity('emlak_key') >= 1 then 
    TriggerClientEvent("kibra-emlak:DepoAciliyor", source)
else 
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Anahtarınız yok!' })
end
end)

RegisterServerEvent("kibra-emlak:AnahtarVer")
AddEventHandler("kibra-emlak:AnahtarVer", function()
    local x = ESX.GetPlayerFromId(source)
    if x.getQuantity('emlak_key') >= 2 then 
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Zaten 2 tane anahtarınız var!' })
    else 
        x.addInventoryItem('emlak_key', 1)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Bir tane anahtar çıkardınız!' })

    end
end)

ESX.RegisterServerCallback('kibra-emlak:KaraParaAkla', function(source, cb, gereklisayi)
	local xPlayer = ESX.GetPlayerFromId(source)
    local karapara = xPlayer.getQuantity('black_money')
	if karapara >= Config.GerekliSayi then
		cb(true)
	else
        activity = 0
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Üzerinde yeterli para yok!' })
	end
end)

RegisterServerEvent('kibra-emlak:paraakla')
AddEventHandler('kibra-emlak:paraakla', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local karapara = xPlayer.getQuantity('black_money')
    if karapara >= Config.GerekliSayi then
        xPlayer.removeInventoryItem('black_money', karapara)
        Citizen.Wait(500)
        local alacakpara = karapara / Config.Bolum
        xPlayer.addMoney(alacakpara)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = karapara..' Karapara Aklayarak '..alacakpara..'$ kazandınız!' })

    end
end)
