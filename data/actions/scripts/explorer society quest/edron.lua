function onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player(cid)
	if(item.uid == 3012) then
		if(getPlayerStorageValue(cid, 90) == 39) then
			setPlayerStorageValue(cid, 90, 40)
			doPlayerAddItem(cid, 4852, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a memory stone.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	end
	return true
end
