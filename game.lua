local M = {}

function M.new()
	local widget = require( "widget" )

	local group = display.newGroup()
	local llamaDuckPics = display.newGroup()
	group:insert(llamaDuckPics)

	local timeToTap = 50
	local timeToTapCooldown = timeToTap
	local llamaOrDuck
	local previousImage
	local retryBtn
	local amountOfImages = 5
	local images = {}
	images.llamas = {}
	images.ducks = {}

	local function loadimages(numberOfImgs)
		for i = 1, (numberOfImgs)*2 do
			local tablePosition
			if i <= numberOfImgs then --load llama images
				print("Loading Llama...")
				tablePosition = #images.llamas+1
				local llamaPic = display.newImage("Images/llama/"..tostring(i)..".jpeg", 10000, 10000)
				llamaPic.display = false
				llamaPic.id = "llama"
				llamaDuckPics:insert(llamaPic)
				images.llamas[tablePosition] = llamaPic
			else -- load duck images
				print("Loading Duck...")
				tablePosition = #images.ducks + 1
				local duckPic = display.newImage("Images/duck/"..tostring(i-numberOfImgs)..".jpeg", -10000, -10000)
				duckPic.display = false
				duckPic.id = "llama"
				llamaDuckPics:insert(duckPic)
				images.ducks[tablePosition] = duckPic
			end
		end
	end
	loadimages(5)

	--display a new llamaduck pic
	local function newPic (isFirstPic)
		-- local randomLlama = math.random(1,5)
		-- local randomDuck = math.random(1,5)
		local randomPic = math.random(1,5)
		-- if randomPic == previousImage then
		-- 	if randomPic <= 3 then
		-- 		randomPic = randomPic + 1
		-- 	elseif randomPic > 3 then
		-- 		randomPic = randomPic - 1
		-- 	end
		-- end

		if llamaDuckPics.numChildren then
			if llamaDuckPics.numChildren > 0 then
				for i = llamaDuckPics.numChildren, 1, -1 do
					llamaDuckPics[i].display = false
		        	print(llamaDuckPics[i].display)
			    end
			end
		end

		--if isFirstPic == true then
				llamaOrDuck = math.random(1,2)
				if llamaOrDuck == 1 then
					print("NEW LLAMA")
					llamaDuckPics[randomPic].display = true
					--images.llamas[randomLlama].display = true
				elseif llamaOrDuck == 2 then
					print("NEW DUCK")
					llamaDuckPics[randomPic+amountOfImages].display = true
					--images.ducks[randomDuck].display = true
				end
			--end
		-- else
		-- 	if llamaDuckPics[1] then
		-- 		llamaDuckPics[1]:removeSelf()
		-- 		if llamaOrDuck == 1 then
		-- 			local llamaPic = display.newImage("Images/llama/"..tostring(randomLlama)..".jpeg", 0, 0)
		-- 			llamaPic.id = "llama"
		-- 			llamaDuckPics:insert(llamaPic)
		-- 		elseif llamaOrDuck == 2 then
		-- 			local duckPic = display.newImage("Images/duck/"..tostring(randomDuck)..".jpeg", 0, 0)
		-- 			duckPic.id = "duck"
		-- 			llamaDuckPics:insert(duckPic)
		-- 		end
		-- 	else 
		-- 		if llamaOrDuck == 1 then
		-- 			local llamaPic = display.newImage("Images/llama/"..tostring(randomLlama)..".jpeg", 0, 0)
		-- 			llamaPic.id = "llama"
		-- 			llamaDuckPics:insert(llamaPic)
		-- 		elseif llamaOrDuck == 2 then
		-- 			local duckPic = display.newImage("Images/duck/"..tostring(randomDuck)..".jpeg", 0, 0)
		-- 			duckPic.id = "duck"
		-- 			llamaDuckPics:insert(duckPic)
		-- 		end
		-- 	end
		--end
		randomPic = previousImage
	end
	newPic(true)

	local function onButtonEvent( event )
	   local phase = event.phase
	   local target = event.target
	      if ( "began" == phase ) then
	      --print( target.id .. " pressed" )
	      --target:setLabel( "Pressed" )  --set a new label
	   elseif ( "ended" == phase ) then
	      print( target.id .. " released" )
	      if (target.id == "llama" and llamaOrDuck == 2) or (target.id == "duck" and llamaOrDuck == 1) then
	      	print("GAME OVER MAN")
	      else
	      	timeToTapCooldown = timeToTap
	      	llamaOrDuck = math.random(1,2)
	      	newPic()
	      	print("NICE")
	      end
	      --target:setLabel( target.baseLabel )  --reset the label
	   end
	   return true
	end

	local function endGame()
		group:toFront()
		setEnterFrame(false)
		local gameOverText = display.newText( "Game Over!", 0, 0, native.systemDefaultFont, 60)
		gameOverText:setTextColor(0, 255, 0)
		group:insert(gameOverText)
		gameOverText.x, gameOverText.y = cw/2, ch/2

		retryBtn.left = cw/2
		retryBtn.top = ch/2
		retryBtn:toFront()
	end

	local function enterFrame ()
		if timeToTapCooldown > 0 then
			timeToTapCooldown = timeToTapCooldown - 1
		elseif timeToTapCooldown <= 0 then
			print("adsf")
			endGame()
			--llamaOrDuck = math.random(1,2)
			--newPic()
			--timeToTapCooldown = timeToTap
		end

		if llamaDuckPics.numChildren then
			if llamaDuckPics.numChildren > 0 then
				for i = llamaDuckPics.numChildren, 1, -1 do
			        if llamaDuckPics[i].display == true then
			        	llamaDuckPics[i].x = cw/2
			        	llamaDuckPics[i].y = ch/2
			        	--print("move Image")
			        end
			    end
			end
		end
	end
	setEnterFrame(enterFrame)


	local llamaBtn = widget.newButton
	{
	   left = 10,
	   top = ch-100,
	   label = "Llama",
	   labelAlign = "center",
	   font = "Arial",
	   fontSize = 30,
	   labelColor = { default = {0,0,0}, over = {200,200,200} },
	   onEvent = onButtonEvent
	}
	llamaBtn.baseLabel = "Default"
	llamaBtn.id = "llama"
	group:insert(duckBtn)

	local duckBtn = widget.newButton
	{
	   left = cw-210,
	   top = ch-100,
	   label = "Duck",
	   labelAlign = "center",
	   font = "Arial",
	   fontSize = 30,
	   labelColor = { default = {0,0,0}, over = {200,200,200} },
	   onEvent = onButtonEvent
	}
	duckBtn.baseLabel = "Default"
	duckBtn.id = "duck"
	group:insert(duckBtn)

	local retryBtn = widget.newButton
	{
	   left = 10,
	   top = ch-200,
	   label = "Retry",
	   labelAlign = "center",
	   font = "Arial",
	   fontSize = 30,
	   labelColor = { default = {0,0,0}, over = {200,200,200} },
	   onEvent = onButtonEvent
	}
	retryBtn.id = "retry"
	group:insert(retryBtn)

	return group
end

return M