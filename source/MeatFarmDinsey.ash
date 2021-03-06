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

/*Get buffs from buffy*/
int meatFarm_buffy_buffs()
{
	string buffy_msg = "";
	string sufficient_effects = "";
	effect [int]buffy_effect;

	if(have_effect($effect[Ode to Booze]) > 0)
		cli_execute("uneffect ode to booze");
	
	buffy_effect[1] = $effect[Fat Leon's Phat Loot Lyric];
	buffy_effect[2] = $effect[Polka of Plenty];
	buffy_effect[3] = $effect[Empathy];
	
	foreach int_index in buffy_effect
	{
		if(have_effect(buffy_effect[int_index]) < 50000)
			buffy_msg = buffy_msg + buffy_effect[int_index].to_string() + " ";
		else
			sufficient_effects = sufficient_effects + buffy_effect[int_index].to_string() + ", ";
	}
	
	if(sufficient_effects != "")
		print("Effects with enough turns: " + sufficient_effects, "blue");
	
	if(buffy_msg != "")
	{
		chat_private("buffy", buffy_msg);
		wait(10);
	}
	return 0;
}

/*Cast self effects*/
int self_buff_meat_effects(int duration)
{
	//Leash of Linguini 12MP for 10 turns
	//Disco Leer 10MP for 10 turns
	//Singer's Faithful Ocelot 15MP for 10 turns
	//rest_in_chateau();
	
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
			int total_casts = ceil((duration - have_effect(to_effect(self_buff[int_index])))/turns_per_cast(self_buff[int_index]));
			print("It will take " + total_casts + " casts to get " + self_buff[int_index] + " above " + duration, "blue");
			int mp_for_totcasts = total_casts * mp_cost(self_buff[int_index]);
			print("It will take " + mp_for_totcasts + " total mp to achieve that", "blue");
			int casts_afford = my_mp()/mp_cost(self_buff[int_index]);
			print("I can afford " + casts_afford + " casts", "blue");
			
			if(total_casts <= 0)
				print(self_buff[int_index] + " is at target duration", "blue");
			else if (casts_afford <= 0) 
				minor_mp_restore();
			else
				//print("Want to cast " + min(casts_afford, total_casts) + " times", "blue");
				use_skill(min(casts_afford, total_casts), self_buff[int_index]);
		}until(have_effect(to_effect(self_buff[int_index])) >= duration);
	}
	
	return 0;
}

/*Use base potions for meat farming*/
int meatFarm_base_potions()
{		
	if(have_effect($effect[On the Trail]) != 0)
	{
		if(get_property("olfactedMonster")=="garbage tourist")
			print("Olfacted Monster is already garbage tourist", "blue");
		else
			cli_execute("uneffect On the Trail");
	}
	else
		print("On the Trail is not active", "blue");

	if(have_effect($effect[Merry Smithsness]) < 450)
	{
		int flasks_to_drink = 1+(450-have_effect($effect[Merry Smithsness]))/150;
		use(flasks_to_drink, $item[Flaskfull of Hollow]);
	}
	else
		print("Merry Smithsness is already active", "blue");
	return 0;
}