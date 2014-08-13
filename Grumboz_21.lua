-- From the Mad Scientist slp13at420 of EmuDevs.com
print("+-+-+-+-+-+-+")
local npcid = 390001 -- creature_template id
local currency = 44209 -- item_template id
local bet = 1 -- how much each hit costs.

-- DO NOT EDIT BELOW this line unless you know what your doing. --
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

local function ShuffleHand(player, unit, guid)
	Hand[guid] = {player = 0, dealer = 0, first = 0, turns = 0, creature = unit};
end

local function ShuffleCards(player, guid)
Card[guid] = {
	[1] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}},
	[2] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}},
	[3] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}},
	[4] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}}
		}
end

local function BlackJackInstructions(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(0,"First to reach 21", 0, 8)
	player:GossipMenuAddItem(0,"without going over wins.", 0, 8)
	player:GossipMenuAddItem(10,"back", 0, 7)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[player:GetGUIDLow()].creature)
end

local function BlackJackOnHello(event, player, unit)
local guid = player:GetGUIDLow()
ShuffleCards(player, guid)
ShuffleHand(player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"costs "..bet.." "..currency_name.." per card.", 0, 7)
	player:GossipMenuAddItem(10,"Play 21.", 0, 11)
	player:GossipMenuAddItem(10,"Instructions.", 0, 8)
	player:GossipMenuAddItem(5, "never mind.", 0, 10)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function BlackJackOnPlayerWin(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 14)
	player:GossipMenuAddItem(10,"You win. Dealer went over 21.", 0, 14)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function BlackJackOnPlayerTO(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 14)
	player:GossipMenuAddItem(10,"21. You win.", 0, 14)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function BlackJackOnDealerTO(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 14)
	player:GossipMenuAddItem(10,"Dealer hit 21. You loose.", 0, 14)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function BlackJackOnDealerWin(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 15)
	player:GossipMenuAddItem(10,"Dealer wins. You went over 21.", 0, 15)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function BlackJackOnDraw(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 17)
	player:GossipMenuAddItem(10,"You Both hit 21.", 0, 17)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function BlackJackOnNoWinner(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 9)
	player:GossipMenuAddItem(10,"You Both went over 21.", 0, 19)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function BlackJackOnPlay(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 9)
	player:GossipMenuAddItem(10,"hit me.", 0, 12)
	player:GossipSendMenu(1, Hand[guid].creature)
end

local function DealCard(event, player, guid)
local suit = math.random(1,4)
local value = math.random(1,14)

	if(Card[guid][suit][value][1] > 0)then
		local card = (Card[guid][suit][value][1])
		return(card)
	else
		DealCard(event, timer, cycle, player)
	end
Card[guid][suit][value][1] = 0
end

-- ******************************* --

local function BlackJackOnSelect(event, player, unit, sender, intid, code)

local guid = player:GetGUIDLow()

	if(player:GetItemCount(currency)>=bet)then
		if(intid<=7)then
			BlackJackOnHello(1, player, unit)
		end
		if(intid==8)then -- goto/return instructions
			BlackJackInstructions(event, player, unit, guid)
		end
		if(intid==9)then -- return game screen 
			BlackJackOnPlay(event, player, unit, guid)
		end
		if(intid==10)then
			player:GossipComplete()
		end
	--	++++++++++++++++++++++++++++++++++++ --
		if(intid==11)then -- start game first deal
			ShuffleCards(player, guid)
			ShuffleHand(player, unit, guid)
			player:RemoveItem(currency, bet)
			BlackJackOnSelect(event, player, unit, sender, 12, code)	
		end

		if(intid==12)then -- hit me
			player:RemoveItem(currency, bet)
			local pcard = DealCard(event, player, guid)
			local dcard = DealCard(event, player, guid)
			local win = (bet * Hand[guid].turns)*2
		
			Hand[guid].player = (Hand[guid].player + pcard)
			Hand[guid].dealer = (Hand[guid].dealer + dcard)
			Hand[guid].turns =(Hand[guid].turns + 1)

				if((Hand[guid].player < 21)and(Hand[guid].dealer < 21))then
					BlackJackOnPlay(1, player, Hand[guid].creature, guid)
				end
				
				if((Hand[guid].player==21)and(Hand[guid].dealer==21))then
					BlackJackOnDraw(event, player, Hand[guid].creature, guid)
				end
				
				if((Hand[guid].player==21)and((Hand[guid].dealer < 21)or(Hand[guid].dealer > 21)))then
					player:AddItem(currency, win)
					BlackJackOnPlayerTO(event, player, Hand[guid].creature, guid)
				end
				
				if(((Hand[guid].player < 21)or(Hand[guid].player > 21))and(Hand[guid].dealer==21))then
					BlackJackOnDealerTO(event, player, Hand[guid].creature, guid)
				end
				
				if((Hand[guid].player < 21)and(Hand[guid].dealer > 21))then
					player:AddItem(currency, win)
					BlackJackOnPlayerWin(event, player, Hand[guid].creature, guid)
				end
	
				if((Hand[guid].player > 21)and(Hand[guid].dealer < 21))then
					BlackJackOnDealerWin(event, player, Hand[guid].creature, guid)
				end
				
				if((Hand[guid].player > 21)and(Hand[guid].dealer > 21))then
					BlackJackOnNoWinner(event, player, Hand[guid].creature, guid)
				end
							
		end
	
		if(intid==14)then
			BlackJackOnPlayerWin(1, player, unit, guid)
		end
		
		if(intid==15)then
			BlackJackOnDealerWin(1, player, unit, guid)
		end
		
		if(intid==17)then
			BlackJackOnDraw(event, player, unit, guid)
		end
		
		if(intid==18)then
			BlackJackOnNewPlay(event, player, guid)
		end
	
		if(intid==19)then
			BlackJackOnNoWinner(1, player, unit, guid)
		end

	else
		player:SendMessage("move along now. you creeping ,me out . we only deal to players with "..currency_name.."'s.")
	end
end

RegisterCreatureGossipEvent(npcid, 1, BlackJackOnHello)
RegisterCreatureGossipEvent(npcid, 2, BlackJackOnSelect)
print(" Grumboz 21.")
print("+-+-+-+-+-+-+")
