-- slp13at420 of EmuDevs.com
local npcid = 390001
local currency = 44209
local bet = 1
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

local function ShuffleHand(player, unit)
	Hand[player:GetGUIDLow()] = {player = 0, dealer = 0, first = 0, turns = 0, creature = unit};
end

local function ShuffleCards(player)
Card[player:GetGUIDLow()] = {
	[1] = {"HEARTS",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{10,"J"},{10,"Q"},{10,"K"}}},
	[2] = {"DIAMONDS",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{10,"J"},{10,"Q"},{10,"K"}}},
	[3] = {"CLUBS",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{10,"J"},{10,"Q"},{10,"K"}}},
	[4] = {"SPADES",{{1,"A"},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{10,"J"},{10,"Q"},{10,"K"}}},
		}
end

local function BlackJackOnHello(event, player, unit)
ShuffleCards(player)
ShuffleHand(player, unit)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"costs "..bet.." "..currency_name..".", 0, 8)
	player:GossipMenuAddItem(10,"Play BlackJack.", 0, 11)
	player:GossipMenuAddItem(5, "never mind.", 0, 10)
	player:GossipSendMenu(1, Hand[player:GetGUIDLow()].creature)
end

local function BlackJackOnPlayerWin(event, player, unit)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[player:GetGUIDLow()].player.." :: Dealer:"..Hand[player:GetGUIDLow()].dealer.."", 0, 9)
	player:GossipMenuAddItem(10,"You win. Dealer went over 21.", 0, 14)
	player:GossipMenuAddItem(10,"again.", 0, 8)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[player:GetGUIDLow()].creature)
end

local function BlackJackOnDealerWin(event, player, unit)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[player:GetGUIDLow()].player.." :: Dealer:"..Hand[player:GetGUIDLow()].dealer.."", 0, 9)
	player:GossipMenuAddItem(10,"You went over 21.", 0, 15)
	player:GossipMenuAddItem(10,"again.", 0, 8)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[player:GetGUIDLow()].creature)
end

local function BlackJackOnPlay(event, player)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[player:GetGUIDLow()].player.." :: Dealer:"..(Hand[player:GetGUIDLow()].dealer - Hand[player:GetGUIDLow()].first).."", 0, 9)
	player:GossipMenuAddItem(10,"hit me.", 0, 12)
	player:GossipMenuAddItem(10,"stay.", 0, 13)
	player:GossipSendMenu(1, Hand[player:GetGUIDLow()].creature)
end

local function PlayerDealCard(event, timer, cycle, player)

local suit = math.random(1,4)
local value = math.random(1,13)
local card = Card[player:GetGUIDLow()][suit][2][value][1]
--	local suit_name = Card[player:GetGUIDLow()][suit][1]

	if(card)then
		Hand[player:GetGUIDLow()].turns =(Hand[player:GetGUIDLow()].turns + 1)
		Card[player:GetGUIDLow()][suit][2][value][1] = nil;
		Hand[player:GetGUIDLow()].player = (Hand[player:GetGUIDLow()].player + card)

		if(Hand[player:GetGUIDLow()].player > 21)then
			BlackJackOnDealerWin(event, player, Hand[player:GetGUIDLow()].creature)
		else
			BlackJackOnPlay(1, player)
		end
	else
--		print("player nil card : Redeal")
		player:RegisterEvent(PlayerDealCard, 100, 1)
	end
end

local function Dealer_FIRST_DealCard(event, timer, cycle, player)
local suit = math.random(1,4)
local value = math.random(1,14)
local card = Card[player:GetGUIDLow()][suit][2][value][1]
local suit_name = Card[player:GetGUIDLow()][suit][1]

	if(card)then
		Hand[player:GetGUIDLow()].turns =(Hand[player:GetGUIDLow()].turns + 1)
		Card[player:GetGUIDLow()][suit][2][value][1] = nil;
		Hand[player:GetGUIDLow()].dealer = (Hand[player:GetGUIDLow()].dealer + card)
		Hand[player:GetGUIDLow()].first = card
	else
--		print("dealer nil card : Redeal")
		DealerDeal_FIRST_Card(event, timer, cycle, player)
	end
end

local function DealerDealCard(event, timer, cycle, player)
	local avg = (Hand[player:GetGUIDLow()].dealer / Hand[player:GetGUIDLow()].turns)
	local suit = math.random(1,4)
	local value = math.random(1,14)
	local suit_name = Card[player:GetGUIDLow()][suit][1]
	local card = Card[player:GetGUIDLow()][suit][2][value][1]

		if(card)then
			Hand[player:GetGUIDLow()].turns =(Hand[player:GetGUIDLow()].turns + 1)
			Card[player:GetGUIDLow()][suit][2][value][1] = nil;
			Hand[player:GetGUIDLow()].dealer = (Hand[player:GetGUIDLow()].dealer + card)

			if(Hand[player:GetGUIDLow()].dealer > 21)then
				BlackJackOnPlayerWin(event, player, Hand[player:GetGUIDLow()].creature)
				local win = (bet * Hand[player:GetGUIDLow()].turns)*2
				player:AddItem(currency, win)
			else
				BlackJackOnPlay(1, player)
			end
		else
			print("dealer Redeal")
		player:RegisterEvent(DealerDealCard, 100, 1)
		end
end

local function BlackJackOnSelect(event, player, unit, sender, intid, code)
	if(intid<=7)then
		BlackJackOnHello(1, player, unit)
	end
	if(intid==8)then -- go otion screen
		player:RemoveItem(currency, bet)
		ShuffleCards(player)
		ShuffleHand(player, unit)
		BlackJackOnPlay(2, player, unit, sender)
	end
	if(intid==9)then -- return game screen 
		BlackJackOnPlay(1, player, unit)
	end
	if(intid==10)then
		player:GossipComplete()
	end
	if(intid==11)then -- start game
		player:RemoveItem(currency, bet)
		player:RegisterEvent(PlayerDealCard, 100, 2)
		player:RegisterEvent(Dealer_FIRST_DealCard, 200, 1)
		player:RegisterEvent(DealerDealCard, 300, 1)
	end
--	++++++++++++++++++++++++++++++++++++ --
	if(intid==12)then -- hit me
		player:RemoveItem(currency, bet)
		player:RegisterEvent(PlayerDealCard, 100, 1)
		player:RegisterEvent(DealerDealCard, 150, 1)
	end
	if(intid==13)then
	 -- stay
		player:RegisterEvent(DealerDealCard, 100, 1)
	end
	if(intid==14)then
		BlackJackOnPlayerWin(1, player, unit)
	end
	if(intid==15)then
		BlackJackOnDealerWin(1, player, unit)
	end
end

RegisterCreatureGossipEvent(npcid, 1, BlackJackOnHello)
RegisterCreatureGossipEvent(npcid, 2, BlackJackOnSelect)
print("-----------------------------------")
print("Grumboz BlackJack and Hookerz running wild.")
print("-----------------------------------")
