-- slp13at420 of EmuDevs.com
local npcid = 390001
local currency = 44209
local bet = 1
local Dealer = {};
local Player = {};
local Suit = {};
local Card = {};
local Hand = {};
local function GetItemNameById(id)
local err = "ERROR GetItemById() name value is nil(Item "..id.." May not exist in database)"
local search = WorldDBQuery("SELECT `name` FROM `item_template` WHERE `entry` = '"..id.."';");

	if(search)then
		local itemname = search:GetString(0)
		return(itemname)
	else
		error(err)
	end
end

local currency_name = GetItemNameById(currency)

Card = {
	[1] = {"HEARTS",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,"A"},{12,"J"},{13,"Q"},{14,"K"}}},
	[2] = {"DIAMONDS",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,"A"},{12,"J"},{13,"Q"},{14,"K"}}},
	[3] = {"CLUBS",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,"A"},{12,"J"},{13,"Q"},{14,"K"}}},
	[4] = {"SPADES",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,"A"},{12,"J"},{13,"Q"},{14,"K"}}}
		}

local function BlackJackOnHello(event, player, unit)

Hand[player:GetGUIDLow()] = nil;
Hand["DEALER"] = nil;

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"costs "..bet.." "..currency_name..".", 0, 8)
	player:GossipMenuAddItem(10,"Play BlackJack.", 0, 11)
	player:GossipMenuAddItem(5, "never mind.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnPlay(event, player, unit)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"hand", 0, 9)
	player:GossipMenuAddItem(10,"hit me.", 0, 12)
	player:GossipMenuAddItem(10,"stay.", 0, 13)
	player:GossipSendMenu(1, unit)
end

local function PlayerDealCard(timer, cycle, player)
local suit = math.random(1,4)
local value = math.random(1,14)
local card = Card[suit][2][value][1]
local suit_name = Card[suit][1]
	if(card)then
		Card[suit][2][value][1] = nil;
print(Card[suit][2][value][2])
print(suit_name)
	table.insert(Hand[player:GetGUIDLow()].dealer, {card, suit_name})
	else
		print("Redeal")
		PlayerDealCard()
	end
end

local function DealerDealCard(timer, cycle, player)
local suit = math.random(1,4)
local value = math.random(1,14)
local card = Card[suit][2][value][1]
local suit_name = Card[suit][1]
print(Card[suit][2][value][2])
print(suit_name)
end

local function BlackJackOnSelect(event, player, unit, sender, intid, code)
print("76")
	if(intid<=8)then -- go otion screen
		LottoOnHello(1, player, unit)
	end
	if(intid==10)then
		player:GossipComplete()
	end
	if(intid==11)then -- start game
print(event,player,unit,sender)
		player:RegisterEvent(PlayerDealCard, 100, 2)
		player:RegisterEvent(DealerDealCard, 110, 2)
		BlackJackOnPlay(1, player, unit)
	end
--	++++++++++++++++++++++++++++++++++++ --
	if(intid==9)then -- return game screen 
		BlackJackOnPlay(1, player, unit)
	end
	if(intid==12)then -- hit me
		DealCard()
		BlackJackOnPlay(1, player, unit)
	end
	if(intid==13)then -- stay
		BlackJackOnPlay(1, player, unit)
	end
end

RegisterCreatureGossipEvent(npcid, 1, BlackJackOnHello)
RegisterCreatureGossipEvent(npcid, 2, BlackJackOnSelect)
