local M = {}

function M.new()
	local group = display.newGroup()
	native.setKeyboardFocus( nil )

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

	local mail = display.newImage(group, "Images/mail.png", -100, 0)
	mail:setReferencePoint( display.CenterReferencePoint )
	mail.x = cw/2 + 200
	mail.y = ch - 135
	mail:scale(0.8,0.8)

	local sheetData = { width=256, height=256, numFrames=2, sheetContentWidth=512, sheetContentHeight=256 }
	 
	local mySheet = graphics.newImageSheet( "Images/audio.png", sheetData )
	 
	local sequenceData = {
	   { name = "toggle", start=1, count=2 },
	}

	local audioAnimation = display.newSprite( mySheet, sequenceData )
	group:insert(audioAnimation)
	audioAnimation:scale(0.85, 0.85)
	audioAnimation.x = display.contentWidth/2 - 160  --center the sprite horizontally
	audioAnimation.y = display.contentHeight/2 + 370  --center the sprite vertically
	audioAnimation:setFrame(1)

	local function updateAudioToggle()
		local audioData = Load("audioData")
		print("Audio is...", audioData.toggle)
		if audioData.toggle == "on" then
			audioAnimation:setFrame(1)
		elseif audioData.toggle == "off" then
			audioAnimation:setFrame(2)
		end
	end
	updateAudioToggle()

	local function toggleAudio()
		local audioData = Load("audioData")
		if audioData.toggle == "on" then
			audioData.toggle = "off"
			Save(audioData, "audioData")
			updateAudioToggle()
		elseif audioData.toggle == "off" then
			audioData.toggle = "on"
			Save(audioData, "audioData")
			updateAudioToggle()
		end
	end
	audioAnimation:addEventListener("tap", toggleAudio)
	 	
	local function newMail(event)
		system.openURL( "mailto:appdojostudios@gmail.com?subject=Llama Or Duck Game&body=")
	end
	mail:addEventListener("tap", newMail)

	local function displayLoadingScreen()
		local loadingScreen = display.newRect(group, 0, 0, cw, ch)
		loadingScreen:setFillColor(0,0,0)
		loadingScreen.alpha = 0.5
		local loadingText = display.newText(group, "Loading...", cw/2 , ch/2, "DimitriSwank", 60)
		loadingText.x = cw/2
		loadingText.y = ch/2 - 39

		local function loadingScreenListener()
			return true
		end
		loadingScreen:addEventListener("touch", loadingScreenListener)
		timer.performWithDelay( 100, function () director:changeScene("gameNew") end, 1)
	end

	local playBtn = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2 - 175, cw/2, false, 1, 0, nil, "Play", "DimitriSwank", 80, displayLoadingScreen, nil)
	local leaderboardsBtnH = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2 - 175, cw/2 + 200, false, 1, 0, "leaderboards", "Highscores", "DimitriSwank", 57, nil, nil)
	local creditsBtn = displayNewButton(group, "Images/buttonUpSmall.png", "Images/buttonDownSmall.png", cw-200, 10, false, 1, nil, "creditsPage", "Credits", "DimitriSwank", 40, nil, nil)	

	--group:insert(leaderboardsBtnH)
	--director:changeScene("game")

	return group
end

return M