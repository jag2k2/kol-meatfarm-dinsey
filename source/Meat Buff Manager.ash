/* Check profit margins on meat-buff potions */

record buff_deets{
	item name;
	int buff_pct;
	int duration;
	int max_price;
};

record encounter_deets{
	string encounter;
	int base_mpa;
};

void print_buffs()
{
	buff_deets [int]potion_list;
	file_to_map("/kol-meatfarm-dinsey/data/meatbuff_list.txt", potion_list);

	foreach key in potion_list
	{
		print(potion_list[key].name + " " + potion_list[key].buff_pct + " " + potion_list[key].duration + " " + potion_list[key].max_price, "blue");
		
	}
}

int [int] build_encounterList()
{
	int max_rounds = 600;
	int [int] encounter_list;
	int boom_bonus = 0;
	float coaster_rate = 0.961;
	if(get_property("boomBoxSong") == "Total Eclipse of Your Meat")
		boom_bonus = 25;
	int embezzler_baseMPA = 1000 + boom_bonus;
	int barf_baseMPA = to_int((250 + boom_bonus)*(coaster_rate));

		for x from 1 to max_rounds
		encounter_list[x] = barf_baseMPA;
		
	// Add initial embezzler copies
	for x from 1 to 10
		encounter_list[x] = embezzler_baseMPA;
		
	// Add embezzler from enamorang
	encounter_list[15] = embezzler_baseMPA;
	
	// Add embezzlers from source terminal
	int dig_gap = 7;
	int dig_freq = 5;
	int dig_counter = 0;
	int dig_cast = 1;
	int dig_pointer = 10;
	
	repeat
	{
		dig_pointer += dig_gap;
		encounter_list[dig_pointer] = embezzler_baseMPA;
		dig_counter++;
		if(dig_counter >= dig_freq && dig_cast < 3)
		{
			dig_cast++;
			dig_counter = 0;
			dig_gap = 7;
		}
		else if(dig_gap == 7)
			dig_gap = 20;
		else
			dig_gap += 10;
		print(dig_pointer);
	}until(dig_pointer > max_rounds);
	
	
	return encounter_list;
}

int total_base_meatDrop(int rounds)
{
	int [int] enc_list = build_encounterList();
	int sum = 0;
	for x from 1 to rounds
		sum += enc_list[x];	
	return sum;		
}

/*	
	encounter_deets [int]bm_embezzFarm_encList;
	file_to_map("bm_enc_embezzler_farming.txt", bm_embezzFarm_encList);

	for x from 1 to 60											// Start with 60 adventures of barf moutain enemies
	{
		bm_embezzFarm_encList[x].encounter = "bm enemy";
		bm_embezzFarm_encList[x].meat_drop = 250;
	}

	for x from 1 to 10											// Replace embezzler encounters from copiers
	{
		bm_embezzFarm_encList[x].encounter = "embezzler";
		bm_embezzFarm_encList[x].meat_drop = 1000;
	}

	bm_embezzFarm_encList[16].encounter = "embezzler";			// Replace embezzler from LOV boomerang
	bm_embezzFarm_encList[16].meat_drop = 1000;

	for x from 18 to 34 by 8
	{
		bm_embezzFarm_encList[x].encounter = "embezzler";		// Replace embezzlers from digitizing
		bm_embezzFarm_encList[x].meat_drop = 1000;
	}

	bm_embezzFarm_encList[54].encounter = "embezzler";			// Replace residual embezzler from digitizing
	bm_embezzFarm_encList[54].meat_drop = 1000;

	for x from 20 to 60 by 20
	{
		bm_embezzFarm_encList[x].encounter = "embezzler";		// Replace embezzlers from reanimation
		bm_embezzFarm_encList[x].meat_drop = 1000;
	}

	int roller_timer = 26;
	for x from 19 to 60											// Based on my simulations the rollercoaster adventure happens every ~26 adventures.  bm_embezzFarm_encList[19] is the 104th adventure at barf mountain.
	{
		if(roller_timer < 25)
			roller_timer += 1;
		else if(bm_embezzFarm_encList[x].encounter != "embezzler")
		{
			bm_embezzFarm_encList[x].encounter = "roller coaster";		// Replace with rollercoaster
			bm_embezzFarm_encList[x].meat_drop = 0;
			roller_timer = 0;
		}
	}

	foreach key in bm_embezzFarm_encList
	{
		print(key + " " + bm_embezzFarm_encList[key].encounter + " " + bm_embezzFarm_encList[key].meat_drop, "blue");
	}

	int IntegralBaseDrop_bmEmbezzler(int duration)
	{
		int total_drop = 0;
		for x from 1 to duration
		{
			total_drop += bm_embezzFarm_encList[x].meat_drop;
		}
		return total_drop;
	}

	int potion_dur = 35;
	print(IntegralBaseDrop_bmEmbezzler(potion_dur)+ " " + potion_dur, "blue");
*/