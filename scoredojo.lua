
local widget = require "widget"
local json = require "json"
local scrollView = require "scrollView"
require "multiline_text"

local M = {}
--Make these variables accessible to all functions in this module
local usernameField=nil
local passwordField=nil
local emailField=nil
local headers={}
local loginOrRegister = "register"
local alreadyLoggedIn = false -- check if userinfo is already there

local day = {}
day.name = "day"
local week = {}
week.name = "week"
local allTime = {}
allTime.name = "allTime"


function M.start (baseLink, leaderboardKey, leaderBoardCount)
	local group = display.newGroup()
	local bgGroup = display.newGroup()
	group:insert(bgGroup)
	local createdByTabGroup = display.newGroup()
	group:insert(createdByTabGroup)
	local errorsGroup = display.newGroup()
	group:insert(errorsGroup)
	local currentLoaderboardGroup = display.newGroup()
	group:insert(currentLoaderboardGroup)
	local loadingScreenGroup = display.newGroup()
	group:insert(loadingScreenGroup)

	local userInfoTemp
	local topBoundary = display.screenOriginY
	local bottomBoundary = display.screenOriginY
	--check for user info, if none set alreadyLoggedIn to false and display register
	local path = system.pathForFile( "userInfo.dat", system.DocumentsDirectory)
	local fhd = io.open (path)
	if fhd then
		print("FOUND USER INFO")
		userInfo = Load("userInfo")
		--print("user: "..tostring(userInfo.username), "pass: "..tostring(userInfo.password), "auth: "..tostring(userInfo.authKey))
		if userInfo.username and userInfo.authKey then
			userInfoTemp = userInfo
			alreadyLoggedIn = true -- turn true when releaseing to show leaderboards
		else
			userInfoTemp = {}
			alreadyLoggedIn = false
		end
	else
		userInfoTemp = {email = nil, username = nil}
		alreadyLoggedIn = false
	end
	--background
	local bg = display.newRect(bgGroup, 0, 0, cw, ch)
	bg:setFillColor(240,240,240)
	--topBar shit
	local topBar = display.newImage(group, "scoredojo/topBar.png", 0, -65)
	topBar:scale(1, 0.6)

	local tabs


	local function removeFields()
		native.setKeyboardFocus( nil )
		display.remove(emailField)
		display.remove(passwordField)
		display.remove(usernameField)
		display.remove(tabs)
		display.remove(currentLoaderboardGroup)
		display.remove(group)
	end

	--local backBtn = displayNewButton(group, "scoredojo/buttonUpSmall.png", "scoredojo/buttonDownSmall.png", 20, 10, false, 1, nil, "menu", "Back", "Hiruko", 40, removeFields, nil)	
	local backBtn = displayNewButton(group, "scoredojo/buttonUpSmall.png", "scoredojo/buttonDownSmall.png", 20, -3, false, 1, nil, "menu", "Back", 255, 255, 255, "DimitriSwank", 40, removeFields, nil)
	--------------
	--functions
	--------------
	local function displayLoadingScreen(group, y)
		local loadingScreen = display.newRect(loadingScreenGroup, 0, -100, cw, ch+200)
		loadingScreen:setFillColor(0,0,0)
		loadingScreen.alpha = 0.5
		local loadingText = display.newText(loadingScreenGroup, "Loading...", cw/2, ch/2 , "Hiruko", 60)
		loadingText.x = cw/2
		loadingText.y = y
		group:insert(loadingScreenGroup)

		local function loadingScreenListener()
			return true
		end
		loadingScreen:addEventListener("touch", loadingScreenListener)
	end

	local function displayServerError (group)
		local serverErrorText = display.newText(group, "Server Not Available! :(", 100, 400, native.systemDefaultFont, 40)
		serverErrorText.x, serverErrorText.y = cw/2, 350
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
		native.setKeyboardFocus( nil )
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
					--JHelseif loginOrRegister == "login" then
					--JH	userInfoTemp.password = "HIDDEN FROM SNEAKY EYES"
					end
					--save auth token
					userInfoTemp.authKey = data.auth_token
					print(data.auth_token, "AUTH TOKEN #################")
					--save user info
				    Save(userInfoTemp, "userInfo")
				    -- --set auth token
				    headers["Authorization"] = "Token token="..tostring(data.auth_token)
				    headers["Content-Type"] = "application/x-www-form-urlencoded"

				    --print("auth:"..headers["Authorization"])
				    removeFields()
				    --clearGroup(createdByTabGroup) 
				    --clearGroup(loadingScreenGroup)
				    --clearGroup(group)
				    director:changeScene("menu")
				else
					clearGroup(loadingScreenGroup)
					if loginOrRegister == "login" then --if your logging in only display this one error
						displayLoginRegError(cw/2, ch/2 + 190, data.message, 50, cw)
					elseif loginOrRegister == "register" then--if you are registering display multiple errors in different spots
						--if theres a username error display it
						if data.errors.username == nil then
						else
							local errorText = displayLoginRegError(cw/2 + 10, ch/2+50, "Username "..data.errors.username[1], 35, cw + 100)
							errorText:setReferencePoint(display.CenterReferencePoint)
							errorText.x = cw/2+60
						end
						--if theres an email error display it
						if data.errors.email == nil then
						else
							local errorText = displayLoginRegError(cw/2 + 10, ch/2+150, "Email "..data.errors.email[1], 35, cw + 100)
							errorText:setReferencePoint(display.CenterReferencePoint)
							errorText.x = cw/2+60
						end
						--if theres a password error display it
						if data.errors.password == nil then
						else
							local errorText = displayLoginRegError(cw/2, ch/2+250, "Password "..data.errors.password[1], 35, cw)
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
			postData = "leaderboard_key="..leaderboardKey.."&username="..tostring(userInfoTemp.username).."&password="..tostring(userInfoTemp.password)
		elseif loginOrRegister == "register" then
			link = tostring(baseLink).."addUser"
			postData = "leaderboard_key="..leaderboardKey.."&username="..tostring(userInfoTemp.username).."&email="..tostring(userInfoTemp.email).."&password="..tostring(userInfoTemp.password)
		end
		local params = {}
		params.body = postData
		params.headers = headers
		print("LINK =====", link)
		print("########################  BEFORE SEND  ###")
		local loadingScreen = displayLoadingScreen(group, ch/2 - 170)
		network.request( link, "POST", networkCallback, params)
		print("########################  AFTER SEND  ###")
	end

	--listener for text fields
	local function fieldHandler( self, event )

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

	    --local submitButton = displayNewButton(createdByTabGroup, "scoredojo/greenButton.png", nil, cw/2-196, 200, true, 0.90, 100, nil, "Submit", "Hiruko", 60, submitUserInfo)
		local submitButton = displayNewButton(createdByTabGroup, "scoredojo/greenButton.png", nil, cw/2-196, 200, true, 0.90, 100, nil, "Submit", 25, 25, 25, "Hiruko", 60, submitUserInfo, nil)

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

	    --local submitButton = displayNewButton(createdByTabGroup, "scoredojo/greenButton.png", nil, cw/2-196, 200, true, 0.90, 100, nil, "Submit", "Hiruko", 60, submitUserInfo)
		local submitButton = displayNewButton(createdByTabGroup, "scoredojo/greenButton.png", nil, cw/2-196, 200, true, 0.90, 100, nil, "Submit", 25, 25, 25, "Hiruko", 60, submitUserInfo, nil)

		submitButton[1].name = "register"
	end

	--if alreadyLoggedIn is false or true, register or display leaderboards
	if alreadyLoggedIn == false then
		-- local text = display.newText( "You need to login or create a Scoredojo account to view highscores!", 0, 0, cw, 200, "Hiruko", 33 )
	 --    text.x, text.y = cw/2 + 23, 200
	 --    if tostring(device.model) == "BNTV250" then
	 --    	text.x = text.x - 14
	 --    end

		local text = display.newMultiLineText  
	        {
	        text = "You need to login or create a Scoredojo account to view highscores!",
	        width = cw,                  --OPTIONAL        Defailt : nil 
	        left = 0,top = cw+200,             --OPTIONAL        Default : left = 0,top=0
	        font = "Hiruko",     --OPTIONAL        Default : native.systemFont
	        fontSize = 33,                --OPTIONAL        Default : 14
	        color = {90,90,90},              --OPTIONAL        Default : {0,0,0}
	        align = "center"              --OPTIONAL   Possible : "left"/"right"/"center"
	        }
	    text.x = cw/2
	    text.y = ch/2 - 380

	    group:insert(text)


	    --create login/register tabs
		local tabButtons = {
	        {
	        	id=1,
	            label="Login",
	            labelYOffset=-50,
	            defaultFile="scoredojo/blank-130.png",
	            overFile="scoredojo/blank-130.png",
	            width=32, height=130,
	            size=36,
	            onPress=function() clearGroup(createdByTabGroup); clearGroup(errorsGroup);login(); end,
	        },
	        {
	        	id=2,
	            label="Register",
	            labelYOffset=-50,
	           	defaultFile="scoredojo/blank-130.png",
	            overFile="scoredojo/blank-130.png",
	            width=32, height=130,
	            size=36,
	            onPress=function() clearGroup(createdByTabGroup); clearGroup(errorsGroup); register(); end,
	            selected = true,
	        }
	    }
	    tabs = widget.newTabBar{
	        top=ch-130,
	        height=130,
	        backgroundFile = "scoredojo/tabbar.png",
			tabSelectedLeftFile = "scoredojo/tabBar_tabSelectedLeft.png",
			tabSelectedMiddleFile = "scoredojo/tabBar_tabSelectedMiddle.png",
			tabSelectedRightFile = "scoredojo/tabBar_tabSelectedRight.png",
			tabSelectedFrameWidth = 20,
			tabSelectedFrameHeight = 120,
	        buttons=tabButtons,
	    }

	    group:insert(tabs)

	    register()
	else
		local topBarGroup = display.newGroup()
		group:insert(currentLoaderboardGroup)
		group:insert(topBarGroup)
		--scrollView:insert(currentLoaderboardGroup)
		


		local function displayLeaderboard(table)
			--print("DISPLAY LEADERBOARD:")
			--print(table.name)
			local userInfo = Load("userInfo")
			local inAllTime = false

			if #table > 0 then
				--create scroll view
				local scrollView = scrollView.new{ top=topBoundary + 100, bottom=bottomBoundary + 200 }
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
							print("ONLY 1...")
							playerRow = display.newImage( "scoredojo/tableSingle.png", 0, 10)
							currentLoaderboardGroup:insert( playerRow )
						else
							print("NO TABLE")
							playerRow = display.newImage( "scoredojo/tableTop.png", 0, i*113 - 100)
							currentLoaderboardGroup:insert( playerRow )
						end
					elseif i == #table then --if its the last person displayed then...
						playerRow = display.newImage( "scoredojo/tableBot.png", 0, i*113 - 100)
						currentLoaderboardGroup:insert( playerRow )
						scrollView:insert(currentLoaderboardGroup)
					elseif i ~= 1 and i ~= #table then --if its any of the other people displayed then...
						playerRow = display.newImage( "scoredojo/tableMid.png", 0, i*113 - 100)
						currentLoaderboardGroup:insert( playerRow )
					end
					local playerRankBox = display.newRoundedRect(currentLoaderboardGroup, playerRow.x - 220, playerRow.y - 50, 100, 100, 20)
					playerRankBox:setFillColor(100, 100, 100)
					playerRankBox.alpha = 0.1
					local playerRankText = display.newText(currentLoaderboardGroup, i, playerRankBox.x, playerRankBox.y , "Hiruko", 70)
					playerRankText.x, playerRankText.y = playerRankBox.x, playerRankBox.y
					playerRankText:setTextColor(199, 147, 22)
					local playerNameText = display.newText(currentLoaderboardGroup, table[i].username, playerRankBox.x + 75, 0, "Hiruko", 35)
					playerNameText:setTextColor(100, 100, 100)
					playerNameText.y = playerRow.y - 30
					local playerScoreText = display.newText(currentLoaderboardGroup, table[i].score, playerRankBox.x + 75, 0, "Hiruko", 50)
					playerScoreText:setTextColor(199, 147, 22)
					playerScoreText.y = playerRow.y + 25
					--add them to a new scrollView
					playerRow.x = cw/2
					--check if player is in top 10, if so highlight name
					if table[i].username == userInfo.username then
						playerRow:setFillColor(220,220,255)
						if table == allTime then
							inAllTime = true
						end
					end
					if inAllTime == true then

					else
						if table.name == "allTime" then
							--print("**** allTime ****")
							if i == #table then
								i = i + 1
								local userInfo = Load("userInfo")
								--put one at bottom for guy if he isn't in top 10
								--print("ONLY 1")
								playerRow = display.newImage( "scoredojo/tableSingle.png", 22, i*114 - 100)
								playerRow.x = cw/2
								playerRow.y = playerRow.y + 50
								currentLoaderboardGroup:insert( playerRow )
								local playerRankBox = display.newRoundedRect(currentLoaderboardGroup, playerRow.x - 243, playerRow.y - 50, 100, 100, 20)
								playerRankBox:setFillColor(100, 100, 100)
								playerRankBox.alpha = 0.1
								local playerRankText = display.newText(currentLoaderboardGroup, "", playerRankBox.x, playerRankBox.y , "Hiruko", 70)
								playerRankText.x, playerRankText.y = playerRankBox.x, playerRankBox.y
								playerRankText:setTextColor(199, 147, 22)
								local playerNameText = display.newText(currentLoaderboardGroup, userInfo.username, playerRankBox.x + 75, 0, "Hiruko", 35)
								playerNameText:setTextColor(100, 100, 100)
								playerNameText.y = playerRow.y - 30
								local playerScoreText = display.newText(currentLoaderboardGroup, "", playerRankBox.x + 90, 0, "Hiruko", 50)
								playerScoreText:setTextColor(199, 147, 22)
								playerScoreText.y = playerRow.y + 25

								playerRow:setFillColor(220,220,255)
								local divider = display.newRoundedRect(currentLoaderboardGroup, 0, 0, cw-60, 10, 4)
								divider.x, divider.y = cw/2, playerRow.y - 80
								divider:setFillColor(220,220,220)

								--get users rank and score
								local userRankScore = {rank = 0, score = 0}  
								local function networkCallback (event)
									local data = json.decode(event.response)
									if data.success == true then
										if data.rank == 1 or data.rank == 2 or data.rank == 3 or data.rank == 4 or data.rank == 5 or data.rank == 6 or data.rank == 7 or data.rank == 8 or data.rank == 9 or data.rank == 10 then
											playerRankText.text = tostring(data.rank)
											playerScoreText.text = "Your in the top 10!"
											playerScoreText.x = playerScoreText.x + 165
											return userRankScore
										elseif data.rank > 10 then
											playerRankText.text = tostring(data.rank)
											playerScoreText.text = tostring(data.score)
											if data.rank > 99 then
												playerRankText.size = playerRankText.size - 25
												playerRankText.x = playerRankText.x - 5
											end
											playerScoreText.x = playerScoreText.x + 15
											return userRankScore
										end											
									else 
										playerRankText.text = "--"
										playerScoreText.text = "No score submitted!"
										playerScoreText.size = 45
										playerScoreText.x = playerScoreText.x + 164
									end
								end
								--print("getRank()")

								link = tostring(baseLink).."getRank"
								local body = "leaderboard_key="..tostring(leaderboardKey)
								local params = {}
								params.body = body
								params.headers = headers
								network.request( link, "POST", networkCallback, params)
							end
						end
					end
					topBarGroup:toFront()
					backBtn:toFront()
					loadingScreenGroup:toFront()
				end
				print("CREATED ROWS")
			else
				--no people in leaderboard
				clearGroup(currentLoaderboardGroup)
				local playerRow = display.newImage( "scoredojo/tableSingle.png", 0, 1*114 - 30)
				currentLoaderboardGroup:insert( playerRow )
				local playerRankBox = display.newRoundedRect(currentLoaderboardGroup, playerRow.x - 220, playerRow.y - 50, 100, 100, 20)
				playerRankBox:setFillColor(100, 100, 100)
				playerRankBox.alpha = 0.1
				local playerRankText = display.newText(currentLoaderboardGroup, "0", playerRankBox.x, playerRankBox.y , "Hiruko", 70)
				playerRankText.x, playerRankText.y = playerRankBox.x, playerRankBox.y
				playerRankText:setTextColor(199, 147, 22)
				local playerNameText = display.newText(currentLoaderboardGroup, "There's no one here!", playerRankBox.x + 75, playerRankBox.y, "Hiruko", 35)
				playerNameText:setTextColor(100, 100, 100)
				playerNameText.y = playerRow.y - 30
				local playerScoreText = display.newText(currentLoaderboardGroup, "Be the first one!", playerRankBox.x + 75, playerRankBox.y, "Hiruko", 50)
				playerScoreText:setTextColor(199, 147, 22)
				playerScoreText.y = playerRow.y + 25
				--add them to a new scrollView
				--scrollView:insert(currentLoaderboardGroup)
				playerRow.x = cw/2
				topBarGroup:toFront()
				backBtn:toFront()
				loadingScreenGroup:toFront()
			end
			--display your name at bottom if you're not in all time
		end


		local function getLeaderboardInfo(table, timeframe)
			local link = tostring(baseLink).."getTopN"
			local userInfo = Load("userInfo")
			local headers={}
			print ("AUTHKey="..tostring(userInfo.authKey))
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept"] = "application/json"
			headers["Authorization"] = "Token token="..tostring(userInfo.authKey)
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
						allTime.name = "allTime"
					elseif table == "week" then
						week = data
						week.name = "week"
					elseif table == "day" then
						day = data
						day.name = "day"
					end

					table = data
				end
			end

			local params = {}
			local body = "leaderboard_key="..tostring(leaderboardKey).."&count="..tostring(leaderBoardCount).."&timeframe="..tostring(timeframe)

			params.headers = headers

			local loadingScreen = displayLoadingScreen(group, ch/2)
			--print("LINK:"..link.." POST:"..postData.." HEADER:"..headers["Authorization"] )
			local link = tostring(baseLink).."getTopN"
			params.body = body
			network.request( link, "POST", networkCallback, params)
		end
		getLeaderboardInfo("allTime", 1)
		getLeaderboardInfo("week", 3)
		getLeaderboardInfo("day", 4)

		local checkForLeaderboardDataTimer
		
		checkForLeaderboardDataTimer = timer.performWithDelay(100, function()
			if allTime then
				if #allTime > 0 then
					--print("asdfDISPLAYallTIMEman")
					timer.cancel(checkForLeaderboardDataTimer)
					displayLeaderboard(allTime)
				end
			end
		end, 15)


		 function lbTabCallback( event )
			--print("lbTabCallback()"..event.target._id)

	    	if event.target._id == "1" then 
	    		--print("DAY")
	    		displayLeaderboard(day)
	    	elseif event.target._id == "2" then
	    		displayLeaderboard(week)
	    	elseif event.target._id == "3" then
	    		displayLeaderboard(allTime)
	    	end
	    end

		local tabButtons2 = {
	        {	
	        	
	            label="Today",
	           	labelYOffset=-50,
	            defaultFile="scoredojo/blank.png",
	            overFile="scoredojo/blank.png",
	            width=32, height=130,
	            size=36,
	            onPress=lbTabCallback,	
	            id="1",            
	        },
	        {
	            label="This Week",
	            labelYOffset=-50,
	            defaultFile="scoredojo/blank.png",
	            overFile="scoredojo/blank.png",
	            width=32, height=130,
	            size=36,
	            onPress=lbTabCallback,
	            id="2", 
	        },
	        {
	            label="All Time",
	            labelYOffset=-50,
	            defaultFile="scoredojo/blank.png",
	            overFile="scoredojo/blank.png",
	            width=32, height=130,
	            size=36,
	            onPress=lbTabCallback,
	            selected = true,
	            id="3", 
	        },
	    }
	    tabs = widget.newTabBar{
	    	height=130,
	        top=ch-130,
	       	backgroundFile = "scoredojo/tabbar.png",
			tabSelectedLeftFile = "scoredojo/tabBar_tabSelectedLeft.png",
			tabSelectedMiddleFile = "scoredojo/tabBar_tabSelectedMiddle.png",
			tabSelectedRightFile = "scoredojo/tabBar_tabSelectedRight.png",
			tabSelectedFrameWidth = 20,
			tabSelectedFrameHeight = 120,
	        buttons=tabButtons2,
	    }
	    group:insert(tabs)

	    loadingScreenGroup:toFront()

	    --topBar shit
	    local topBar = display.newImage(topBarGroup, "scoredojo/topBar.png", 0, -65)
	    topBar:scale(1, 0.6)

		--local backBtn = displayNewButton(topBarGroup, "Images/buttonUpSmall.png", "Images/buttonDownSmall.png", 20, 10, false, 1, nil, "menu", "Back", "Hiruko", 40, nil, nil)	
		backBtn:toFront()
		loadingScreenGroup:toFront()
	end
	return group
end

function M.submitHighscore (baseLink, leaderboardKey, scoreType, scoreValue)

	local json = require "json"
	local userInfo = Load("userInfo")

	if userInfo and userInfo.authKey and userInfo.username then
		headers["Accept"] = "application/json"
		headers["Authorization"] = "Token token="..tostring(userInfo.authKey)
		headers["Content-Type"] = "application/x-www-form-urlencoded"
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
		local postData = "leaderboard_key="..leaderboardKey.."&score_type="..tostring(scoreType).."&score_value="..tostring(scoreValue)
		local params = {}
		params.body = postData
		params.headers = headers
		network.request( link, "POST", submitHighscoreCallback, params)
	else
		print("Sign in to submit highscore!")
	end
end

return M