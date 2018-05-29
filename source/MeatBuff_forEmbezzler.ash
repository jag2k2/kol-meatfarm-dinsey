/*Check profit margins on meat-buff potions*/

record buff_deets{
	item name;
	int buff_pct;
	int duration;
	int max_price;
};

record encounter_deets{
	string encounter;
	int meat_drop;
};

buff_deets [int]potion_list;
file_to_map("meatbuff_potions.txt", potion_list);

foreach key in potion_list
{
	print(potion_list[key].name + " " + potion_list[key].buff_pct + " " + potion_list[key].duration + " " + potion_list[key].max_price, "blue");
	
}

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
/*
foreach key in bm_embezzFarm_encList
{
	print(key + " " + bm_embezzFarm_encList[key].encounter + " " + bm_embezzFarm_encList[key].meat_drop, "blue");
}
*/
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