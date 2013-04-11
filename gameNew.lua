local M = {}

function M.new()
	local widget = require( "widget" )

	local group = display.newGroup()
	local llamaDuckPics = display.newGroup()
	group:insert(llamaDuckPics)

	local picsTable = {}
	local reactSpeeds = {}
	local numberOfImages = 7
	local newImageTime = 55 --55
	local score = 0
	local newImageCooldown = 150 --150
	local gameOver = false
	local tooSlow = false
	local falseAnswer = false
	local oldRandomImage
	local llamaOrDuck
	local retryBtn
	local menuBtn
	local leaderBoardsBtn
	local llamaBtn
	local duckBtn
	local scoreText
	local yourFault
	local yourScoreTxt
	local darkener
	local enterframe
	local signInTxt
	local countdownToStart
	local audioData = Load("audioData")


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

	--load audio
	-- local correctSound = audio.loadSound("correct.mp3")
	-- local wrongSound = audio.loadSound("wrong.mp3")
	-- local crowdSound = audio.loadSound("crowd.mp3")

	local function displayNewPic ()

		repeat 
			llamaOrDuck = math.random(1,2)
			newRandomImage = math.random(1, numberOfImages) 
			if llamaOrDuck == 1 then
					newRandomImage = newRandomImage + numberOfImages
			end
		until newRandomImage ~= randomImage

		randomImage = newRandomImage


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
		if tooSlow == true then
			yourFault.text = "You were too slow!"
		elseif falseAnswer == true then
			yourFault.text = "Wrong answer!"
		end
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
		darkener.x = 0

		yourScoreTxt.x, yourScoreTxt.y = cw/2, ch/2-300

		scoreText.y = yourScoreTxt.y + 120
		scoreText:toFront()

		retryBtn.x, retryBtn.y = cw/2-150,  ch/2-100
		retryBtn:toFront()

		menuBtn.x, menuBtn.y = cw/2-150,  ch/2 + 50
		menuBtn:toFront()

		leaderBoardsBtn.x, leaderBoardsBtn.y = cw/2-150-26,  ch/2 + 200
		leaderBoardsBtn:toFront()

		llamaBtn.x, duckBtn.x = 100000, 100000
		gameOver = true

		local userInfo = Load("userInfo")
		if userInfo then
			scoredojo.submitHighscore ("https://scoredojo.com/api/v1/", "536f2b4067689c1b1632f87e6a2ef31b", 1, score)
		else 
			signInTxt.y = ch-50
		end

		setEnterFrame(nil)

	end

	local function restart()

		print("RESTART")
		darkener.x = 100000

		yourScoreTxt.x = 100000
		
		yourFault.text = ""

		scoreText.y = 100000

		retryBtn.x, retryBtn.y = cw/2-1000050,  ch/2-100

		menuBtn.x, menuBtn.y = cw/2-1000050,  ch/2 + 50

		leaderBoardsBtn.x, leaderBoardsBtn.y = cw/2-1500000-26,  ch/2 + 200

		llamaBtn.x, duckBtn.x = cw-600, cw-300

		signInTxt.y = ch-50000

		scoreText.x = cw/2
		scoreText.y = ch/2 - 450

		llamaBtn.x, duckBtn.x = 100000, 100000

		newImageCooldown = 180

		score = 0
		scoreText.text = score

		tooSlow = false
		falseAnswer = false 
		gameOver = false

		countdownToStart()

		setEnterFrame(enterframe)	

	end

	local function onButtonEvent( objects )
		print(objects[1])
	   --local phase = event.phase
	   local target = objects[1]
	    --  if ( "began" == phase ) then
	   --elseif ( "ended" == phase ) then
	      print( target.id .. " released" )
	      if (target.id == "llama" and llamaOrDuck == 1) or (target.id == "duck" and llamaOrDuck == 2) then
	      		if audioData.toggle == "on" then
	      			media.playSound("wrong.mp3")
	      		end
	      		--audio.play(wrongSound)
	      		--audio.play(crowdSound)
	      		falseAnswer = true
	      		endGame()
	      else
	      	if gameOver == false then
	      		if audioData.toggle == "on" then
	      			media.playSound("correct.mp3")
	      		end
	      		--add score according to speed
	      		--audio.play(correctSound)
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

	retryBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2-100050, ch/2-200000, false, 1, nil, nil, "Retry", "DimitriSwank", 60, restart, nil)	

	menuBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2-100050, ch/2-200000, false, 1, nil, "menu", "Menu", "DimitriSwank", 60, nil, nil)	

	leaderBoardsBtn = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2-100050, ch/2-200000, false, 1, nil, "leaderboards", "Highscores", "DimitriSwank", 55, nil, nil)	
	
	darkener = display.newRect(group, 100000,0,cw,ch)
	darkener:setFillColor(0,0,0)
	darkener.alpha = 0.5
	darkener:setReferencePoint(display.TopLeftReferencePoint)

	yourScoreTxt = display.newText(group, "Your Score:", 0, 0, "DimitriSwank", 80)
	yourScoreTxt.x, yourScoreTxt.y = cw/2, ch/2-30000
	yourScoreTxt:setTextColor(255, 255, 255)
	--yourScoreTxt:setReferencePoint(display.TopLeftReferencePoint)
	
	yourFault = display.newText(group, "", 0, 0, "DimitriSwank", 60)
	yourFault.x, yourFault.y = cw/2, ch/2-450
	yourFault:setTextColor(200, 0, 0)
	yourFault:setReferencePoint(display.TopLeftReferencePoint)
	
	scoreText = display.newText(score, 0, 0, native.SystemDefaultFont, 90 )
	group:insert(scoreText)
	scoreText.x = cw/2
	scoreText.y = ch/2 - 450

	signInTxt = display.newText(group, "You need to login or create a Scoredojo account to view or submit highscores!", 23, 0, cw, 200, "Mensch", 33 )
	signInTxt.y = ch-50000

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

	function enterframe()
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
			if audioData.toggle == "on" then
				media.playSound("wrong.mp3")
			end
			--audio.play(wrongSound)
			--audio.play(crowdSound)
			tooSlow = true
			endGame()
			setEnterFrame(nil)
		end
	end
	setEnterFrame(enterframe)

	function countdownToStart ()
		local readySetGo = 0
		local scaleTime = 500
		local readySetGoTxt = display.newText(group, "Ready!", 0, 0, "DimitriSwank", 80)
		readySetGoTxt.x, readySetGoTxt.y = cw/2, ch/2
		transition.to(readySetGoTxt, {time=scaleTime, xScale = 2, yScale = 2, alpha = 0})
		local function readySetGoFunct ()
			readySetGo = readySetGo + 1
			if readySetGo == 1 then 
				readySetGoTxt.text = "Set!"
				readySetGoTxt.alpha = 1
				readySetGoTxt.xScale, readySetGoTxt.yScale = 1,1
				transition.to(readySetGoTxt, {time=scaleTime, xScale = 2, yScale = 2, alpha = 0})
			elseif readySetGo == 2 then 
				readySetGoTxt.text = "Go!"
				readySetGoTxt.alpha = 1
				readySetGoTxt.xScale, readySetGoTxt.yScale = 1,1
				transition.to(readySetGoTxt, {time=scaleTime, xScale = 2, yScale = 2, alpha = 0})
				
				llamaBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-600, ch-150, false, 1, nil, nil, "Llama", "DimitriSwank", 60, onButtonEvent, "llama")

				duckBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-300, ch-150, false, 1, nil, nil, "Duck", "DimitriSwank", 60, onButtonEvent, "duck")

			end
		end
		timer.performWithDelay(750, readySetGoFunct, 2)
	end
	countdownToStart()

	return group
end

return M