extends Node

enum {Bunny, book001, frog, imp,airElemental,armor001,boots,earthElement,flamingSkull,potion001,shield001,shield002,
		slime,sword001,sword002,waterElemental,wyvern,zombie,wand001,archer,beholder,cultist,executioner,guard,guardDog,
		wizard}

#[Folder, Attack, Armor, Health, Speed, Modifer, Name, Attack Type, Text]


#[Default, IncreaseAttack, IncreaseArmor, InCreaseRangeAttack, IncreaseHealth, IncreaseSpeed, ImmuneToRange, ImmuneToMelee]


const DATA = {
	Bunny :
		["Units", 1 , 1, 2, 1, 0, "Bunny", "Melee", ""],
	book001 : 
		["Units", 2 ,2, 3, 2, 0, "Book", "Ranged","Inmmune to\nRetaliation"],
	frog :
		["Units", 2, 2, 20, 3, 0, "Frog", "Melee", ""],
	imp :
		["Units", 4, 0, 2, 3, 0, "Imp", "Melee","Immune to\nRetaliation"],
	airElemental :
		["Units",5,0,3,3, 0,"Air Elemental","Ranged","Immune to Melee"],
	armor001 :
		["Modifier",0,0,0,0, 0,"Worn Armor","Defense"," +1 Defense"],
	boots :
		["Modifier",0,0,0,0, 0,"Boots of Speed", "", "+15% Attack Speed"],
	earthElement :
		["Units",1,1,1,1, 0,"Earth Elemental","Melee"," Natural Armor +1 Armor"],
	flamingSkull :
		["Enemies",0,0,0,0, 0,"Flaming Skull", "Ranged", ""],
	potion001 :
		["Modifier",0,0,50,0, 4,"Healing Potion", "","Heals for 3 health"],
	shield001 :
		["Modifier",0,1,0,0, 0,"Wooden Buckler","","Reduce damage by 1"],
	shield002 :
		["Modifier",0,2,0,0,0,"Tower Shield","","Reduce damage by 2"],
	slime :
		["Units",0,0,0,0,0,"Slime","Melee","Reduce damage by 50%"],
	sword001 :
		["Modifier",1,0,0,0,1,"Rusty Sword","","Increase damage by 1"],
	sword002 :
		["Modifier",3,0,0,0,1,"Steel Sword","","Increase damage by 3"],
	wand001 :
		["Modifier",0,0,0,0,0,"Novice Wand","","Increase range attack damage by 1"],
	waterElemental :
		["Units",0,0,0,0,0,"Water Elemental","","Melee, Immune to range attacks"],
	wyvern :
		["Units",0,0,0,0,0,"Wyern","Ranged","Flying, Immune to melee"],
	zombie :
		["Units",0,0,0,0,0,"Zombie","Melee",""],
	archer :
		["Enemies",1,1,10,1,0,"Archer","Ranged",""],
	beholder :
		["Enemies",0,0,0,0,0,"Beholder","Ranged",""],
	cultist :
		["Enemies",0,0,0,0,0,"Culitst","Ranged",""],
	executioner :
		["Enemies",0,0,0,0,0,"Executioner","Melee",""],
	guard :
		["Enemies",0,0,0,0,0,"guard","Melee",""],
	guardDog :
		["Enemies",2,1,10,1,0,"Guard Dog","Melee",""],
	wizard :
		["Enemies",1,1,10,1,0,"Wizard","Ranged",""],
}
