local HttpService = game:GetService("HttpService")
local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()

-- local hwidResponse = syn.request({
--     Url = "https://httpbin.org/get",
--     Method = "GET"
-- })

local Data = {
    ['key'] = getgenv().lukankerKey,
    --['hwid'] = HttpService:JSONDecode(hwidResponse.Body).headers['Syn-Fingerprint'],
    ['hwid'] = game:GetService("RbxAnalyticsService"):GetClientId(),
    ['gameid'] = game.PlaceId
}

local source = request({
    Url = "https://lukankerhub.com/synapse-igrizqhckg",
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode(Data)
})

source.Body = 'https://raw.githubusercontent.com/' .. GitHubName .. source.Body
loadstring(game:HttpGet(source.Body))()
