/* Remove all stinky cheese equipment */
void remove_stinkyCheese()
{
	if(equipped_item($slot[pants]) == $item[stinky cheese diaper])
		equip($slot[pants], $item[none]);
	if(equipped_item($slot[weapon]) == $item[stinky cheese sword] || equipped_item($slot[weapon]) == $item[Staff of Queso Escusado])
		equip($slot[weapon], $item[none]);
	if(equipped_item($slot[off-hand]) == $item[stinky cheese wheel])
		equip($slot[off-hand], $item[none]);
	if(equipped_item($slot[acc1]) == $item[stinky cheese eye])
		equip($slot[acc1], $item[none]);
	if(equipped_item($slot[acc2]) == $item[stinky cheese eye])
		equip($slot[acc2], $item[none]);
	if(equipped_item($slot[acc3]) == $item[stinky cheese eye])
		equip($slot[acc3], $item[none]);
}

/* Manage outfits based on class and level */
void outfit_manager(string attire)
{
	item best_equip(item [int] equip_list)
	{
		foreach key in equip_list
			if(can_equip(equip_list[key]))
			{
				if(equip_list[key] == $item[stinky cheese sword] || equip_list[key] == $item[stinky cheese wheel] || equip_list[key] == $item[stinky cheese diaper] || equip_list[key] == $item[stinky cheese eye] || equip_list[key] == $item[Staff of Queso Escusado])
					cli_execute("fold " + equip_list[key]);
				if(item_amount(equip_list[key]) == 0 && equipped_amount(equip_list[key]) == 0)
					print("Do not have " + equip_list[key], "red");
				else
					return equip_list[key];
			}
		return $item[none];
	}
	
	void smart_equip(slot to_slot, item to_equip)
	{
		if(to_equip == $item[none])
		{
			print("No equipment selected for " + to_slot, "red");
			return;
		}
		if(to_equip == equipped_item(to_slot))
		{
			print(to_equip + " is already equipped", "blue");
			return;
		}
		if(item_amount(to_equip) == 0 && equipped_amount(to_equip) > 0)
		{
			slot other = to_slot(to_equip);
			equip(other, $item[none]);
		}
		equip(to_slot, to_equip);
	}

	void smart_enthrone(familiar fam)
	{
		if(equipped_item($slot[hat]) == $item[Crown of Thrones])
		{
			if(fam == $familiar[none])
				print("Crown of Thrones equipped but no familiar was selected", "red");
			else if(fam == my_enthroned_familiar())
				print(fam + " is already enthroned", "blue");
			else if(!have_familiar(fam))
				print("Cannot find " + fam, "red");
			else
				enthrone_familiar(fam);
		}
	}
	
	void smart_bjornify(familiar fam)
	{
		if(equipped_item($slot[back]) == $item[Buddy Bjorn])
		{
			if(fam == $familiar[none])
				print("Bjorn equipped but no familiar was selected", "red");
			else if(fam == my_bjorned_familiar())
				print(fam + " is already in bjorn", "blue");
			else if(!have_familiar(fam))
				print("Cannot find " + fam, "red");
			else
				bjornify_familiar(fam);
		}
	}
	
	void smart_fam(familiar fam)
	{
		if(fam == $familiar[none])
			print("No familiar is selected", "red");
		else if(my_familiar() == fam)
			print(fam + " is already your familiar", "blue");
		else
			use_familiar(fam);
	}
	
	item [int] hat_list;
	familiar to_enthrone = $familiar[none];
	item [int] back_list;
	familiar to_bjorn = $familiar[none];
	item [int] shirt_list;
	item [int] weapon_list;
	item [int] offhand_list;
	item [int] pants_list;
	item [int] acc1_list;
	item [int] acc2_list;
	item [int] acc3_list;
	familiar to_fam = $familiar[none];
	item [int] famEquip_list;
	
	print("Outfitting with " + attire, "blue");
	switch (attire)
	{
		case "BM Farm":
			hat_list[0] = $item[crumpled felt fedora];
			hat_list[1] = $item[wad of used tape];
			hat_list[2] = $item[papier-mitre];	

			back_list[0] = $item[Buddy Bjorn];
			to_bjorn = $familiar[Golden Monkey];
			
			shirt_list[0] = $item[origami pasties];
			
			if(my_class() == $class[seal clubber])
				weapon_list[0] = $item[rope];
			else
				weapon_list[0] = $item[haiku katana];
				
			offhand_list[0] = $item[Half a Purse];
			
			pants_list[0] = $item[Great Wolf's beastly trousers];
			pants_list[1] = $item[Pantsgiving];
			
			acc1_list[0] = $item[mafia pointer finger ring];
			
			acc2_list[0] = $item[mafia thumb ring];	
			
			acc3_list[0] = $item[cheap sunglasses];
				
			to_fam = $familiar[robortender];
			famEquip_list[0] = $item[amulet coin];
			famEquip_list[1] = $item[lucky Tam O'Shanter];
			
			break;
		
		case "Embezzler Farm":
			hat_list[0] = $item[crumpled felt fedora];
			hat_list[1] = $item[wad of used tape];
			hat_list[2] = $item[papier-mitre];	
			
			back_list[0] = $item[carpe];
			back_list[1] = $item[Buddy Bjorn];

			to_bjorn = $familiar[Golden Monkey];
			
			shirt_list[0] = $item[origami pasties];
			
			if(my_class() == $class[seal clubber])
				weapon_list[0] = $item[rope];
			else
				weapon_list[0] = $item[haiku katana];
				
			offhand_list[0] = $item[Half a Purse];
			
			pants_list[0] = $item[Great Wolf's beastly trousers];
			pants_list[1] = $item[Pantsgiving];
			
			acc1_list[0] = $item[mafia pointer finger ring];
			
			acc2_list[0] = $item[LOV Earrings];
			
			acc3_list[0] = $item[Belt of Loathing];
			acc3_list[1] = $item[incredibly dense meat gem];
			
			to_fam = $familiar[robortender];
			famEquip_list[0] = $item[amulet coin];
			famEquip_list[1] = $item[lucky Tam O'Shanter];
			break;
			
		case "Min MP Cost":
			hat_list[0] = $item[intimidating coiffure];
			hat_list[1] = $item[jewel-eyed wizard hat];
				
			back_list[0] = $item[carpe];
			back_list[1] = $item[Cloak of Dire Shadows];
			
			shirt_list[0] = $item[sea salt scrubs];
			shirt_list[1] = $item[white hat hacker T-shirt];
			
			weapon_list[0] = $item[Hodgman's whackin' stick];
			
			offhand_list[0] = $item[Wand of Oscus];
				
			pants_list[0] = $item[Oscus's dumpster waders];
			
			acc1_list[0] = $item[Oscus's pelt];
			
			acc2_list[0] = $item[Pocket Square of Loathing];
			acc2_list[1] = $item[stainless steel solitaire];
			
			acc3_list[0] = $item[Garland of Greatness];
			
			to_fam = $familiar[Disembodied Hand];
			famEquip_list[0] = $item[Hodgman's whackin' stick];

			break;
			
		case "Max MP":
			hat_list[0] = $item[intimidating coiffure];
			hat_list[1] = $item[The Crown of Ed the Undying];
				
			back_list[0] = $item[carpe];
			back_list[1] = $item[Cloak of Dire Shadows];

			shirt_list[0] = $item[sea salt scrubs];
			shirt_list[1] = $item[white hat hacker T-shirt];
			
			weapon_list[0] = $item[Hodgman's whackin' stick];
			weapon_list[1] = $item[Sword of Dark Omens];
			
			offhand_list[0] = $item[Hodgman's whackin' stick];
			offhand_list[1] = $item[VYKEA hex key];
			
			pants_list[0] = $item[Jeans of Loathing];
			pants_list[1] = $item[sugar shorts];
			pants_list[2] = $item[Greatest American Pants];
				
			acc1_list[0] = $item[Garland of Greatness];
			
			acc2_list[0] = $item[Talisman of Baio];
			
			acc3_list[0] = $item[navel ring of navel gazing];
			
			to_fam = $familiar[Disembodied Hand];
			famEquip_list[0] = $item[Hodgman's whackin' stick];
			famEquip_list[1] = $item[VYKEA hex key];
			
			break;
			
		case "Free Fight":
			remove_stinkyCheese();
		
			hat_list[0] = $item[Crown of Thrones];
			to_enthrone = $familiar[Garbage Fire];
			
			back_list[0] = $item[Buddy Bjorn];
			to_bjorn = $familiar[Warbear Drone];
			
			shirt_list[0] = $item[sea salt scrubs];
			shirt_list[1] = $item[Sneaky Pete's leather jacket];
			
			weapon_list[0] = $item[stinky cheese sword];
				
			offhand_list[0] = $item[stinky cheese wheel];
			
			pants_list[0] = $item[Pantsgiving];
			
			acc1_list[0] = $item[Mr. Screege's spectacles];
			
			acc2_list[0] = $item[Mr. Cheeng's spectacles];
					
			acc3_list[0] = $item[stinky cheese eye];
		
			to_fam = $familiar[Golden Monkey];
			famEquip_list[0] = $item[Mayflower bouquet];
			
			break;
		
		case "Item Drop":
			hat_list[0] = $item[bounty-hunting helmet];
			
			back_list[0] = $item[protonic accelerator pack];
			
			shirt_list[0] = $item[flaming pink shirt];
			
			weapon_list[0] = $item[Spelunker's whip];
			
			offhand_list[0] = $item[hypnodisk];
			
			pants_list[0] = $item[bounty-hunting pants];
			
			acc1_list[0] = $item[Mayor Ghost's sash];
			acc1_list[1] = $item[Mr. Cheeng's spectacles];
			
			acc2_list[0] = $item[Mr. Accessory Jr.];
			
			acc3_list[0] = $item[Mr. Accessory Jr.];
			
			to_fam = $familiar[Pair of Stomping Boots];
			famEquip_list[0] = $item[Snow Suit];
			
			break;
		
		case "Elem Res":
			hat_list[0] = $item[orange peel hat];
			
			back_list[0] = $item[Buddy Bjorn];
			to_bjorn = $familiar[Twitching Space Critter];
			
			shirt_list[0] = $item[Hodgman's disgusting technicolor overcoat];
			shirt_list[1] = $item[gnauga hide vest];
			
			weapon_list[0] = $item[titanium assault umbrella];
			
			offhand_list[0] = $item[Dallas Dynasty Falcon Crest shield];
			
			pants_list[0] = $item[Pantsgiving];
			
			acc1_list[0] = $item[Pocket Square of Loathing];
			acc1_list[1] = $item[ghost of a necklace];
			
			acc2_list[0] = $item[over-the-shoulder Folder Holder];
			
			acc3_list[0] = $item[perfume-soaked bandana];
			
			to_fam = $familiar[Trick-or-Treating Tot];
			famEquip_list[0] = $item[li'l candy corn costume];
			
			break;
		
		case "PJs":
			remove_stinkyCheese();
			
			hat_list[0] = $item[leather aviator's cap];
			
			back_list[0] = $item[octolus-skin cloak];
			
			shirt_list[0] = $item[Sneaky Pete's leather jacket];
			
			weapon_list[0] = $item[The Nuge's favorite crossbow];
			
			offhand_list[0] = $item[blue LavaCo Lamp&trade;];
			
			pants_list[0] = $item[stinky cheese diaper];
			pants_list[1] = $item[Pantaloons of Hatred];
			pants_list[2] = $item[paperclip pants];
			
			acc1_list[0] = $item[fudgecycle];
			acc1_list[1] = $item[numberwang];
			
			acc2_list[0] = $item[Treads of Loathing];
			acc2_list[1] = $item[Boots of Twilight Whispers];
						
			acc3_list[0] = $item[Counterclockwise Watch];
			
			to_fam = $familiar[Trick-or-Treating Tot];
			famEquip_list[0] = $item[li'l unicorn costume];
			
			break;
		
		default:
			print("Don't recognize that oufit", "blue");
			break;
	}		
		smart_equip($slot[hat], best_equip(hat_list));
		smart_enthrone(to_enthrone);
		smart_equip($slot[back], best_equip(back_list));
		smart_bjornify(to_bjorn);
		smart_equip($slot[shirt], best_equip(shirt_list));
		smart_equip($slot[weapon], best_equip(weapon_list));
		smart_equip($slot[off-hand], best_equip(offhand_list));
		smart_equip($slot[pants], best_equip(pants_list));
		smart_equip($slot[acc1], best_equip(acc1_list));
		smart_equip($slot[acc2], best_equip(acc2_list));
		smart_equip($slot[acc3], best_equip(acc3_list));
		smart_fam(to_fam);
		smart_equip($slot[familiar], best_equip(famEquip_list));
}