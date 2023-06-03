ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function checkAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = {}
    if xPlayer ~= nil then
        result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['identifier'] = xPlayer.identifier})
    end
    if result[1].group ~= nil and result[1].group == "admin" then
        return true
    end
    if result[1].group ~= nil and result[1].group == "_dev" then
    return true
    end
    if result[1].group ~= nil and result[1].group == "mod" then
    return true
    end
    return false
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

AddEventHandler('chatMessage', function(source, name, msg)
    sm = stringsplit(msg, " ");

    if source ~= nil then
        local check = checkAdmin(source)
        if check then
            if sm[1] == "/blips" then
                CancelEvent()
                TriggerClientEvent('mostraBlips', source)
            end
        else
        end
    end
end)

AddEventHandler('chatMessage', function(source, name, msg)
    sm = stringsplit(msg, " ");

    if source ~= nil then
        local check = checkAdmin(source)
        if check then
            if sm[1] == "/names" then
                CancelEvent()
                TriggerClientEvent('mostraNomi', source)
            end
        else
        end
    end
end)

expectedName = "NameTag" -- This is the resource and is not suggested to be changed.
resource = GetCurrentResourceName()

-- check if resource is renamed
if resource ~= expectedName then
    print("^1[^4" .. expectedName .. "^1] WARNING^0")
    print("Change the resource name to ^4" .. expectedName .. " ^0or else it won't work!")
end


print("^0This resource is created by ^5officerInSpeck#8630 ^0for support you can add me ")

-- check if resource version is up to date
PerformHttpRequest("GITHUBMANIFEST", function(error, res, head)
    i, j = string.find(tostring(res), "version")
    res = string.sub(tostring(res), i, j + 6)
    res = string.gsub(res, "version ", "")

    res = string.gsub(res, '"', "")
    resp = tonumber(res)
    verFile = GetResourceMetadata(expectedName, "version", 0)
    if verFile then
        if tonumber(verFile) < resp then
            print("^1[^4" .. expectedName .. "^1] WARNING^0")
            print("^4" .. expectedName .. " ^0is outdated. Please update it from ^5GITHUB^0| Current Version: ^1" .. verFile .. " ^0| New Version: ^2" .. resp .. " ^0|")
        elseif tonumber(verFile) > tonumber(resp) then
            print("^1[^4" .. expectedName .. "^1] WARNING^0")
            print("^4" .. expectedName .. "s ^0version number is higher than we expected. | Current Version: ^3" .. verFile .. " ^0| Expected Version: ^2" .. resp .. " ^0|")
        else
            print("^4" .. expectedName .. " ^0is up to date | Current Version: ^2" .. verFile .. " ^0|")
        end
    else
        print("^1[^4" .. expectedName .. "^1] WARNING^0")
        print("You may not have the latest version of ^4" .. expectedName .. "^0. A newer, improved version may be present at ^5GITHUB^0")
    end
end)
