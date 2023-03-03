local HttpService = game:GetService("HttpService")
local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()
local Hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GitHubName .. "/Hub/main/Hub.lua"))()

local hwidResponse = syn.request({
    Url = "https://httpbin.org/get",
    Method = "GET"
})

local ip = game:HttpGet('https://api.ipify.org/?format=raw', true)
local hwid = HttpService:JSONDecode(hwidResponse.Body).headers['Syn-Fingerprint']

local Data = {
    ['username'] = 'lukanker',
    ['ip'] = ip,
    ['hwid'] = hwid
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

if decoded_response.ip and decoded_response.hwid then
    loadstring(game:HttpGet(Hub:GetLoadstring(game.PlaceId)))()
elseif not decoded_response.ip then
    print('YOUVE CHANGED LOCATION')
elseif not decoded_response.hwid then
    print('YOURE ON A DIFFERENT MACHINE')
else 
    print('YOUVE CHANGED LOCATION AND CHANGED MACHINE')
end
