local KullandiginVersiyon = nil
PerformHttpRequest("https://raw.githubusercontent.com/FiveEngine/baTu-patlican/refs/heads/main/fxmanifest.lua", function(err, text, headers)
    if err == 200 then
        KullandiginVersiyon = LoadResourceFile(GetCurrentResourceName(), "fxmanifest.lua"):match("version '(%d+%.%d+%.%d+)'")
        local GuncelVersiyon = text:match("version '(%d+%.%d+%.%d+)'")

        if GuncelVersiyon then
            if KullandiginVersiyon ~= GuncelVersiyon then
                print("^1[Uyarı]: Script'iniz güncel değil! En son sürüm: " .. GuncelVersiyon .. " | Mevcut sürüm: " .. KullandiginVersiyon .. "^0")
            else
                print("^2[Bilgi]: Script'iniz güncel! Sürüm: " .. KullandiginVersiyon .. "^0")
                print("^2Thanks For FiveEngine")
            end
        else
            print("^3[Hata]: GitHub'dan sürüm bilgisi alınamadı. fxmanifest.lua dosyasında 'version' anahtarı bulunamadı.^0")
        end
    else
        print("^3[Hata]: Sürüm kontrolü sırasında bir hata oluştu. Lütfen URL'nin doğru olduğundan emin olun.^0")
    end
end)
