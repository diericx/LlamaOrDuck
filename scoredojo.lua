local M = {}
--Make these variables accessible to all functions in this module
local usernameField=nil
local passwordField=nil
local emailField=nil
local headers={}

function M.refreshUserData (baseLink, token)
	local userInfoTemp = {email = nil, password = nil, username = nil}
	local function networkCallback(event)
		print("RESPONSE USER DATA REFRESH", event.response)
		if ( event.isError ) or event.response == "The request timed out." or event.status == 404 or event.status == 502 then
			print( "Network Error!")
		else
			local data = json.decode(event.response)
			if data.success == true then
				print("USER DATA REFRESHED!")
				userInfoTemp.id = data.id
				--login after register to get auth token then remove pass
				if loginOrRegister == "register" then
					loginOrRegister = "login"
				elseif loginOrRegister == "login" then
					--userInfoTemp.password = "HIDDEN FROM SNEAKY EYES"
				end
				--save auth token
				userInfoTemp.authKey = data.auth_token
				print(data.auth_token, "AUTH TOKEN #################")
				--save user info
			    Save(userInfoTemp, "userInfo")
			    -- --set auth token
			    headers["Authorization"] = "Token token="..tostring(data.auth_token)
				finishedRefresh = true
			else
				print("Server Error")
			end
		end
	end

	local link = tostring(baseLink).."login"
	local postData = "leaderboard_key="..token.."&username="..tostring(userInfoTemp.username).."&password="..tostring(userInfoTemp.password)

	local params = {}
	params.body = postData
	params.headers = headers
	print("POST DATA USER REFRESH = ", postData)
	network.request( link, "POST", networkCallback, params)
end

