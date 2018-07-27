/* Check profit margins on meat-buff potions */

int [int] build_encounterList()
{
	int embezzler_count = 0;
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
	int dig_pointer = 15;
	encounter_list[dig_pointer] = embezzler_baseMPA;
	
	// Add wandering embezzlers from the Reanimator Wink
	for x from 1 to 3
	{
		dig_pointer += 20;
		encounter_list[dig_pointer] = embezzler_baseMPA;
	}
	
	// Add embezzlers from source terminal
	int dig_gap = 7;
	int dig_interval = 5;
	int dig_counter = 0;
	int dig_cast = 1;
	dig_pointer = 11;
	
	repeat
	{
		dig_pointer += dig_gap;
		if(dig_pointer < max_rounds)
		{
			encounter_list[dig_pointer] = embezzler_baseMPA;
			dig_counter++;
			if(dig_counter >= dig_interval && dig_cast < 3)
			{
				dig_cast++;
				dig_counter = 0;
				dig_gap = 7;
			}
			else if(dig_gap == 7)
				dig_gap = 20;
			else
				dig_gap += 10;
		}
	}until(dig_pointer > max_rounds);
	
	/*foreach key in encounter_list
		if (encounter_list[key] > 500)
		{
			embezzler_count++;
			print(key, "blue");
		}
	print("Number of Embezzlers: " + embezzler_count, "blue");*/
	
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

record potion_deets{
	int buff_pct;
	int duration;
	int revenue;
	int mall_price;
	int max_price;
	boolean will_use;
};

potion_deets [item] build_mallMeatPotion_list()
{
	float potion_margin = 0.85;
	potion_deets [item] potion_list;
	file_to_map("/kol-meatfarm-dinsey/data/meat potions mall avail.txt", potion_list);
	
	foreach key in potion_list
	{
		potion_list[key].mall_price = mall_price(key);
		potion_list[key].revenue = total_base_meatDrop(potion_list[key].duration) * potion_list[key].buff_pct / 100;
		potion_list[key].max_price = to_int(potion_list[key].revenue * potion_margin);
		potion_list[key].will_use = potion_list[key].mall_price <= potion_list[key].max_price;
	}
	
	return potion_list;
}

void print_potion_info(potion_deets [item] potion_list)
{
	int total_profit = 0;
	string color_txt = "blue";
	
	foreach key in potion_list
	{
		if(!potion_list[key].will_use)
			color_txt = "red";
		else
		{
			total_profit += potion_list[key].revenue - potion_list[key].mall_price;
			color_txt = "blue";
		}
		
		print(key + " pct:" + potion_list[key].buff_pct + " dur:" + potion_list[key].duration + " rev:" + potion_list[key].revenue + " mall:" + potion_list[key].mall_price + " max:" + potion_list[key].max_price, color_txt);	
	}
	print("Total profit will be: " + total_profit, "blue");
}

void use_mallMeatPotions()
{
	if(get_property("_meatPotionsUsed").to_boolean())
		print("Mall meat potions already used today", "blue");
	else
	{
		set_property("_meatPotionsUsed", "true");
		potion_deets [item] meat_potions = build_mallMeatPotion_list();
		print_potion_info(meat_potions);
		foreach key in meat_potions
			if(meat_potions[key].will_use)
			{
				if(item_amount(key) == 0)
					cli_execute("mallbuy " + key + " @ " + meat_potions[key].max_price);
				use(1, key);
			}
	}	
}