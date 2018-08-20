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

record effect_deets{
	int buff_pct;
	int duration;
	int revenue;
	int mall_price;
	int max_price;
	boolean will_use;
};

effect_deets [item] build_mallMeatPotion_list()
{
	float margin = 0.85;
	effect_deets [item] potion_list;
	file_to_map("/kol-meatfarm-dinsey/data/meat potions mall avail.txt", potion_list);
	
	foreach key in potion_list
	{
		potion_list[key].mall_price = mall_price(key);
		potion_list[key].revenue = total_base_meatDrop(potion_list[key].duration) * potion_list[key].buff_pct / 100;
		potion_list[key].max_price = to_int(potion_list[key].revenue * margin);
		potion_list[key].will_use = potion_list[key].mall_price <= potion_list[key].max_price;
	}
	
	return potion_list;
}

effect_deets [effect] build_recipeMeatBuff_list()
{
	float margin = 0.85;
	effect_deets [effect] meatEffect_list;
	
	meatEffect_list[$effect[Preternatural Greed]].buff_pct = 100;
	meatEffect_list[$effect[Preternatural Greed]].duration = 35;
	
	meatEffect_list[$effect[Eyes Wide Propped]].buff_pct = 50;
	meatEffect_list[$effect[Eyes Wide Propped]].duration = 45;
	
	foreach key in meatEffect_list
	{	
		switch(key)
		{
			case $effect[Preternatural Greed]:
				meatEffect_list[key].mall_price = mall_price($item[scroll of ancient forbidden unspeakable evil]) + 3*mall_price($item[thin black candle]);
				break;
			case $effect[Eyes Wide Propped]:
				item old_pants = equipped_item($slot[pants]);
				equip($item[Travoltan trousers]);
				meatEffect_list[key].mall_price = 4*mall_price($item[Rad Lib]) + 4*npc_price($item[soda water]);
				equip($slot[pants], old_pants);
				break;
			default:
		}
		
		meatEffect_list[key].revenue = total_base_meatDrop(meatEffect_list[key].duration) * meatEffect_list[key].buff_pct / 100;
		meatEffect_list[key].max_price = to_int(meatEffect_list[key].revenue * margin);
		meatEffect_list[key].will_use = meatEffect_list[key].mall_price <= meatEffect_list[key].max_price;
	}
	
	return meatEffect_list;
}

void print_potion_info(effect_deets [item] potion_list)
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
	print("Average total profit would be: " + total_profit, "blue");
}

void print_effect_info(effect_deets [effect] effect_list)
{
	int total_profit = 0;
	string color_txt = "blue";
	
	foreach key in effect_list
	{
		if(!effect_list[key].will_use)
			color_txt = "red";
		else
		{
			total_profit += effect_list[key].revenue - effect_list[key].mall_price;
			color_txt = "blue";
		}
		
		print(key + " pct:" + effect_list[key].buff_pct + " dur:" + effect_list[key].duration + " rev:" + effect_list[key].revenue + " mall:" + effect_list[key].mall_price + " max:" + effect_list[key].max_price, color_txt);	
	}
	print("Average total profit would be: " + total_profit, "blue");
}

void use_mallMeatPotions()
{
	if(get_property("_meatPotionsUsed").to_boolean())
		print("Mall meat potions already used today", "blue");
	else
	{
		set_property("_meatPotionsUsed", "true");
		effect_deets [item] meat_potions = build_mallMeatPotion_list();
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

void use_recipeBasedMeatBuffs()
{
	if(get_property("_recipeMeatBuffs").to_boolean())
		print("Recipe based meat buffs already used today", "blue");
	else
	{
		set_property("_recipeMeatBuffs", "true");
		int to_buy = 0;
		int to_make = 0;
		effect_deets [effect] recipe_MeatBuffs = build_recipeMeatBuff_list();
		print_effect_info(recipe_MeatBuffs);
		foreach key in recipe_MeatBuffs
			if(recipe_MeatBuffs[key].will_use)
				switch(key)
				{
					case $effect[Preternatural Greed]:
						if(get_property("demonSummoned").to_boolean())
							print("Demon already summoned today", "blue");
						else
						{
							to_buy = 3 - item_amount($item[thin black candle]);
							if(to_buy > 0)
								for x from 1 to to_buy
									cli_execute("mallbuy thin black candle @ " + 1.1*mall_price($item[thin black candle]));
							to_buy = 1 - item_amount($item[scroll of ancient forbidden unspeakable evil]);
							if(to_buy > 0)
								cli_execute("mallbuy scroll of ancient forbidden unspeakable evil @ " + 1.1*mall_price($item[scroll of ancient forbidden unspeakable evil]));
							if(get_property("questL11Manor") != "finished")
								print("Demon summoning chamber is not available", "blue");
							else
								cli_execute("summon Preternatural Greed");
						}
						break;
					case $effect[Eyes Wide Propped]:
						if(item_amount($item[papier-m&acirc;ch&eacute; toothpicks]) == 0)
						{
							to_buy = 4 - item_amount($item[soda water]);
							if(to_buy > 0)
							{
								item old_pants = equipped_item($slot[pants]);
								equip($item[Travoltan trousers]);
								buy(to_buy, $item[soda water]);
								equip($slot[pants], old_pants);
							}
							to_buy = 4 - item_amount($item[rad lib]);
							if(to_buy > 0)
								for x from 1 to to_buy
									cli_execute("mallbuy rad lib @ " + 1.1*mall_price($item[rad lib]));
							to_make = 4 - item_amount($item[papier-m&acirc;ch&eacute; glob]);
							create(4, $item[papier-m&acirc;ch&eacute; glob]);
							use(4, $item[papier-m&acirc;ch&eacute; glob]);
						}
						use(1, $item[papier-m&acirc;ch&eacute; toothpicks]);
						break;
					default:
				}
	}
}
