void check_OnTheTrail()
{
	if(have_effect($effect[On the Trail]) == 0)
		print("On the Trail is not active", "blue");
	else if(get_property("olfactedMonster")=="garbage tourist")
		print("Olfacted Monster is garbage tourist. Leave it.", "blue");
	else
		cli_execute("uneffect On the Trail");		
}

void dress_robortender()
{
	use_familiar($familiar[robortender]);
	if(get_property("_mummeryMods").contains_text("Meat Drop\: [30*fam(Robortender)]"))
		print("Robortender already has meat farming mummery costume", "blue");
	else
		cli_execute("mummery meat");
}

void booze_robortender()
{	
	if(get_property("_roboDrinks").contains_text("drive-by shooting"))
		print("Robortender already boozed up with drive-by shooting", "blue");
	else
	{
		retrieve_item(1, $item[drive-by shooting]);
		cli_execute("robo drive-by shooting");
	}
	
	if(get_property("_roboDrinks").contains_text("single entendre"))
		print("Robortender already boozed up with single entendre", "blue");
	else
	{
		if(item_amount($item[single entendre]) == 0)
			cli_execute("mallbuy single entendre @ 20000");
		cli_execute("robo single entendre");
	}
}

/*Create copiers if needed*/
void meatFarm_create_copiers()
{
	if(get_property("chateauMonster")!="Knob Goblin Embezzler")				// If chateau monster is not an embezzler make sure you have a watercolor set in inventory
		if(item_amount($item[alpine watercolor set]) == 0)
			buy(1, $item[alpine watercolor set]);
	
	if(item_amount($item[can of Rain-Doh]) > 0)
		use(1, $item[can of Rain-Doh]);
	else
		print("Already opened can of Rain-Doh", "blue");
	
	if(item_amount($item[4-d camera]) > 0)
		print("Already have one 4-d camera", "blue");
	else
		retrieve_item(1, $item[4-d camera]);
	
	if(item_amount($item[unfinished ice sculpture]) > 0)
		print("Already have one unfinished ice sculpture", "blue");
	else
		retrieve_item(1, $item[unfinished ice sculpture]);
}

