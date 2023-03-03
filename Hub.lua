local Hub = {}
local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()

local Games = {
	TreasureHuntSimulator = {
		id = 1345139196,
		source = 'https://raw.githubusercontent.com/' .. GitHubName .. '/Treasure-Hunt-Simulator/main/Treasure%20Hunt%20Sim.lua'
	},
	Deepwoken = {
		id = 6032399813,
		source = 'https://raw.githubusercontent.com/' .. GitHubName .. '/Deepsploit/main/Loader.lua'
	},
	TouchFootball = {
		id = 6125589657,
		source = 'https://raw.githubusercontent.com/' .. GitHubName .. '/Touch-Football/main/Touch-Football.lua'
	}
}

function Hub:GetLoadstring(GameID)
	for i, Game in pairs(Games) do
		if GameID == Game.id then
			return Game.source
		end
	end
end

return Hub
