extends Node

enum {Bunny, book001, frog, imp,airElemental,armor001,boots,earthElement,flamingSkull,potion001,shield001,shield002,
		slime,sword001,sword002,waterElemental,wyvern,zombie,wand001,archer,beholder,cultist,executioner,guard,guardDog,
		wizard}

const DATA = {
	Bunny :
		["Units", 1 , 1, 2, 1, "Bunny", "Melee"],
	book001 : 
		["Units", 2 ,2, 3, 2, "Book", "Ranged,\nInmmune to\nRetaliation"],
	frog :
		["Units", 2, 2, 3, 3, "Frog", "Melee,\nGive all friendly\nn+1 Attach and \nRetaliation"],
	imp :
		["Units", 4, 0, 2, 3, "Imp", "Melee,\nImmune to\nRetaliation"],
	airElemental :
		["Units",5,0,3,3,"Air Elemental","Ranged,\nImmune to Melee"],
	armor001 :
		["Modifier",0,0,0,0,"Worn Armor","Defense, \n +1 Defense"],
	boots :
		["Modifier",0,0,0,0,"Boots of Speed", "+15% Attack Speed"],
	earthElement :
		["Units",0,0,0,0,"Earth Elemental","Melee, Natural Armor +1 Armor"],
	flamingSkull :
		["Enemy",0,0,0,0,"Flaming Skull", "Ranged"],
	potion001 :
		["Modifier",0,0,0,0,"Healing Potion", "Heals for 10% of max health"],
	shield001 :
		["Modifier",0,0,0,0,"Wooden Buckler","Reduce damage by 1"],
	shield002 :
		["Modifier",0,0,0,0,"Tower Shield","Reduce damage by 2"],
	slime :
		["Units",0,0,0,0,"Slime","Melee, Reduce damage by 50%"],
	sword001 :
		["Modifier",0,0,0,0,"Rusty Sword","Increase damage by 1"],
	sword002 :
		["Modifier",0,0,0,0,"Steel Sword","Increase damage by 3"],
	wand001 :
		["Modifier",0,0,0,0,"Novice Wand","Increase range attack damage by 1"],
	waterElemental :
		["Units",0,0,0,0,"Water Elemental","Melee, Immune to range attacks"],
	wyvern :
		["Units",0,0,0,0,"Wyern","Ranged, Flying, Immune to melee"],
	zombie :
		["Units",0,0,0,0,"Zombie","Melee"],
	archer :
		["Enemy",0,0,0,0,"Archer","Ranged"],
	beholder :
		["Enemy",0,0,0,0,"Beholder","Ranged"],
	cultist :
		["Enemy",0,0,0,0,"Culitst","Ranged"],
	executioner :
		["Enemy",0,0,0,0,"Executioner","Melee"],
	guard :
		["Enemy",0,0,0,0,"guard","Melee"],
	guardDog :
		["Enemy",0,0,0,0,"Guard Dog","Melee"],
	wizard :
		["Enemy",0,0,0,0,"Wizard","Ranged"],
}
