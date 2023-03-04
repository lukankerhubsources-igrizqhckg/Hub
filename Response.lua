local HttpService = game:GetService("HttpService")
local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()
local Hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GitHubName .. "/Hub/main/Hub.lua"))()

local hwidResponse = syn.request({
    Url = "https://httpbin.org/get",
    Method = "GET"
})

setclipboard(HttpService:JSONDecode(hwidResponse.Body).headers['Syn-Fingerprint'])

local Data = {
    ['key'] = getgenv().lukankerKey,
    ['hwid'] = HttpService:JSONDecode(hwidResponse.Body).headers['Syn-Fingerprint'],
    ['gameid'] = game.PlaceId
}

local source = syn.request(
    {
        Url = "https://lukankerhub.com/synapse-igrizqhckg",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(Data)
    }
)
source.Body = 'https://raw.githubusercontent.com/' .. GitHubName .. source.Body
loadstring(game:HttpGet(source.Body))()
