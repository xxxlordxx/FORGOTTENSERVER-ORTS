function onUse(cid, item, fromPosition, itemEx, toPosition)
	local pos = getThingPos(itemEx.uid)
	if(itemEx.itemid == 8572) then
		doTransformItem(itemEx.uid, 8576)
		toPosition:sendMagicEffect(CONST_ME_BIGPLANTS)
		addEvent(Reset, 10 * 1000, pos)
	end
	return true
end

local function Reset(pos)
	if (pos.itemid == 8576) then
		doTransformItem(pos, 8572)
	end
	return true
end
