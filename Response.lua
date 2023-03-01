local HttpService = game:GetService("HttpService")

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
        Url = "https://ae65-2001-1c04-4786-0-6dbc-b04e-b57c-ff34.eu.ngrok.io/top_d/synapse.php",  -- This website helps debug HTTP requests
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"  -- When sending JSON, set this!
        },
        Body = HttpService:JSONEncode(Data)
    }
)

local decoded_response = HttpService:JSONDecode(response.Body)

if decoded_response.ip and decoded_response.hwid then
    print('YOURE IN')
elseif not decoded_response.ip then
    print('YOUVE CHANGED LOCATION')
else if not decoded_response.hwid then
    print('YOURE ON A DIFFERENT MACINE')
else 
    print('YOUVE CHANGED LOCATION AND CHANGED MACHINE')
end
