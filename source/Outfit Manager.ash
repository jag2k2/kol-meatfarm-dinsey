/* Manage outfits based on class and level */
void outfit_manager(string attire)
{
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
		if(item_amount(to_equip) == 0 && equipped_amount(to_equip) == 0)
		{
			print("Do not have " + to_equip, "red");
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
	
	print("Outfitting with " + attire, "blue");
	item to_hat = $item[none];
	familiar to_enthrone = $familiar[none];
	item to_back = $item[none];
	familiar to_bjorn = $familiar[none];
	item to_shirt = $item[none];
	item to_weapon = $item[none];
	item to_offhand = $item[none];
	item to_pants = $item[none];
	item to_acc1 = $item[none];
	item to_acc2 = $item[none];
	item to_acc3 = $item[none];
	familiar to_fam = $familiar[none];
	item to_famEquip = $item[none];
	
	switch (attire)
	{
		case "BM Farm":
			if(can_equip($item[crumpled felt fedora]))
				to_hat = $item[crumpled felt fedora];
			else if(can_equip($item[papier-mitre]))
				to_hat = $item[papier-mitre];

			to_back = $item[Buddy Bjorn];
			to_bjorn = $familiar[Golden Monkey];
			to_shirt = $item[origami pasties];
			
			if(my_class() == $class[seal clubber])
				to_weapon = $item[rope];
			else
				to_weapon = $item[haiku katana];
				
			to_offhand = $item[Half a Purse];
			
			if(can_equip($item[Great Wolf's beastly trousers]))
				to_pants = $item[Great Wolf's beastly trousers];
			else
				to_pants = $item[Pantsgiving];
				
			if(can_equip($item[mafia pointer finger ring]))
				to_acc1 = $item[mafia pointer finger ring];
				
			if(can_equip($item[mafia thumb ring]))
				to_acc2 = $item[mafia thumb ring];
				
			if(can_equip($item[cheap sunglasses]))
				to_acc3 = $item[cheap sunglasses];
				
			to_fam = $familiar[robortender];
			to_famEquip = $item[amulet coin];
			break;
		
		case "Embezzler Farm":
			if(can_equip($item[crumpled felt fedora]))
				to_hat = $item[crumpled felt fedora];
			else if(can_equip($item[papier-mitre]))
				to_hat = $item[papier-mitre];
			
			if(item_amount($item[carpe]) > 0 || equipped_amount($item[carpe]) > 0)
				to_back = $item[carpe];
			else
			{
				to_back = $item[Buddy Bjorn];
				to_bjorn = $familiar[Golden Monkey];
			}
			
			to_shirt = $item[origami pasties];
			
			if(my_class() == $class[seal clubber])
				to_weapon = $item[rope];
			else
				to_weapon = $item[haiku katana];
				
			to_offhand = $item[Half a Purse];
			
			if(can_equip($item[Great Wolf's beastly trousers]))
				to_pants = $item[Great Wolf's beastly trousers];
			else
				to_pants = $item[Pantsgiving];
			
			if(can_equip($item[mafia pointer finger ring]))
				to_acc1 = $item[mafia pointer finger ring];
				
			to_acc2 = $item[LOV Earrings];
			to_acc3 = $item[Belt of Loathing];
			to_fam = $familiar[robortender];
			to_famEquip = $item[amulet coin];
			break;
			
		case "Min MP Cost":
			if(can_equip($item[intimidating coiffure]))
				to_hat = $item[intimidating coiffure];
			else
				to_hat = $item[The Crown of Ed the Undying];
				
			if(item_amount($item[carpe]) > 0 || equipped_amount($item[carpe]) > 0)
				to_back = $item[carpe];
			else
				to_back = $item[Cloak of Dire Shadows];
			
			if(can_equip($item[sea salt scrubs]))
				to_shirt = $item[sea salt scrubs];
			else
				to_shirt = $item[white hat hacker T-shirt];
			
			if(can_equip($item[Hodgman's whackin' stick]))
				to_weapon = $item[Hodgman's whackin' stick];
			
			if(can_equip($item[Wand of Oscus]))
				to_offhand = $item[Wand of Oscus];
				
			if(can_equip($item[Oscus's dumpster waders]))
				to_pants = $item[Oscus's dumpster waders];
			
			if(can_equip($item[Oscus's pelt]))
				to_acc1 = $item[Oscus's pelt];
			
			if(can_equip($item[Pocket Square of Loathing]))
				to_acc2 = $item[Pocket Square of Loathing];

			to_acc3 = $item[Garland of Greatness];
			
			to_fam = $familiar[Disembodied Hand];
			if(can_equip($item[Hodgman's whackin' stick]))
				to_famEquip = $item[Hodgman's whackin' stick];
			break;
			
		case "Max MP":
			if(can_equip($item[intimidating coiffure]))
				to_hat = $item[intimidating coiffure];
			else
				to_hat = $item[The Crown of Ed the Undying];
				
			if(item_amount($item[carpe]) > 0 || equipped_amount($item[carpe]) > 0)
				to_back = $item[carpe];
			else
				to_back = $item[Cloak of Dire Shadows];
			
			if(can_equip($item[sea salt scrubs]))
				to_shirt = $item[sea salt scrubs];
			else
				to_shirt = $item[white hat hacker T-shirt];
			
			if(can_equip($item[Hodgman's whackin' stick]))
				to_weapon = $item[Hodgman's whackin' stick];
			
			if(can_equip($item[Hodgman's whackin' stick]))
				to_offhand = $item[Hodgman's whackin' stick];
				
			if(can_equip($item[Jeans of Loathing]))
				to_pants = $item[Jeans of Loathing];
				
			to_acc1 = $item[Garland of Greatness];
			to_acc2 = $item[Talisman of Baio];
			to_acc3 = $item[navel ring of navel gazing];
			
			to_fam = $familiar[Disembodied Hand];
			if(can_equip($item[Hodgman's whackin' stick]))
				to_famEquip = $item[Hodgman's whackin' stick];
			break;
			
		case "Free Fight":
			to_hat = $item[Crown of Thrones];
			to_enthrone = $familiar[BRICKO chick];
			to_back = $item[Buddy Bjorn];
			to_bjorn = $familiar[Warbear Drone];
			to_shirt = $item[Sneaky Pete's leather jacket];
			
			if(can_equip($item[Hodgman's whackin' stick]))
				to_weapon = $item[Hodgman's whackin' stick];
			else if(can_equip($item[Stick-Knife of Loathing]))
				to_weapon = $item[Stick-Knife of Loathing];
			else
				to_weapon = $item[Thor's Pliers];
				
			to_offhand = $item[KoL Con 13 snowglobe];
			to_pants = $item[Pantsgiving];
			to_acc1 = $item[Mr. Screege's spectacles];
			to_acc2 = $item[Mr. Cheeng's spectacles];
			
		
			if(item_amount($item[stinky cheese eye]) == 0 && equipped_amount($item[stinky cheese eye]) == 0)
				cli_execute("fold stinky cheese eye");
			to_acc3 = $item[stinky cheese eye];
		
			to_fam = $familiar[Golden Monkey];
			to_famEquip = $item[golden banana];
			break;
		
		case "PJs":
			to_hat = $item[leather aviator's cap];
			to_back = $item[octolus-skin cloak];
			to_shirt = $item[Sneaky Pete's leather jacket];
			to_weapon = $item[The Nuge's favorite crossbow];
			to_offhand = $item[blue LavaCo Lamp&trade;];
			if(can_equip($item[Pantaloons of Hatred]))
				to_pants = $item[Pantaloons of Hatred];
			else
				to_pants = $item[paperclip pants];
			to_acc1 = $item[fudgecycle];
			
			to_acc2 = $item[Treads of Loathing];
			to_acc3 = $item[Counterclockwise Watch];
			
			to_fam = $familiar[Trick-or-Treating Tot];
			to_famEquip = $item[li'l unicorn costume];
			
			break;
		
		default:
			print("Don't recognize that oufit", "blue");
			break;
	}		
		smart_equip($slot[hat], to_hat);
		smart_enthrone(to_enthrone);
		smart_equip($slot[back], to_back);
		smart_bjornify(to_bjorn);
		smart_equip($slot[shirt], to_shirt);
		smart_equip($slot[weapon], to_weapon);
		smart_equip($slot[off-hand], to_offhand);
		smart_equip($slot[pants], to_pants);
		smart_equip($slot[acc1], to_acc1);
		smart_equip($slot[acc2], to_acc2);
		smart_equip($slot[acc3], to_acc3);
		smart_fam(to_fam);
		smart_equip($slot[familiar], to_famEquip);
}