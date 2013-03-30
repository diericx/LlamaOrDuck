local M = {}

function M.new()
	local group = display.newGroup()

	--check for ser info, if there create header
	local userInfo = Load("userInfo", userInfo)

	--server stuff
	headers = {}
	headers["Accept"] = "application/json"

	if userInfo ~= nil and userInfo.authKey ~= nil then
		headers["Authorization"] = "Token token="..tostring(userInfo.authKey)
	end

	local bg = display.newImage(group, "Images/bg.png", 0, 0)
	bg:rotate(0)
	bg.x = cw/2
	bg.y = ch/2

	local playBtn = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2 - 175, cw/2, false, 1, 0, "gameNew", "Play", "DimitriSwank", 80, nil)
	local leaderboardsBtnH = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2 - 175, cw/2 + 200, false, 1, 0, "leaderboards", "Highscores", "DimitriSwank", 57, nil)
	
	--group:insert(leaderboardsBtnH)
	--director:changeScene("game")

	return group
end

return M