function M.start (baseLink, token, leaderBoardCount)
	local widget = require "widget"
	local json = require "json"
	local scrollView = require "scrollView"
	--groups
	local group = display.newGroup()
	local createdByTabGroup = display.newGroup()
	group:insert(createdByTabGroup)
	local errorsGroup = display.newGroup()
	group:insert(errorsGroup)
	local loadingScreenGroup = display.newGroup()
	group:insert(loadingScreenGroup)

	local loginOrRegister = "register"

	local alreadyLoggedIn = false -- check if userinfo is already there
	local userInfoTemp
	local topBoundary = display.screenOriginY
	local bottomBoundary = display.screenOriginY
	--check for user info, if none set alreadyLoggedIn to false and display register
	local path = system.pathForFile( "userInfo.dat", system.DocumentsDirectory)
	local fhd = io.open (path)
	if fhd then
		print("FOUND USER INFO")
		userInfo = Load("userInfo")
		print("user: "..tostring(userInfo.username), "pass: "..tostring(userInfo.password), "auth: "..tostring(userInfo.authKey))
		if userInfo.username and userInfo.password then
			userInfoTemp = userInfo
			alreadyLoggedIn = true -- turn true when releaseing to show leaderboards
		else
			userInfoTemp = {}
			alreadyLoggedIn = false
		end
	else
		userInfoTemp = {email = nil, password = nil, username = nil}
		alreadyLoggedIn = false
	end
	--refresh user data
	M.refreshUserData("https://scoredojo.com/api/v1/", "536f2b4067689c1b1632f87e6a2ef31b")
	--------------
	--functions
	--------------
	local function displayLoadingScreen(group)
		local loadingScreen = display.newRect(loadingScreenGroup, 0, 0, cw, ch)
		loadingScreen:setFillColor(0,0,0)
		loadingScreen.alpha = 0.5
		local loadingText = display.newText(loadingScreenGroup, "Loading...", cw/2, ch/2, "DimitriSwank", 60)
		loadingText.x = cw/2
		loadingText.y = ch/2 - 50
		group:insert(loadingScreenGroup)

		local function loadingScreenListener()
			return true
		end
		loadingScreen:addEventListener("touch", loadingScreenListener)
	end

	local function displayServerError (group)
		local serverErrorText = display.newText(group, "Server Not Available! :(", 100, 400, native.systemDefaultFont, 40)
		serverErrorText.x, serverErrorText.y = cw/2, 250
		serverErrorText:setTextColor(200, 0, 0)
	end

	local function displayLoginRegError(x, y, text, size, width)
		local errorText = display.newText(text, cw/2, ch/2 + 200, width, 200, native.systemDefaultFont, size)
		errorText.x, errorText.y = x, y
		errorText:setTextColor(255, 10, 10)
		errorsGroup:insert(errorText)
		return errorText
	end

	local function clearGroup (group)
		if group.numChildren then
			if group.numChildren > 0 then
				for i = group.numChildren, 1, -1 do
			        group:remove(i) 
			    end
			end
		end
	end
	local submitUserInfo
	function submitUserInfo()
		print "*******   submitUserInfo()   *******"
		--calback for sending things to server (gets responses)
		clearGroup(errorsGroup)
		local function networkCallback(event)
			print("SUBMIT")
			print("RESPONSE", event.response)
			if ( event.isError ) or event.response == "The request timed out." or event.status == 404 or event.status == 502 then
				clearGroup(loadingScreenGroup)
				print( "Network Error!")
				displayServerError(group)
			else
				local data = json.decode(event.response)
				if data.success == true then
					print("Username Made!")
					userInfoTemp.id = data.id
					--login after register to get auth token then remove pass
					if loginOrRegister == "register" then
						loginOrRegister = "login"
						submitUserInfo()
					elseif loginOrRegister == "login" then
						--userInfoTemp.password = "HIDDEN FROM SNEAKY EYES"
					end
					--save auth token
					userInfoTemp.authKey = data.auth_token
					print(data.auth_token, "AUTH TOKEN #################")
					--save user info
				    Save(userInfoTemp, "userInfo")
				    -- --set auth token
				    headers["Authorization"] = "Token token="..tostring(data.auth_token)
				    clearGroup(createdByTabGroup) 
				    clearGroup(loadingScreenGroup)
				    director:changeScene("menu")
				else
					clearGroup(loadingScreenGroup)
					if loginOrRegister == "login" then --if your logging in only display this one error
						displayLoginRegError(cw/2, ch/2 + 150, data.message, 50, cw)
					elseif loginOrRegister == "register" then--if you are registering display multiple errors in different spots
						--if theres a username error display it
						if data.errors.username == nil then
						else
							local errorText = displayLoginRegError(cw/2 + 10, ch/2+40, "Username "..data.errors.username[1], 35, cw + 100)
							errorText:setReferencePoint(display.CenterReferencePoint)
							errorText.x = cw/2+60
						end
						--if theres an email error display it
						if data.errors.email == nil then
						else
							local errorText = displayLoginRegError(cw/2 + 10, ch/2+140, "Email "..data.errors.email[1], 35, cw + 100)
							errorText:setReferencePoint(display.CenterReferencePoint)
							errorText.x = cw/2+60
						end
						--if theres a password error display it
						if data.errors.password == nil then
						else
							local errorText = displayLoginRegError(cw/2, ch/2+240, "Password "..data.errors.password[1], 35, cw)
							errorText:setReferencePoint(display.CenterReferencePoint)
							errorText.x = cw/2+5
						end
						for i = 1, #data.errors do
							print("error!")
						end
					end
				end
			end
		end

		local link 
		local postData

		--Get the values from the form fields
		if userInfoTemp ~= nil then
			userInfoTemp.password=passwordField.text
		end
		if usernameField ~= nil then
			userInfoTemp.username=usernameField.text
		end
		if emailField ~= nil then
			userInfoTemp.email=emailField.text
		end

		print("LOGIN: entered =", userInfoTemp.email, userInfoTemp.password, userInfoTemp.username)
		if loginOrRegister == "login" then
			link = tostring(baseLink).."login"
			postData = "leaderboard_key="..token.."&username="..tostring(userInfoTemp.username).."&password="..tostring(userInfoTemp.password)
		elseif loginOrRegister == "register" then
			link = tostring(baseLink).."addUser"
			postData = "leaderboard_key="..tostring(token).."&username="..tostring(userInfoTemp.username).."&email="..tostring(userInfoTemp.email).."&password="..tostring(userInfoTemp.password)
		end
		local params = {}
		params.body = postData
		params.headers = headers
		print("LINK =====", link)
		print("########################  BEFORE SEND  ###")
		local loadingScreen = displayLoadingScreen(group)
		network.request( link, "POST", networkCallback, params)
		print("########################  AFTER SEND  ###")
	end

	--listener for text fields
	local function fieldHandler( self, event )
		-- local objName = event.name
  --       -- print( "TextField Object is: " .. tostring( self.name ) )
  --       if ( "began" == event.phase ) then
  --       	print("BEGAN")
  --       	group.y = localGroupDif
  --       elseif ( "ended" == event.phase ) or ( "submitted" == event.phase ) then
  --       	print("ENDED")
  --       	print("name =", self.name)
  --       	--if you tapped anywhere but another text field do this
  --       	if self.name ~= "password" and self.name ~= "username" and self.name ~= "email" then
  --           	group.y = localGroupOrig
  --           	native.setKeyboardFocus( nil )
  --           end
  --       	print(self.text)
  --       	if self.name == "email" then
  --       		print("EMAIL SAVED")
  --       		userInfoTemp.email = self.text
  --       	elseif self.name == "password" then
  --       		userInfoTemp.password = self.text
  --       	elseif self.name == "username" then
  --       		userInfoTemp.username = self.text
  --       	end
  --   		print("entered =", userInfoTemp.username, userInfoTemp.password)
  --   		--SaveJson(userInfo, "userInfo")
  --           print( "Text entered = " .. tostring( self.text ) )         -- display the text entered
  --       end
	end
	--display login
	local function login ()
		loginOrRegister = "login"

		usernameField = native.newTextField( cw/2+200, ch-ch + 400, 280, 50)
		usernameField.userInput = fieldHandler
		usernameField:addEventListener("userInput", usernameField)
	    usernameField.x = cw/2+100
	    usernameField.name = "username"
	    createdByTabGroup:insert(usernameField)

	    usernameFieldTxt = display.newText("Nickname:", usernameField.x-usernameField.width, usernameField.y, native.systemFont, 40)
	    usernameFieldTxt:setTextColor(150,150,150)
	    usernameFieldTxt.x = usernameField.x-usernameField.width+25
	    usernameFieldTxt.y = usernameField.y-5
	    createdByTabGroup:insert(usernameFieldTxt)

		passwordField = native.newTextField( cw/2, ch-ch + 500, 280, 50 )
		passwordField.userInput = fieldHandler
		passwordField:addEventListener("userInput", passwordField)
		passwordField.x = cw/2 + 100
		passwordField.name = "password"
		passwordField.isSecure = true
		createdByTabGroup:insert(passwordField)

	    passwordFieldTxt = display.newText("Password:", passwordField.x-passwordField.width, passwordField.y, native.systemFont, 40)
	    passwordFieldTxt:setTextColor(150,150,150)
	    passwordFieldTxt.x = passwordField.x-passwordField.width+25
	    passwordFieldTxt.y = passwordField.y-5
	    createdByTabGroup:insert(passwordFieldTxt)

	    local submitButton = displayNewButton(createdByTabGroup, "scoredojo/greenButton.png", nil, cw/2-196, 200, true, 0.90, 100, nil, "Submit", "DimitriSwank", 60, submitUserInfo)
		submitButton[1].name = "login"
	end

	--display register
	local function register ()
		loginOrRegister = "register"

		usernameField = native.newTextField( cw/2+200, ch-ch + 400, 280, 50)
		usernameField.userInput = fieldHandler
		usernameField:addEventListener("userInput", usernameField)
	    usernameField.x = cw/2+100
	    usernameField.name = "username"
	    createdByTabGroup:insert(usernameField)

	    usernameFieldTxt = display.newText("Username:", usernameField.x-usernameField.width, usernameField.y, native.systemFont, 40)
	    usernameFieldTxt:setTextColor(150,150,150)
	    usernameFieldTxt.x = usernameField.x-usernameField.width+25
	    usernameFieldTxt.y = usernameField.y-5
	    createdByTabGroup:insert(usernameFieldTxt)

		emailField = native.newTextField( cw/2, ch-ch + 500, 280, 50 )
		emailField.userInput = fieldHandler
		emailField:addEventListener("userInput", emailField)
		emailField.x = cw/2 + 100
		emailField.name = "email"
		createdByTabGroup:insert(emailField)

	    emailFieldTxt = display.newText("Email:", emailField.x-emailField.width, emailField.y, native.systemFont, 40)
	    emailFieldTxt:setTextColor(150,150,150)
	    emailFieldTxt.x = emailField.x-emailField.width+25
	    emailFieldTxt.y = emailField.y-5
	    createdByTabGroup:insert(emailFieldTxt)

	   	passwordField = native.newTextField( cw/2, ch-ch + 600, 280, 50 )
		passwordField.userInput = fieldHandler
		passwordField:addEventListener("userInput", passwordField)
		passwordField.x = cw/2 + 100
		passwordField.name = "password"
		passwordField.isSecure = true
		createdByTabGroup:insert(passwordField)

	    passwordFieldTxt = display.newText("Password:", passwordField.x-passwordField.width, passwordField.y, native.systemFont, 40)
	    passwordFieldTxt:setTextColor(150,150,150)
	    passwordFieldTxt.x = passwordField.x-passwordField.width+25
	    passwordFieldTxt.y = passwordField.y-5
	    createdByTabGroup:insert(passwordFieldTxt)

	    local submitButton = displayNewButton(createdByTabGroup, "scoredojo/greenButton.png", nil, cw/2-196, 200, true, 0.90, 100, nil, "Submit", "DimitriSwank", 60, submitUserInfo)
		submitButton[1].name = "register"
	end

	--if alreadyLoggedIn is false or true, register or display leaderboards
	if alreadyLoggedIn == false then
		--create text at top
		local text = display.newText( "You need to login or create a Scoredojo account!", 0, 0, cw, 200, "Mensch", 33 )
	    text.x = cw/2
	    group:insert(text)
	    text:setTextColor(10,10,10)
	    --see what tab was clicked then call either login or register
	    local function tabCallback(event)
	    	if event.target.id == 1 then 
	    		print("login")
	    		clearGroup(createdByTabGroup)
	    		clearGroup(errorsGroup)
	    		login()
	    	elseif event.target.id == 2 then
	    		print("register")
	    		clearGroup(createdByTabGroup)
	    		clearGroup(errorsGroup)
	    		register()
	    	end
	    end

	    --create login/register tabs
		local tabButtons = {
	        {
	            label="Login",
	            up="scoredojo/blank.png",
	            down="scoredojo/blank.png",
	            width=32, height=32,
	            size=25,
	            onPress=tabCallback,
	        },
	        {
	            label="Register",
	            up="scoredojo/blank.png",
	            down="scoredojo/blank.png",
	            width=32, height=32,
	            size=25,
	            onPress=tabCallback,
	            selected = true,
	        },
	    }

		tabs = widget.newTabBar
		{
		   left = 0,
		   top = display.contentHeight - 60,
		   width = 240,
		   height = 60,
		   buttons = tabButtons
		}
	    tabs = widget.newTabBar{
	        top=ch-130,
	        height=130,
	        buttons=tabButtons
	    }
	    tabs.buttons[1].width = tabs.buttons[1].width + 170
	    tabs.buttons[1].label.width = 50
	    tabs.buttons[1].label.height = 60
	    tabs.buttons[1].label.y = 50
	    tabs.buttons[1].x = tabs.buttons[2].x - tabs.buttons[2].width*3+70
	    tabs.buttons[2].width = tabs.buttons[1].width + 170
	    tabs.buttons[2].label.width = 80
	    tabs.buttons[2].label.height = 60
	    tabs.buttons[2].label.y = 50
	    tabs.buttons[2].x = tabs.buttons[2].x - tabs.buttons[2].width/2 + 70
	    register()
	else
		local currentLoaderboardGroup = display.newGroup()
		group:insert(currentLoaderboardGroup)
		--scrollView:insert(currentLoaderboardGroup)
		
		local day
		local week
		local allTime

		local function displayLeaderboard(table)
			print(#table)
			if #table > 0 then
				--create scroll view
				local scrollView = scrollView.new{ top=topBoundary, bottom=bottomBoundary + 200 }
				group:insert(scrollView)
				--move tabs to front
				if tabs then 
					tabs:toFront()
				end
				--clear the group
				clearGroup(currentLoaderboardGroup)

				for i = 1, #table do
					local playerRow
					--displa the rows
					if i == 1 then --if its the first person displayed then...
						if #table == 1 then -- if theres only 1 person then...
							print("ONLY 1")
							playerRow = display.newImage( "scoredojo/tableSingle.png", 0, i*114 - 100)
							currentLoaderboardGroup:insert( playerRow )
						else
							playerRow = display.newImage( "scoredojo/tableTop.png", 0, i*114 - 100)
							currentLoaderboardGroup:insert( playerRow )
						end
					elseif i == #table then --if its the last person displayed then...
						playerRow = display.newImage( "scoredojo/tableBot.png", 0, i*114 - 100)
						currentLoaderboardGroup:insert( playerRow )
						scrollView:insert(currentLoaderboardGroup)
					elseif i ~= 1 and i ~= #table then --if its any of the other people displayed then...
						playerRow = display.newImage( "scoredojo/tableMid.png", 0, i*114 - 100)
						currentLoaderboardGroup:insert( playerRow )
					end
					local playerRankBox = display.newRoundedRect(currentLoaderboardGroup, playerRow.x - 240, playerRow.y - 50, 100, 100, 20)
					playerRankBox:setFillColor(100, 100, 100)
					playerRankBox.alpha = 0.1
					local playerRankText = display.newText(currentLoaderboardGroup, i, playerRankBox.x, playerRankBox.y , "DimitriSwank", 70)
					playerRankText.x, playerRankText.y = playerRankBox.x, playerRankBox.y
					playerRankText:setTextColor(199, 147, 22)
					local playerNameText = display.newText(currentLoaderboardGroup, table[i].username, playerRankBox.x + 75, 0, "DimitriSwank", 35)
					playerNameText:setTextColor(100, 100, 100)
					playerNameText.y = playerRow.y - 30
					local playerScoreText = display.newText(currentLoaderboardGroup, table[i].score, playerRankBox.x + 75, 0, "DimitriSwank", 50)
					playerScoreText:setTextColor(199, 147, 22)
					playerScoreText.y = playerRow.y + 25
					--add them to a new scrollView
					playerRow.x = cw/2
				end
			else
				clearGroup(currentLoaderboardGroup)
				local playerRow = display.newImage( "scoredojo/tableSingle.png", 0, 1*114 - 100)
				currentLoaderboardGroup:insert( playerRow )
				local playerRankBox = display.newRoundedRect(currentLoaderboardGroup, playerRow.x - 240, playerRow.y - 50, 100, 100, 20)
				playerRankBox:setFillColor(100, 100, 100)
				playerRankBox.alpha = 0.1
				local playerRankText = display.newText(currentLoaderboardGroup, "0", playerRankBox.x, playerRankBox.y , "DimitriSwank", 70)
				playerRankText.x, playerRankText.y = playerRankBox.x, playerRankBox.y
				playerRankText:setTextColor(199, 147, 22)
				local playerNameText = display.newText(currentLoaderboardGroup, "There's no one here!", playerRankBox.x + 75, 0, "DimitriSwank", 35)
				playerNameText:setTextColor(100, 100, 100)
				playerNameText.y = playerRow.y - 30
				local playerScoreText = display.newText(currentLoaderboardGroup, "0", playerRankBox.x + 75, 0, "DimitriSwank", 50)
				playerScoreText:setTextColor(199, 147, 22)
				playerScoreText.y = playerRow.y + 25
				--add them to a new scrollView
				playerRow.x = cw/2
			end
		end

		local function getLeaderboardInfo(table, timeframe)
			local link = tostring(baseLink).."getTopN"
			local userInfo = Load("userInfo")
			clearGroup(errorsGroup)

			local function networkCallback(event)
				print("RESPONSE", event.response)
				if ( event.isError ) or event.response == "The request timed out." or event.status == 404 or event.status == 502 then
					clearGroup(loadingScreenGroup)
					print( "Network Error!")
					--displayLeaderboard(allTime)
					displayServerError(group)
				else
					--displayLeaderboard(allTime)
					clearGroup(loadingScreenGroup)
					local data = json.decode(event.response)
					if table == "allTime" then
						allTime = data
					elseif table == "week" then
						week = data
					elseif table == "day" then
						day = data
					end

					table = data
				end
			end

			local params = {}
			local postData = "leaderboard_key="..tostring(token).."&count="..tostring(leaderBoardCount).."&timeframe="..tostring(timeframe)
			params.body = postData
			params.headers = headers
			local loadingScreen = displayLoadingScreen(group)
			network.request( link, "POST", networkCallback, params)
		end
		getLeaderboardInfo("allTime", 1)
		getLeaderboardInfo("week", 3)
		getLeaderboardInfo("day", 4)

		local checkForLeaderboardDataTimer
		
		checkForLeaderboardDataTimer = timer.performWithDelay(100, function()
			if allTime then
				if #allTime > 0 then
					displayLeaderboard(allTime)
				end
			end
			timer.cancel(checkForLeaderboardDataTimer)
		end)

		local function tabCallback(event)
	    	if event.target.id == 1 then 
	    		displayLeaderboard(day)
	    	elseif event.target.id == 2 then
	    		displayLeaderboard(week)
	    	elseif event.target.id == 3 then
	    		displayLeaderboard(allTime)
	    	end
	    end

		local tabButtons = {
	        {
	            label="Today",
	            up="scoredojo/blank.png",
	            down="scoredojo/blank.png",
	            width=32, height=32,
	            onPress=tabCallback,
	            size=25,
	        },
	        {
	            label="This Week",
	            up="scoredojo/blank.png",
	            down="scoredojo/blank.png",
	            width=32, height=32,
	            size=25,
	            onPress=tabCallback,
	        },
	        {
	            label="All Time",
	            up="scoredojo/blank.png",
	            down="scoredojo/blank.png",
	            width=32, height=32,
	            size=25,
	            onPress=tabCallback,
	            selected = true,
	        },
	    }
	    
	    tabs = widget.newTabBar{
	        top=ch-130,
	        height=130,
	        buttons=tabButtons
	    }
	    group:insert(tabs)
	    tabs.buttons[1].width = cw/3
	    tabs.buttons[2].width = cw/3
	    tabs.buttons[3].width = cw/3
	    tabs.buttons[1].label.width = 60
	    tabs.buttons[2].label.width = 110
	    tabs.buttons[3].label.width = 90
	    tabs.buttons[1].label.height = 50
	    tabs.buttons[2].label.height = 50
	    tabs.buttons[3].label.height = 50
	    tabs.buttons[1].label.y = 40
	    tabs.buttons[2].label.y = 40
	    tabs.buttons[3].label.y = 40
	    tabs.buttons[2].x = tabs.buttons[2].x  - tabs.buttons[2].width + 87
	    tabs.buttons[1].x = -110
	    tabs.buttons[3].x = cw - 315
	    loadingScreenGroup:toFront()

	end
	return group
end

function M.submitHighscore (baseLink, leaderboard_key, scoreType, scoreValue)

	local json = require "json"
	local userInfo = Load("userInfo")
	if userInfo.authKey and userInfo.username then
		local function submitHighscoreCallback ( event )
			local data = json.decode(event.response)
			print(data)
			if data.success == true then
				print("SCORE SUBMITTED")
			else
				print("ERROR: SCORE NOT SUBMITTED")
			end

		end
		local link = baseLink.."submitHighScore"
		local postData = "leaderboard_key="..tostring(leaderboard_key).."&score_type="..tostring(scoreType).."&score_value="..tostring(scoreValue)
		local params = {}
		params.body = postData
		params.headers = headers
		network.request( link, "POST", submitHighscoreCallback, params)
	else
		print("Sign in to submit highscore!")
	end
end

return M