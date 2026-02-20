---@class yi.Screen : view.Node
---@operator call: yi.Screen
local Screen = Node + {}

function Screen:enter() end

function Screen:exit() end

---@param event table
function Screen:receive(event) end

return Screen
