local config = {
	[50000] = {position = Position(32259, 31891, 10), revert = true},
	[50001] = {position = Position(32259, 31890, 10), revert = true},
	[50002] = {position = Position(32266, 31860, 11)},

	time = 100
}

local function revertWall(wallPosition, leverPosition)
	local leverItem = Tile(leverPosition):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end

	Game.createItem(1498, 1, wallPosition)
end

local function removeWall(position)
	local tile = position:getTile()
	if not tile then
		return
	end

	local thing = tile:getItemById(1498)
	if thing then
		thing:remove()
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	end
end

function onUse(cid, item, position, itemEx, toPosition)
	if item.itemid ~= 1945 then
		Player(cid):sendCancelMessage('The lever has already been used.')
		return true
	end

	local wall = config[item.uid]
	removeWall(wall.position)
	if wall.revert then
		addEvent(revertWall, config.time * 1000, wall.position, position)
	end
	Item(item.uid):transform(1946)
	return true
end
