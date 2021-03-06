local Area_fromPos, Area_toPos = {x = 33235, y = 31801, z = 12}, {x = 33299, y = 31867, z = 12}

local t = {
	[1] = {{x=33268, y=31833, z=10}, 8304, {x=33268, y=31833, z=12}},
	[2] = {{x=33268, y=31838, z=10}, 8305, {x=33267, y=31838, z=12}},
	[3] = {{x=33270, y=31835, z=10}, 8300, {x=33270, y=31835, z=12}},
	[4] = {{x=33266, y=31835, z=10}, 8306, {x=33265, y=31835, z=12}}
}

local function reset()
	for i = 1, #walls_NS do
		local wns = getTileItemById(walls_NS[i], 8861).uid
		if (wns ~= 0) then
			doRemoveItem(wns)
		end
	end
	for i = 1, #walls_WE do
		local wwe = getTileItemById(walls_WE[i], 8862).uid
		if (wwe ~= 0) then
			doRemoveItem(wwe)
		end
	end
	for i = 1, 4 do
		local lever = getTileItemById(levers_pos[i], 1946).uid
		if (lever > 0) then
			doTransformItem(lever, 1945)
		end
	end

	local creature
	for x = room.fromX, room.toX do
		for y = room.fromY, room.toY do
			for z = room.fromZ, room.toZ do
				creature = Tile(Position(x, y, z)):getTopCreature()
				if creature and creature:isMonster() and creature:getName():lower() == 'lord of the elements' then
					creature:remove()
				end
			end
		end
	end
	for i = 10004, 10008 do
		Game.setStorageValue(i, 0)
	end
	return true
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (item.itemid == 1945) then
		if (isPlayerInArea(Area_fromPos, Area_toPos) or (Game.getStorageValue(10004) or -1) > 0) then
			return (doCreatureSay(cid, 'Wait for the current team to exit.', TALKTYPE_MONSTER_SAY, false, 0, {x=33268, y=31835, z=10}))
		end
		for k, v in pairs(t) do
			local teamPlayer = getTopCreature(v[1]).uid
			if isPlayer(teamPlayer) == false then
				return (doCreatureSay(cid, 'You need one player of each vocation having completed the Elemental Spheres quest and also carrying the elemental rare item.', TALKTYPE_MONSTER_SAY, false, 0, {x=33268, y=31835, z=10}))
			end
			local voc = getPlayerVocation(teamPlayer)
			if voc > 4 then
				voc = voc - 4
			end
			if voc ~= k or getPlayerItemCount(teamPlayer, v[2]) < 1 or getPlayerStorageValue(teamPlayer, 10000) < 2 then
				return (doCreatureSay(cid, 'You need one player of each vocation having completed the Elemental Spheres quest and also carrying the elemental rare item.', TALKTYPE_MONSTER_SAY, false, 0, {x=33268, y=31835, z=10}))
			end
		end
		local effectTable = {}
		for k, v in pairs(t) do
			local teamPlayer = getTopCreature(v[1]).uid
			doTeleportThing(teamPlayer, v[3])
			doSendMagicEffect(v[1], CONST_ME_TELEPORT)
			table.insert(effectTable, v[3])
			doTransformItem(item.uid, 1946)
		end
		for _, v in ipairs(effectTable) do
			doSendMagicEffect(v, CONST_ME_TELEPORT)
			v = nil
		end
	elseif (item.itemid == 1946) then
		doTransformItem(item.uid, 1945)
	end
	return true
end
