local HttpService = game:GetService("HttpService")
local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()
local Hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GitHubName .. "/Hub/main/Hub.lua"))()

local Data = {
    ['key'] = getgenv().lukankerKey,
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

-- RATIO FILTHY BLACK NIGGER
