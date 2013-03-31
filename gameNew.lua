local M = {}

function M.new()
	local widget = require( "widget" )

	local group = display.newGroup()
	local llamaDuckPics = display.newGroup()
	group:insert(llamaDuckPics)

	local picsTable = {}
	local reactSpeeds = {}
	local numberOfImages = 7
	local newImageTime = 60
	local score = 0
	local newImageCooldown = 60
	local gameOver = false
	local oldRandomImage
	local llamaOrDuck
	local retryBtn
	local menuBtn
	local leaderBoardsBtn
	local llamaBtn
	local duckBtn
	local scoreText

	-- scoredojo.refreshUserData("https://scoredojo.com/api/v1/", "536f2b4067689c1b1632f87e6a2ef31b")

	local function loadImages ()
		for i = 1, (numberOfImages*2) do
			local folder
			local picNumb
			if i <= numberOfImages then
				folder = "llama"
				picNumb = i
			elseif i > numberOfImages then
				folder = "duck"
				picNumb = i - numberOfImages
			end
			local test = "Images/"..tostring(folder).."/"..tostring(picNumb)..".png"
			print (test)
			local image = display.newImage(group, "Images/"..tostring(folder).."/"..tostring(picNumb)..".png", 10000, 10000)
			image.display = false
			picTablePosition = #picsTable + 1
			picsTable[picTablePosition] = image
		end
	end
	loadImages()

	local function displayNewPic ()
		llamaOrDuck = math.random(1,2)
		local randomImage = math.random( 1, numberOfImages )
		local folder

		if llamaOrDuck == 1 then
			randomImage = randomImage + numberOfImages
		end

		if randomImage == oldRandomImage then
			if randomImage > numberOfImages then
				randomImage = randomImage - 1
			elseif randomImage < numberOfImages then
				randomImage = randomImage + 1
			end
		end


		for i = 1, #picsTable do
			if picsTable[i].display == true then
				picsTable[i].display = false
			end
		end
		print(randomImage)
		picsTable[randomImage].display = true

		oldRandomImage = randomImage
	end
	displayNewPic()

	local function endGame ()
		local darkener = display.newRect(group, 0,0,cw,ch)
		darkener:setFillColor(0,0,0)
		darkener.alpha = 0.5

		local yourScoreTxt = display.newText(group, "Your Score:", 0, 0, "DimitriSwank", 80)
		yourScoreTxt.x, yourScoreTxt.y = cw/2, ch/2-400
		yourScoreTxt:setTextColor(255, 255, 255)

		-- local yourSpeedTxt = display.newText(group, "Your Average Speed:", 0, 0, native.SystemDefaultFont, 60)
		-- yourSpeedTxt.x, yourSpeedTxt.y = cw/2, ch/2 + 150
		-- yourSpeedTxt:setTextColor(255, 255, 255)
		
		-- local yourSpeedNumbTxt = display.newText(group, "", 0, 0, native.SystemDefaultFont, 60)
		-- yourSpeedNumbTxt.x, yourSpeedNumbTxt.y = cw/2, ch/2 + 200
		-- yourSpeedNumbTxt:setTextColor(255, 255, 255)
		
		--calculate avg speed
		-- local totalOfSpeeds = 0
		-- for i = 1, #reactSpeeds do
		-- 	totalOfSpeeds = totalOfSpeeds + reactSpeeds[i]
		-- end
		-- local avgSpeed = totalOfSpeeds / #reactSpeeds
		-- yourSpeedNumbTxt.text = math.round(avgSpeed)

		scoreText.y = yourScoreTxt.y + 120
		scoreText:toFront()

		retryBtn.x, retryBtn.y = cw/2-150,  ch/2-200
		retryBtn:toFront()

		menuBtn.x, menuBtn.y = cw/2-150,  ch/2 - 50
		menuBtn:toFront()

		leaderBoardsBtn.x, leaderBoardsBtn.y = cw/2-150-26,  ch/2 + 100
		leaderBoardsBtn:toFront()

		llamaBtn.x, duckBtn.x = 100000, 100000
		gameOver = true

		scoredojo.submitHighscore ("https://scoredojo.com/api/v1/", "536f2b4067689c1b1632f87e6a2ef31b", 1, score)

		setEnterFrame(nil)

	end

	local function onButtonEvent( objects )
		print(objects[1])
	   --local phase = event.phase
	   local target = objects[1]
	    --  if ( "began" == phase ) then
	   --elseif ( "ended" == phase ) then
	      print( target.id .. " released" )
	      if (target.id == "llama" and llamaOrDuck == 1) or (target.id == "duck" and llamaOrDuck == 2) then
	      	endGame()
	      else
	      	if gameOver == false then
	      		--add score according to speed
		      	print("NEW IMAGE CD = ", newImageCooldown)
		      	score = score + math.round((newImageCooldown / 60)*100)
		      	scoreText.text = score
		      	--add speed to table
		      	local tablePos = #reactSpeeds + 1
		      	reactSpeeds[tablePos] = newImageCooldown
		      	--reset stuff
		      	newImageCooldown = newImageTime
		      	displayNewPic()
		    end
	      end
	      if target.id == "retry" then
	      	director:changeScene("restart")
	      end
	   --end
	   return true
	end

	local function onRetryButtonEvent( event )
	   local phase = event.phase
	   local target = event.target
	      if ( "began" == phase ) then
	      --print( target.id .. " pressed" )
	      --target:setLabel( "Pressed" )  --set a new label
	   elseif ( "ended" == phase ) then
	      if target.id == "retry" then
	      	director:changeScene("restart")
	      end
	      --target:setLabel( target.baseLabel )  --reset the label
	   end
	   return true
	end

	-- local llamaBtn = widget.newButton
	-- {
	--    left = 10,
	--    top = ch-100,
	--    label = "Llama",
	--    labelAlign = "center",
	--    font = "Arial",
	--    fontSize = 30,
	--    labelColor = { default = {0,0,0}, over = {200,200,200} },
	--    onEvent = onButtonEvent
	-- }
	-- llamaBtn.baseLabel = "Default"
	-- llamaBtn.id = "llama"
	-- group:insert(llamaBtn)

	llamaBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-600, ch-150, false, 1, nil, nil, "Llama", "DimitriSwank", 60, onButtonEvent, "llama")

	duckBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-300, ch-150, false, 1, nil, nil, "Duck", "DimitriSwank", 60, onButtonEvent, "duck")

	retryBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2-100050, ch/2-200000, false, 1, nil, "restart", "Retry", "DimitriSwank", 60, nil, nil)	

	menuBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2-100050, ch/2-200000, false, 1, nil, "menu", "Menu", "DimitriSwank", 60, nil, nil)	

	leaderBoardsBtn = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2-100050, ch/2-200000, false, 1, nil, "leaderboards", "Highscores", "DimitriSwank", 55, nil, nil)	

	scoreText = display.newText(score, 0, 0, native.SystemDefaultFont, 90 )
	group:insert(scoreText)
	scoreText.x = cw/2
	scoreText.y = ch/2 - 450
	-- local duckBtn = widget.newButton
	-- {
	--    left = cw-210,
	--    top = ch-100,
	--    label = "Duck",
	--    labelAlign = "center",
	--    font = "Arial",
	--    fontSize = 30,
	--    labelColor = { default = {0,0,0}, over = {200,200,200} },
	--    onEvent = onButtonEvent
	-- }
	-- duckBtn.baseLabel = "Default"
	-- duckBtn.id = "duck"
	-- group:insert(duckBtn)

	-- retryBtn = widget.newButton
	-- {
	--    left = cw/2-100*1000,
	--    top = ch/2-100*1000,
	--    label = "Retry",
	--    labelAlign = "center",
	--    font = "Arial",
	--    fontSize = 30,
	--    labelColor = { default = {0,0,0}, over = {200,200,200} },
	--    onEvent = onRetryButtonEvent
	-- }
	-- retryBtn.baseLabel = "Default"
	-- retryBtn.id = "retry"
	-- group:insert(retryBtn)

	local function enterframe()
		for i = 1, #picsTable do
			if picsTable[i].display == true then
				picsTable[i].x = cw/2
				picsTable[i].y = ch/2
			elseif picsTable[i].display == false then
				picsTable[i].x = 10000
				picsTable[i].y = 10000
			end
		end

		if newImageCooldown > 0 then
			newImageCooldown = newImageCooldown - 1
		elseif newImageCooldown <= 0 then
			endGame()
			setEnterFrame(nil)
		end
	end
	setEnterFrame(enterframe)

	return group
end

return M