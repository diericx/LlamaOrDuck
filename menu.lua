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

	local function displayLoadingScreen()
		local loadingScreen = display.newRect(group, 0, 0, cw, ch)
		loadingScreen:setFillColor(0,0,0)
		loadingScreen.alpha = 0.5
		local loadingText = display.newText(group, "Loading...", cw/2, ch/2, "DimitriSwank", 60)
		loadingText.x = cw/2
		loadingText.y = ch/2 - 50

		local function loadingScreenListener()
			return true
		end
		loadingScreen:addEventListener("touch", loadingScreenListener)
		timer.performWithDelay( 100, function () director:changeScene("gameNew") end, 1)
	end

	local playBtn = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2 - 175, cw/2, false, 1, 0, nil, "Play", "DimitriSwank", 80, displayLoadingScreen, nil)
	local leaderboardsBtnH = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2 - 175, cw/2 + 200, false, 1, 0, "leaderboards", "Highscores", "DimitriSwank", 57, nil, nil)
	
	--group:insert(leaderboardsBtnH)
	--director:changeScene("game")

	return group
end

return M