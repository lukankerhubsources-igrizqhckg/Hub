local Hub = {}
local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()

local Games = {
	TreasureHuntSimulator = {
		name = 'Treasure-Hunt-Simulator',
		id = 1345139196,
		source = 'https://raw.githubusercontent.com/' .. GitHubName .. '/Treasure-Hunt-Simulator/main/Treasure%20Hunt%20Sim.lua'
	},
	Deepwoken = {
		name = 'Deepwoken',
		id = 6032399813,
		source = 'https://raw.githubusercontent.com/' .. GitHubName .. '/Deepsploit/main/Loader.lua'
	},
	TouchFootball = {
		name = 'Touch-Football',
		id = 6125589657,
		source = 'https://raw.githubusercontent.com/' .. GitHubName .. '/Touch-Football/main/Touch-Football.lua'
	}
}

function Hub:GetLoadstring(GameID, scripts_data)
	for i, Game in pairs(Games) do
		if GameID == Game.id then
			if scripts_data[Game.name] == '1' then
				return Game.source
			else if scripts_data[Game.name] == '0' then
					-- code buy prompt
					print('SCRIPT NOT OWNED')
					return nil
				end
			end
		end
	end
end

return Hub
