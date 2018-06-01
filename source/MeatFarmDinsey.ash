/*Prep outfit and familiar for meat farming*/
int meatFarm_fam_equip()
{
	outfit("meat farm");
	use_familiar($familiar[robortender]);
	
	if(familiar_equipment(my_familiar()) != $item[lucky Tam O'Shanter])
		equip($slot[familiar], $item[lucky Tam O'Shanter]);
	
	if(get_property("_mummeryMods").contains_text("Meat Drop\: [30*fam(Robortender)]"))
		print("Robortender already has meat farming mummery costume", "blue");
	else
	{
		cli_execute("mummery meat");
	}
	
	if(get_property("_roboDrinks").contains_text("drive-by shooting"))
		print("Robortender already boozed up for meat farming", "blue");
	else
	{
		retrieve_item(1, $item[drive-by shooting]);
		cli_execute("robo drive-by shooting");
	}
	return 0;
}

/*Create copiers if needed*/
int meatFarm_create_copiers()
{
	if(item_amount($item[4-d camera]) > 0)
		print("Already have one 4-d camera", "blue");
	else
	{
		retrieve_item(1, $item[4-d camera]);
	}
	
	if(item_amount($item[unfinished ice sculpture]) > 0)
		print("Already have one unfinished ice sculpture", "blue");
	else
	{
		retrieve_item(1, $item[unfinished ice sculpture]);
	}
	return 0;
}

/*Cast self effects*/
int self_buff_meat_effects(int target)
{
	outfit("min mp cost");
	
	skill [int]self_buff;
	self_buff[1] = $skill[Leash of Linguini];
	self_buff[2] = $skill[Disco Leer];
	self_buff[3] = $skill[Singer's Faithful Ocelot];
	
	foreach int_index in self_buff
	{
		repeat
		{
			print(mp_cost(self_buff[int_index]) + " mp to cast " + self_buff[int_index], "blue");
			int total_casts = ceil((target - have_effect(to_effect(self_buff[int_index])))/to_float(turns_per_cast(self_buff[int_index])));
			print("It will take " + total_casts + " casts to get " + self_buff[int_index] + " above " + target, "blue");
			int mp_for_totcasts = total_casts * mp_cost(self_buff[int_index]);
			print("It will take " + mp_for_totcasts + " total mp to achieve that", "blue");
			int casts_afford = my_mp()/mp_cost(self_buff[int_index]);
			print("I can afford " + casts_afford + " casts", "blue");
			
			if(total_casts <= 0)
				print(self_buff[int_index] + " is at target duration", "blue");
			else if (casts_afford <= 0) 
				minor_mp_restore();
			else
				use_skill(min(casts_afford, total_casts), self_buff[int_index]);
		}until(have_effect(to_effect(self_buff[int_index])) >= target);
	}
	
	return 0;
}

/*Use base potions for meat farming*/
int meatFarm_base_potions(int target)
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
	
	
	if(have_effect($effect[On the Trail]) != 0)
	{
		if(get_property("olfactedMonster")=="garbage tourist")
			print("Olfacted Monster is already garbage tourist", "blue");
		else
			cli_execute("uneffect On the Trail");
	}
	else
		print("On the Trail is not active", "blue");

	equip($item[Travoltan trousers]);
	foreach int_index in base_potion
	{
		if(have_effect(effect_modifier(base_potion[int_index].name, "effect")) < target)
		{
			int potions_to_take = ceil((target - have_effect(effect_modifier(base_potion[int_index].name, "effect")))/base_potion[int_index].duration);
			retrieve_item(potions_to_take, base_potion[int_index].name);
			use(potions_to_take, base_potion[int_index].name);
		}
		else
		{
			print(base_potion[int_index].name + " is already at target duration", "blue");
		}
	}
	return 0;
}

/*Use Uncle Greenspan Bathroom Finance Guide and adventure until there are 5 effects left*/
void advBM_BuildGreenSpan()
{
	int max_ugbfg_price = 40000;
	if(!property_exists("_UncleGreenspanUsed"))
		set_property("_UncleGreenspanUsed", "false");

	if(get_property("_UncleGreenspanUsed").to_boolean())
		print("Uncle Greenspan Bathroom Finance Guide already used today", "blue");
	else if (mall_price($item[Uncle Greenspan's Bathroom Finance Guide]) <= max_ugbfg_price)
	{
		retrieve_item(1, $item[Uncle Greenspan's Bathroom Finance Guide]);
		use(1, $item[Uncle Greenspan's Bathroom Finance Guide]);
		set_property("_UncleGreenspanUsed", "true");
	}
	
	

}