local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end

local lastSound = 0
function onThink()
	if lastSound < os.time() then
		lastSound = (os.time() + 5)
		if math.random(100) < 25 then
			Npc():say("Psst! Over here!", TALKTYPE_SAY)
		end
	end
	npcHandler:onThink()
end

local function getTable(player)
local itemsList = {}
local buyList = {
	{itemId = 10942, price = 600},		-- Almanac of Magic
	{itemId = 10154, price = 10000},	-- Animal Fetish
	{itemId = 10943, price = 600},		-- Baby Rotworm
	{itemId = 7500, price = 6000},		-- Bale of White Cloth
	{itemId = 2329, price = 8000},		-- Bill
	{itemId = 9369, price = 50000},		-- Blood Crystal
	{itemId = 10159, price = 10000},	-- Bloodkiss Flower
	{itemId = 10109, price = 5000},		-- Bundle of Rags
	{itemId = 10615, price = 1000},		-- Carrying Device
	{itemId = 7499, price = 2000},		-- Cigar
	{itemId = 2347, price = 150},		-- Cookbook
	{itemId = 14338, price = 40000},	-- Damaged Logbook
	{itemId = 14352, price = 17000},	-- Dark Essence
	{itemId = 10158, price = 13000},	-- Deep Crystal
	{itemId = 10169, price = 8000},		-- Elemental Crystal
	{itemId = 11397, price = 600},		-- Empty Beer Bottle
	{itemId = 8111, price = 100},		-- Exploding Cookie
	{itemId = 12501, price = 4000},		-- Exquisite Silk
	{itemId = 12503, price = 4000},		-- Exquisite Wood
	{itemId = 12500, price = 600},		-- Faded Last Will
	{itemId = 4845, price = 1000},		-- Family Brooch
	{itemId = 10308, price = 10000},	-- Fan Club Membership Card
	{itemId = 10616, price = 1000},		-- Filled Carrying Device
	{itemId = 8766, price = 7000},		-- Fishnapped Goldfish
	{itemId = 10926, price = 700},		-- Flask of Crown Polisher
	{itemId = 11106, price = 1000},		-- Flask of Extra Greasy Oil
	{itemId = 10760, price = 1000},		-- Flask of Poison
	{itemId = 12506, price = 4000},		-- Flexible Dragon Scale
	{itemId = 14351, price = 5000},		-- Formula for a Memory Potion
	{itemId = 4858, price = 6000},		-- Funeral Urn
	{itemId = 9662, price = 50000},		-- Ghost's Tear
	{itemId = 4843, price = 24000},		-- Giant Ape's Hair
	{itemId = 10165, price = 13500},	-- Golem Blueprint
	{itemId = 10173, price = 25000},	-- Golem Head
	{itemId = 10454, price = 350},		-- Headache Pill
	{itemId = 2330, price = 8000},		-- Letterbag
	{itemId = 12285, price = 1000},		-- Lump of Clay
	{itemId = 10307, price = 8500},		-- Machine Crate
	{itemId = 12508, price = 4000},		-- Magic Crystal
	{itemId = 10167, price = 13000},	-- Mago Mechanic Core
	{itemId = 10928, price = 650},		-- Map to the Unknown
	{itemId = 7281, price = 500},		-- Memory Crystal
	{itemId = 4852, price = 3000},		-- Memory Stone
	{itemId = 12507, price = 4000},		-- Mystic Root
	{itemId = 10225, price = 5250},		-- Nautical Map
	{itemId = 12505, price = 4000},		-- Old Iron
	{itemId = 10170, price = 13000},	-- Old Power Core
	{itemId = 10613, price = 1000},		-- Plans for a Strange Device
	{itemId = 11104, price = 1000},		-- Rare Crystal
	{itemId = 12297, price = 1000},		-- Sacred Earth
	{itemId = 10155, price = 12500},	-- Shadow Orb
	{itemId = 4854, price = 500},		-- Sheet of Tracing Paper
	{itemId = 7697, price = 15000},		-- Signet Ring
	{itemId = 4846, price = 8000},		-- Snake Destroyer
	{itemId = 10945, price = 666},		-- Soul Contract
	{itemId = 14323, price = 5000},		-- Special Flask
	{itemId = 12502, price = 4000},		-- Spectral Cloth
	{itemId = 4847, price = 15000},		-- Spectral Dress
	{itemId = 10166, price = 12500},	-- Stabilizer
	{itemId = 15389, price = 5000},		-- Strange Powder
	{itemId = 12504, price = 4000},		-- Strong Sinew
	{itemId = 2346, price = 16000},		-- Tear of Daraman
	{itemId = 7699, price = 5000},		-- Technomancer Beard
	{itemId = 9733, price = 8000},		-- The Alchemists' Formulas
	{itemId = 8752, price = 10000},		-- The Ring of the Count
	{itemId = 7487, price = 16000},		-- Toy Mouse
	{itemId = 10944, price = 550},		-- Universal Tool
	{itemId = 12295, price = 1000},		-- Unworked Sacred Wood
	{itemId = 4838, price = 18000},		-- Whisper Moss
	{itemId = 10157, price = 12500},	-- Worm Queen Tooth
	{itemId = 14336, price = 4000}		-- Wrinkled Parchment
}

