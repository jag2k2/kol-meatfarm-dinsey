
void open_dispensary()
{
	if(my_ascensions() > get_property("lastDispensaryOpen").to_int())
	{
		print("Need to open the Dispensary", "blue");
		outfit("Knob Goblin Elite Guard Uniform");
		adv1($location[Cobb's Knob Barracks], -1, "");
	}
	else
		print("Dispensary open", "blue");
}

void set_digFreq()
{
	int adv = my_adventures();
	int freq;
	if(adv < 56)
		freq = 1;			// reset after 7 adv
	else if(adv < 142)
		freq = 2;			// reset after 27 adv
	else if(adv < 252)
		freq = 3;			// reset after 57 adv
	else if(adv < 392)
		freq = 4;			// reset after 97 adv
	else if(adv < 562)
		freq = 5;			// reset after 147 adv
	else if(adv < 762)
		freq = 6;			// reset after 207 adv
	else
		freq = 7;			// reset after 277 adv
	print("Based on " + adv + " adventres, setting digitize frequency to " + freq, "blue");
	set_property("_bm_digFreq", freq);
}

void educate_digitize()
{
	if(get_property("sourceTerminalEducate1") == "digitize.edu" || get_property("sourceTerminalEducate2") == "digitize.edu")
		print("Digitize is already loaded into Source Terminal", "blue");
	else
		cli_execute("terminal educate digitize.edu");
}

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
	if(get_property("_mummeryMods").contains_text("Meat Drop\: [30*fam"))
		print("Someboady already has meat farming mummery costume", "blue");
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

/* Set Boombox */
void boomBox_meat()
{
	if(get_property("boomBoxSong") == "Total Eclipse of Your Meat")
		print("Boombox already set for meat buff", "blue");
	else
		cli_execute("boombox meat");
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
	open_dispensary();
	
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

/* Use Cast Sweet Synthesis */
void sweet_synthesis(int num_casts)
{
	int complex_max = 10000;
	item crimbo_companion;
	int to_buy = 0;
	int to_make = 0;
	string [int] synth_commands;
	
	item [3] crimbo_candy;
	crimbo_candy[0] = $item[Crimbo candied pecan];
	crimbo_candy[1] = $item[Crimbo fudge];
	crimbo_candy[2] = $item[Crimbo peppermint bark];

	if((spleen_limit() - my_spleen_use() - num_casts) < 0)
	{
		print("Not enough room in spleen for " + num_casts + " Sweet Synthesis casts.  Coercing down to " + (spleen_limit() - my_spleen_use()), "blue");
		num_casts = spleen_limit() - my_spleen_use();
	}
	
	if(num_casts > 0)
	{
		int each_crimbosNeeded = to_int(ceil(num_casts / 3.0));									// Trying to use all 3 complex crimbo candies evenly.  Ingredients will be bought/made in intervals of 3 so some extras are possible.
		int sheets_needed = 3*each_crimbosNeeded;												// The second complex candy will be some form of sugar sheet depending on which crimbo candy was used
		
		to_buy = sheets_needed - item_amount($item[sugar sheet]);								
		print("Need " + sheets_needed + " Sugar Sheets. Have to buy " + to_buy, "blue");
		if(to_buy > 0)
			for x from 1 upto to_buy
				cli_execute("mall buy sugar sheet @ " + complex_max);							// Buy any sugar sheets that you don't have

		
		foreach key in crimbo_candy																// For each crimbo candy..
		{
			switch(crimbo_candy[key])															// Define the second complex candy
			{
				case $item[Crimbo candied pecan]:
					crimbo_companion = $item[sugar shank];
					break;
				case $item[Crimbo fudge]:
					crimbo_companion = $item[sugar shirt];
					break;
				case $item[Crimbo peppermint bark]:
					crimbo_companion = $item[sugar shorts];
					break;
			}

			to_buy = each_crimbosNeeded - item_amount(crimbo_candy[key]);						// Find out how many of the crimbo candies need to be bought from mall
			to_make = each_crimbosNeeded - item_amount(crimbo_companion);						// Find out how many of the second candies need to be folded from a sugar sheet
			
			print("Need " + each_crimbosNeeded + " " + crimbo_companion + ", have to make " + to_make + ". Need " + each_crimbosNeeded + " " + crimbo_candy[key] + ", have to buy " + to_buy, "blue");
														
			if(to_buy > 0)
				for x from 1 upto to_buy
					cli_execute("mallbuy " + crimbo_candy[key] + " @ " + complex_max);			// Buy crimbo candies if needed
			create(to_make, crimbo_companion);													// Fold sugar sheets if needed
			
			for x from 1 to each_crimbosNeeded													// Build up a list of cli commands.  The size of this map could be bigger than "num_casts" since ingredients are made in intervals of 3
				synth_commands[count(synth_commands)] = "synthesize " + crimbo_candy[key] + ", " + crimbo_companion;
		}
		
		for x from 0 to (num_casts-1)
			cli_execute(synth_commands[x]);														// Go through the queue of commands and Cast Sweet Synthesis
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
	if(get_property("_madTeaParty").to_boolean() == true)
		print("Already received today's mad hatter buff", "blue");
	else
		cli_execute("hatter filthy knitted dread sack");
	
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
}

/* Farm Embezzlers using all available copies */
void farm_emezzler_copies()
{
	if(get_property("_photocopyUsed").to_boolean())							// Fight the faxed monster using a Reanimator Wink
		print("Already used photocopied monster today", "blue");
	else
		use(1, $item[photocopied monster]);									//	Consult script will use the "Wink" skill
	
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

/* Board Haunted Doghouse */
void board_doghouse()
{
	if(get_property("doghouseBoarded") == "false")
	{
		string doghouse_page = visit_url("campground.php?action=doghouse");
		
		int choice_index = doghouse_page.index_of("value=\"Board up the doghouse") - 35;  	
		if(choice_index < 0)
			print("Could not find choice to board up the doghouse", "blue");
		else
		{
			print("Boarding up Haunted Doghouse", "blue");
			run_choice(doghouse_page.char_at(choice_index).to_int());
		}
	}
}

/* Open Haunted Doghouse */
void open_doghouse()
{
	if(get_property("doghouseBoarded") == "true")
	{
		string doghouse_page = visit_url("campground.php?action=doghouse");
		
		int choice_index = doghouse_page.index_of("value=\"Pry the boards") - 35;  	
		if(choice_index < 0)
			print("Could not find choice to open the doghouse", "blue");
		else
		{
			print("Opening Haunted Doghouse", "blue");
			run_choice(doghouse_page.char_at(choice_index).to_int());
		}
	}
}

buffer bm_macro;
string mac_pick = "pickpocket;";
string mac_dig = "if monstername Knob Goblin Embezzler && hasskill digitize; skill digitize; endif;";
string mac_wink = "if monstername Knob Goblin Embezzler && hasskill wink at; skill wink at; endif;";
string mac_macromet = "if monstername horrible tourist family && hasskill macrometeorite; skill macrometeorite; endif;";
string mac_olfac = "if monstername garbage tourist && !haseffect on the trail; skill transcendent olfaction; endif;"; 
string mac_crit = "if sealclubber; skill furious wallop; endif; if hasskill Summer Siesta; skill Summer Siesta; endif;";
string mac_atk = "attack; repeat;";

bm_macro = append(bm_macro, mac_pick);
bm_macro = append(bm_macro, mac_macromet);
bm_macro = append(bm_macro, mac_olfac);
bm_macro = append(bm_macro, mac_crit);
bm_macro = append(bm_macro, mac_atk);

void farm_barf_mountain(int adv)
{
	int embez_count = 0;
	for x from 1 to adv
	{
		if((reverse_numberology(0,0) contains 69) && get_property("_universeCalculated").to_int() < 3)
			cli_execute("numberology 69");
								
		if(get_counters("digitize",0,0) == "Digitize Monster") 
		{
			embez_count++;
			board_doghouse();
			if(get_property("_sourceTerminalDigitizeUses").to_int() < 3 && get_property("_sourceTerminalDigitizeMonsterCount").to_int() >= get_property("_bm_digFreq").to_int())
				bm_macro = insert(bm_macro, 11, mac_dig);
		}			
		if(get_counters("enamorang",0,0)=="Enamorang Monster" && get_property("_badlyRomanticArrows").to_int() == 0)					// Switch to Reanimator (so the combat macro will wink at) when enamorang is about to expire
		{
			bm_macro = insert(bm_macro, 11, mac_wink);
			use_familiar($familiar[Reanimated Reanimator]);						
			if(familiar_equipment(my_familiar()) != $item[lucky Tam O'Shanter])	
				equip($slot[familiar], $item[lucky Tam O'Shanter]);
		}
		
		adventure(1 , $location[Barf Mountain], bm_macro);
					
		if(my_familiar()!= $familiar[robortender])
			use_familiar($familiar[robortender]);			//  If robortender was switched out for reanimation (or any other reaseon), switch back
		open_doghouse();
		print("Finished " + x + " of " + adv, "blue");
		print("Embezzler count:" + embez_count, "blue");
	}
}

