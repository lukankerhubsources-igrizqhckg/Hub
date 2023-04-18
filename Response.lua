local GCI = 0;
local SF = 0;
local PCC = 0;
local ALH = 0;
local Hooked = false

local GCRegister = function(C)
    if tostring(C) == 'hookfunction' then
        ALH = ALH + 1
        if ALH >= 3 then
            Hooked = true
        end
    end
end

while true do
    GCI = GCI + 1
    if getgc()[GCI] == nil then break; end
    local GCF = getgc()[GCI]
    local FC = false;
    if is_synapse_function(GCF) then
        SF = SF + 1
        local CPC = pcall(function() getconstants(GCF) end)
        local CPCD = pcall(function() debug.getconstants(GCF) end)
        if CPC or CPCD then
            PCC = PCC + 1
            local GCC = 0;
            while true do
                if #getconstants(GCF) == GCC or #getconstants(GCF) == GCC then break; end
                GCC = GCC + 1
                local C = CPC and getconstants(GCF)[GCC] or debug.getconstants(GCF)[GCC]
                GCRegister(C)
            end
        end
    end
end

if SF < 300 or GCI < 2000 or PCC < 100 or ALH >= 3 then
    Hooked = true
end

if not Hooked then
    local HttpService = game:GetService("HttpService")
    local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()

    local hwidResponse = syn.request({
        Url = "https://httpbin.org/get",
        Method = "GET"
    })

    local Data = {
        ['key'] = getgenv().lukankerKey,
        ['hwid'] = HttpService:JSONDecode(hwidResponse.Body).headers['Syn-Fingerprint'],
        ['gameid'] = game.PlaceId
    }

    local source = syn.request({
        Url = "https://lukankerhub.com/synapse-igrizqhckg",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(Data)
    })
    source.Body = 'https://raw.githubusercontent.com/' .. GitHubName .. source.Body
    loadstring(game:HttpGet(source.Body))()
else
    game.Players.LocalPlayer:Kick('Something went wrong, try again later')
end