if player:getStorageValue(Storage.thievesGuild.Quest) >= 9 then
	for i = 1, #buyList do
		table.insert(itemsList, buyList[i])
	end
end

return itemsList
end

local function setNewTradeTable(table)
	local items = {}
	for _, v in ipairs(table) do
		items[v.id] = {itemId = v.id, buyPrice = v.buy, sellPrice = v.sell, subType = 0, realName = v.name}
	end
	return items
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)

	if msgcontains(msg, "hello") or msgcontains(msg, "hi") then
		npcHandler:say("Hello.", cid)
		npcHandler:addFocus(cid)
	elseif msgcontains(msg, "bye") or msgcontains(msg, "farewell") then
		npcHandler:say("It was a pleasure to help you, "..player:getName()..".", cid)
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	elseif msgcontains(msg, "trade") then

		local items = setNewTradeTable(getTable(player))

		local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
			if (ignoreCap == false and (player:getFreeCapacity() < getItemWeight(items[item].itemId, amount) or inBackpacks and player:getFreeCapacity() < (getItemWeight(items[item].itemId, amount) + getItemWeight(1988, 1)))) then
				return player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You don\'t have enough cap.')
			end
			if items[item].buyPrice <= player:getMoney() then
				if inBackpacks then
					local container = Game.createItem(1988, 1)
					local bp = player:addItemEx(container)
					if(bp ~= 1) then
						return player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You don\'t have enough container.')
					end
					for i = 1, amount do
						container:addItem(items[item].itemId, items[item])
					end
				else
					return
					player:addItem(items[item].itemId, amount, false, items[item]) and
					player:removeMoney(amount * items[item].buyPrice) and
					player:sendTextMessage(MESSAGE_INFO_DESCR, 'You bought '..amount..'x '..items[item].realName..' for '..items[item].buyPrice * amount..' gold coins.')
				end
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'You bought '..amount..'x '..items[item].realName..' for '..items[item].buyPrice * amount..' gold coins.')
				player:removeMoney(amount * items[item].buyPrice)
			else
				player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You do not have enough money.')
			end
			return true
			end

		local function onSell(cid, item, subType, amount, ignoreEquipped)
			if items[item].sellPrice then
				return
				player:removeItem(items[item].itemId, amount, -1, ignoreEquipped) and
				player:addMoney(items[item].sellPrice * amount) and

				player:sendTextMessage(MESSAGE_INFO_DESCR, 'You sold '..amount..'x '..items[item].realName..' for '..items[item].sellPrice * amount..' gold coins.')
			end
			return true
		end
		openShopWindow(cid, getTable(player), onBuy, onSell)

		npcHandler:say("Keep in mind you won't find better offers here. Just browse through my wares.", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
