local HttpService = game:GetService("HttpService")
local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()
local Hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GitHubName .. "/Hub/main/Hub.lua"))()

local keyResponse = syn.request(
    {
        Url = "https://lukankerhub.com/encryption.php",  -- This website helps debug HTTP requests
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"  -- When sending JSON, set this!
        },
        Body = HttpService:JSONEncode(getgenv().lukankerKey)
    }
)

local user = keyResponse.Body

local hwidResponse = syn.request({
    Url = "https://httpbin.org/get",
    Method = "GET"
})

local ip = game:HttpGet('https://api.ipify.org/?format=raw', true)
local hwid = HttpService:JSONDecode(hwidResponse.Body).headers['Syn-Fingerprint']

local Data = {
    ['username'] = user,
    ['ip'] = ip,
    ['hwid'] = hwid,
    ['gameid'] = game.PlaceId
}

local source = syn.request(
    {
        Url = "https://lukankerhub.com/synapse.php",  -- This website helps debug HTTP requests
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"  -- When sending JSON, set this!
        },
        Body = HttpService:JSONEncode(Data)
    }
)

source.Body = 'https://raw.githubusercontent.com/' .. GitHubName .. source.Body
loadstring(game:HttpGet(source.Body))()
