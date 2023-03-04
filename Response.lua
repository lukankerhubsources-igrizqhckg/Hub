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

print(user)

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

local response = syn.request(
    {
        Url = "https://lukankerhub.com/synapse.php",  -- This website helps debug HTTP requests
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"  -- When sending JSON, set this!
        },
        Body = HttpService:JSONEncode(Data)
    }
)

local decoded_response = HttpService:JSONDecode(response.Body)
local user_data = decoded_response.user_data
local scripts_data = decoded_response.scripts_data

if user_data.ip and user_data.hwid then
    local source = Hub:GetLoadstring(game.PlaceId, scripts_data)
    loadstring(game:HttpGet(source))()
elseif not user_data.ip and user_data.hwid then
    print('YOUVE CHANGED LOCATION')
elseif not user_data.hwid and user_data.ip then
    print('YOURE ON A DIFFERENT MACHINE')
else 
    print('YOUVE CHANGED LOCATION AND CHANGED MACHINE')
end
