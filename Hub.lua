local Hub = {
	TreasureHuntSimulator = {
		id = 1345139196,
		source = 'https://raw.githubusercontent.com/lukankerhubsources/Treasure-Hunt-Simulator/main/Treasure%20Hunt%20Sim.lua'
	},
	Deepwoken = {
		id = 4111023553,
		source = 'https://raw.githubusercontent.com/lukankerhubsources/Deepsploit/main/Loader.lua'
	},
	TouchFootball = {
		id = 6125589657,
		source = 'https://raw.githubusercontent.com/lukankerhubsources/Touch-Football/main/Touch-Football.lua'
	}
}

function Hub:GetLoadstring(GameID)
	for i, Game in pairs(Hub) do
		if GameID == Game.id then
			return Game.source
		end
	end
end

return Hub
