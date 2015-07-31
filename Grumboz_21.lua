-- From the Mad Scientist slp13at420 of EmuDevs.com

print("+-+-+-+-+-+-+")
local npcid = 390001 -- creature_template id for vendor
local currency = 44209 -- item_template id for currency
local bet = 1 -- how much each hit costs.

-- DO NOT EDIT BELOW this line unless you know what your doing. --

local Suit = {};
local Card = {};

local Hand = {
			player = 0,
			dealer = 0,
			first = 0,
			turns = 0,
			unit_guid = nil,
	};

local function GetItemNameById(id)
local err = "ERROR GetItemById() name value is nil(Item "..id.." May not exist in database)"
local search = WorldDBQuery("SELECT `name` FROM `item_template` WHERE `entry` = '"..id.."';");

	if(search)then
		local itemname = search:GetString(0);
		return(itemname);
	else
		error(err);
	end
end

local currency_name = GetItemNameById(currency)

local function ShuffleHand(player, unitguid)
	Hand[guid] = {
		player = 0,
		dealer = 0,
		first = 0,
		turns = 0,
		unit_guid = unitguid,
		};
end

local function ShuffleCards(player)

math.randomseed(tonumber(os.time()*os.time()))

local guid = player:GetGUIDLow();

Card[guid] = {
	[1] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}},
	[2] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}},
	[3] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}},
	[4] = {{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{10},{10},{10}}
		};
end

local function BlackJackInstructions(event, player)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(0,"First to reach 21", 0, 8)
	player:GossipMenuAddItem(0,"without going over wins.", 0, 8)
	player:GossipMenuAddItem(10,"back", 0, 7)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnHello(event, player, unit)

local guid = player:GetGUIDLow();

if(unit)then Hand[guid].unit_guid = unit:GetGUIDLow(); end

if not(unit)then local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);end

	ShuffleCards(player)
	ShuffleHand(player, Hand[guid].unit_guid)
	
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"costs "..bet.." "..currency_name.." per card.", 0, 7)
	player:GossipMenuAddItem(10,"Play 21.", 0, 11)
	player:GossipMenuAddItem(10,"Instructions.", 0, 8)
	player:GossipMenuAddItem(5, "never mind.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnPlayerWin(event, player)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 14)
	player:GossipMenuAddItem(10,"You win. Dealer went over 21.", 0, 14)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnPlayerTO(event, player)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 14)
	player:GossipMenuAddItem(10,"21. You win.", 0, 13)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnDealerTO(event, player, guid)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 14)
	player:GossipMenuAddItem(10,"Dealer hit 21. You loose.", 0, 16)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnDealerWin(event, player, guid)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 15)
	player:GossipMenuAddItem(10,"Dealer wins. You went over 21.", 0, 15)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnDraw(event, player)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 17)
	player:GossipMenuAddItem(10,"You Both hit 21.", 0, 17)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnNoWinner(event, player)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 9)
	player:GossipMenuAddItem(10,"You Both went over 21.", 0, 19)
	player:GossipMenuAddItem(10,"again.", 0, 11)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function BlackJackOnPlay(event, player)

local guid = player:GetGUIDLow();
local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"You:"..Hand[guid].player.." :: Dealer:"..Hand[guid].dealer.."", 0, 9)
	player:GossipMenuAddItem(10,"hit me.", 0, 12)
	player:GossipMenuAddItem(10,"good bye.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function DealCard(event, player)

local guid = player:GetGUIDLow();
local suit = math.random(1,4);
local value = math.random(1,14);

local unit = player:GetMap():GetWorldObject(Hand[guid].unit_guid);

	if(Card[guid][suit][value][1] > 0)then
		local card = (Card[guid][suit][value][1]);
		return(card);
	else
		DealCard(event, timer, cycle, player);
	end
Card[guid][suit][value][1] = 0;
end

-- ******************************* --

local function BlackJackOnSelect(event, player, unit, sender, intid, code)

local guid = player:GetGUIDLow();

	if(player:GetItemCount(currency)>=bet)then
		if(intid<=7)then
			BlackJackOnHello(1, player);
		end
		if(intid==8)then -- goto/return instructions
			BlackJackInstructions(1, player);
		end
		if(intid==9)then -- return game screen 
			BlackJackOnPlay(1, player);
		end
		if(intid==10)then
			player:GossipComplete();
		end
	--	++++++++++++++++++++++++++++++++++++ --
		if(intid==11)then -- start game first deal
			ShuffleHand(player, Hand[guid].unit_guid);
			ShuffleCards(player);
			BlackJackOnSelect(event, player, unit, sender, 12, code);	
		end

		if(intid==12)then -- hit me
			player:RemoveItem(currency, bet);
			local pcard = DealCard(1, player);
			local dcard = DealCard(1, player);
			local win = (bet * Hand[guid].turns)*2;
		
			Hand[guid].player = (Hand[guid].player + pcard);
			Hand[guid].dealer = (Hand[guid].dealer + dcard);
			Hand[guid].turns =(Hand[guid].turns + 1);

				if((Hand[guid].player < 21)and(Hand[guid].dealer < 21))then
					BlackJackOnPlay(1, player)
				end
				
				if((Hand[guid].player==21)and(Hand[guid].dealer==21))then
					BlackJackOnDraw(1, player)
				end
				
				if((Hand[guid].player==21)and((Hand[guid].dealer < 21)or(Hand[guid].dealer > 21)))then
					player:AddItem(currency, win)
					BlackJackOnPlayerTO(1, player)
				end
				
				if(((Hand[guid].player < 21)or(Hand[guid].player > 21))and(Hand[guid].dealer==21))then
					BlackJackOnDealerTO(1, player)
				end
				
				if((Hand[guid].player < 21)and(Hand[guid].dealer > 21))then
					player:AddItem(currency, win)
					BlackJackOnPlayerWin(1, player)
				end
	
				if((Hand[guid].player > 21)and(Hand[guid].dealer < 21))then
					BlackJackOnDealerWin(1, player)
				end
				
				if((Hand[guid].player > 21)and(Hand[guid].dealer > 21))then
					BlackJackOnNoWinner(1, player)
				end
							
		end
	
		if(intid==13)then
			BlackJackOnPlayerTO(1, player)
		end
							
		if(intid==14)then
			BlackJackOnPlayerWin(1, player)
		end
		
		if(intid==15)then
			BlackJackOnDealerWin(1, player)
		end
		
		if(intid==16)then
			BlackJackOnDealerTO(1, player)
		end
							
		if(intid==17)then
			BlackJackOnDraw(1, player)
		end
		
		if(intid==18)then
			BlackJackOnNewPlay(1, player)
		end
	
		if(intid==19)then
			BlackJackOnNoWinner(1, player)
		end

	else
		player:SendBroadcastMessage("|cffFF0000move along now. you creeping me out .|r we only deal to players with "..currency_name.."'s.")
                                player:GossipComplete()
	end
end

RegisterCreatureGossipEvent(npcid, 1, BlackJackOnHello)
RegisterCreatureGossipEvent(npcid, 2, BlackJackOnSelect)

print("+Grumbo'z 21+")
print("+-+-+-+-+-+-+")
