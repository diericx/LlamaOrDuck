local M = {}

function M.new()
	local group = display.newGroup()

	local bg = display.newImage(group, "Images/bg.png", 0, 0)
	bg:rotate(0)
	bg.x = cw/2
	bg.y = ch/2

	local backBtn = displayNewButton(group, "Images/buttonUpSmall.png", "Images/buttonDownSmall.png", 20, 10, false, 1, nil, "menu", "Back", "DimitriSwank", 40, nil, nil)	


	local people = {
		{name="D H Wright"},
		{name="Daniel P Davis"},
		{name="madmcmojo"},
		{name="edkohler"},
		{name="jmd41280"},

		{name="Eksley"},
		{name="mrapplegate"},
		{name="niallkennedy"},
		{name="Big Grey Mare"},
		{name="Rei Ayanami en Tokyotres"},
		{name="Hopefoote Ambassador of the Wow"},

	}


	local text = display.newText( "We would like to thank the following Flickr users for providing the images used in this game under the Creative Commons Attribution License:", 20, 100, cw, 300, "Mensch", 38 )
	text:setTextColor(173, 173, 255)
	group:insert(text)

	for i = 1, #people do 
		local personName = display.newText(group, people[i].name, 50, i*50 + 320, "Mensch", 30)
	end

	--local creditsBtn = displayNewButton(group, "Images/buttonUpSmall.png", "Images/buttonDownSmall.png", cw-200, 10, false, 1, nil, "credits", "credits", "DimitriSwank", 40, nil, nil)	

	--group:insert(leaderboardsBtnH)
	--director:changeScene("game")

	return group
end

return M