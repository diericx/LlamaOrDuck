local M = {}

function M.new()
	local group = display.newGroup()
		timer.performWithDelay(200, function() director:changeScene("gameNew") end, 1)
	return group
end

return M