/*Cast self effects*/
void self_buff_meat_effects(int target)
{
	skill [int]self_buff;
	self_buff[1] = $skill[Leash of Linguini];
	self_buff[2] = $skill[Disco Leer];
	self_buff[3] = $skill[Singer's Faithful Ocelot];
	self_buff[4] = $skill[Fat Leon's Phat Loot Lyric];
	
	if(have_effect($effect[Ode to Booze]) > 0)
		cli_execute("uneffect Ode to Booze");
	
	foreach int_index in self_buff
	{
		repeat
		{
			int total_casts = ceil((target - have_effect(to_effect(self_buff[int_index])))/to_float(turns_per_cast(self_buff[int_index])));
			int mp_for_totcasts = total_casts * mp_cost(self_buff[int_index]);
			int casts_afford = my_mp()/mp_cost(self_buff[int_index]);
			
			if(total_casts <= 0)
				print(self_buff[int_index] + " is at target duration", "blue");
			else
			{
				print(self_buff[int_index] + ": Target " + target + " adv. Cost: " + total_casts + " casts (" + mp_cost(self_buff[int_index]) + "mp) for a total of " + mp_for_totcasts + " mp. I can afford " + casts_afford + " casts.", "blue");
				if (casts_afford <= 0) 
					minor_mp_restore();
				else
					use_skill(min(casts_afford, total_casts), self_buff[int_index]);
			}
		}until(have_effect(to_effect(self_buff[int_index])) >= target);
	}
}

/*Use base potions for meat farming*/
void meatFarm_base_potions(int target)
{		
	record item_deets
	{
		item name;
		float duration;
	};
	
	item_deets [int]base_potion;
	base_potion[1].name = $item[Knob Goblin pet-buffing spray];
	base_potion[1].duration = 10.0;
	base_potion[2].name = $item[Knob Goblin nasal spray];
	base_potion[2].duration = 10.0;
	base_potion[3].name = $item[Flaskfull of Hollow];
	base_potion[3].duration = 150.0;
	base_potion[4].name = $item[How to Avoid Scams];
	base_potion[4].duration = 20.0;
	
	item old_pants = equipped_item($slot[pants]);
	equip($item[Travoltan trousers]);
	foreach int_index in base_potion
	{
		if(have_effect(effect_modifier(base_potion[int_index].name, "effect")) >= target)
			print(base_potion[int_index].name + " is already at target duration", "blue");
		else
		{
			int potions_to_take = ceil((target - have_effect(effect_modifier(base_potion[int_index].name, "effect")))/base_potion[int_index].duration);
			print(base_potion[int_index].name + ": Target " + target + " adv. Cost: " + potions_to_take + " potions needed.", "blue");
			retrieve_item(potions_to_take, base_potion[int_index].name);
			use(potions_to_take, base_potion[int_index].name);
		}
	}
	equip($slot[pants], old_pants);
}

/*Use Uncle Greenspan Bathroom Finance Guide and adventure until there are 5 effects left*/
void use_GreenSpan()
{
	int max_ugbfg_price = 40000;
	if(property_exists("_UncleGreenspanUsed"))
		print("Uncle Greenspan Bathroom Finance Guide already used today", "blue");
	else if (mall_price($item[Uncle Greenspan's Bathroom Finance Guide]) <= max_ugbfg_price)
	{
		retrieve_item(1, $item[Uncle Greenspan's Bathroom Finance Guide]);
		use(1, $item[Uncle Greenspan's Bathroom Finance Guide]);
		set_property("_UncleGreenspanUsed", "true");
	}
}

/*Get once per day meat buffs*/
void once_daily_meatBuffs()
{
	/* Witchess Buff */
	if(get_property("_witchessBuff").to_boolean())
		print("Already received Witchess buff today", "blue");
	else
		cli_execute("Witchess");
		
	/* Fortune Teller Buff */
	if(get_property("_clanFortuneBuffUsed").to_boolean())
		print("Already received Fortune Teller buff today", "blue");
	else
		cli_execute("fortune buff meat");
		
	/* Tunnel of L.O.V.E. buff */
	if(get_property("_loveTunnelUsed").to_boolean())
		print("Already visited Tunnel of L.O.V.E. today", "blue");
	else
	{
		visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel");
		run_choice(1);		// Enter the tunnel
		run_choice(2);		// Sneak around the Enforcer
		run_choice(3);		// Take the earrings
		run_choice(2);		// Sneak around the Engineer
		run_choice(2);		// Buff Open Heart Surgery
		run_choice(2);		// Sneak around the 
		
		if(item_amount($Item[LOV Enamorang]) > 0)
			run_choice(3);	// Get LOV Extraterrestrial Chocolate
		else
			run_choice(1);	// Get LOV Enamorang
	}
	
	/* Mysterious Island Arena Buff */
	if(get_property("sidequestArenaCompleted") != "fratboy")
		print("Cannot get a meat buff from the Mysterious Island Arena", "blue");
	else if(property_exists("_concertDone"))
		print("Already received today's concert buff from the Mysterious Island Arena", "blue");
	else
	{
		cli_execute("concert winklered");
		set_property("_concertDone", "true");
	}
		
	/* Defective Game Grid Token Buff */
	if(get_property("_defectiveTokenUsed").to_boolean())
		print("Already used the Defective Token today", "blue");
	else
		use(1, $item[Defective Game Grid Token]);
	
	/* Mad Hatter Buff */
	if(property_exists("_hatterBuff"))
		print("Already received today's mad hatter buff", "blue");
	else
	{
		cli_execute("hatter filthy knitted dread sack");
		set_property("_hatterBuff", "true");
	}
	
	/* Clan Pool Table Buff */
	if(get_property("_poolGames").to_int() >= 3)
		print("Already played in the clan pool table 3 times today", "blue");
	else
	{
		int max_pool_plays = 3;
		int to_play = max_pool_plays - get_property("_poolGames").to_int();
		for x from 1 to to_play
			cli_execute("pool Billiards Belligerence");
	}
	
	/* Clan Juke Box Buff */
	if(get_property("_jukebox").to_boolean())
		print("Already listened to clan jukebox today", "blue");
	else
		cli_execute("jukebox Material Witness");
	
	/* Bind Lasagmbie Buff */
	if(have_effect($effect[Pasta Eyeball]) > 0)
		print("Already have Pasta Eyeball effect", "blue");
	else if(my_thrall() == $thrall[Lasagmbie])
		print("Current thrall is already Lasagmbie", "blue");
	else
		use_skill(1, $skill[Bind Lasagmbie]);
	
	/* Have a ChibiChat */
	use_ChibiChat();
	
	/* Summon Greed Demon
	if(get_property("demonSummoned").to_boolean())
		print("Already summoned demon today", "blue");
	else
		cli_execute("summon Riptar Zielgam"); */
}

/* Farm Embezzlers using all available copies */
void farm_emezzler_copies()
{
	if(get_property("_photocopyUsed").to_boolean())							// Fight the faxed monster using a Reanimator Wink
		print("Already used photocopied monster today", "blue");
	else
	{
		use_familiar($familiar[Reanimated Reanimator]);
		if(familiar_equipment(my_familiar()) != $item[lucky Tam O'Shanter])
			equip($slot[familiar], $item[lucky Tam O'Shanter]);		
		use(1, $item[photocopied monster]);									//	Consult script will use the "Wink" skill
		use_familiar($familiar[robortender]);								//  Go back to robortender
	}
	
	if(get_property("_chateauMonsterFought").to_boolean())					// Fight the embezzler in the chateau painting
		print("Already fought the Chateau monster today", "blue");
	else if(get_property("chateauMonster")!="Knob Goblin Embezzler")
		print("Knob Goblin Embezzler was not copied into the Chateau painting", "blue");
	else
	{
		visit_url("place.php?whichplace=chateau&action=chateau_painting");
		run_combat();
	}

	if(item_amount($item[Spooky Putty monster])==0)							// Fight 1 embezzler using Spooky putty
		print("Spooky Putty monster not available", "blue");					
	else
		use(1, $item[Spooky Putty monster]);
	
	if(item_amount($item[Rain-Doh box full of monster])==0)					// Fight 5 embezzlers using Rain-Doh copies
		print("Rain-Doh box full of monster not available", "blue");
	else
		for x from 0 to (5 - get_property("_raindohCopiesMade").to_int())	// At least 1 copy has been made at this point
			use(1, $item[Rain-Doh box full of monster]);
			
	if(item_amount($item[shaking 4-d camera])==0)							// Fight 1 embezzler using 4-d camera
		print("Shaking 4-d camera not available", "blue");
	else
		use(1, $item[shaking 4-d camera]);
		
	if(item_amount($item[ice sculpture])==0)								// Fight 1 embezzler using Ice sculpture
		print("Ice sculpture not available", "blue");
	else
		use(1, $item[ice sculpture]);
}


