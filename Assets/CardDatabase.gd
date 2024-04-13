extends Node

enum {Footman, Archer, SquadLeader, Warrior}

const DATA = {
	Footman :
		["Units", 1 , 1, 2, 1, "Footman", "Melee"],
	Archer : 
		["Units", 2 ,2, 3, 2, "Archer", "Ranged,\nInmmune to\nRetaliation"],
	SquadLeader :
		["Units", 2, 2, 3, 3, "SquadLeader", "Melee,\nGive all friendly\nn+1 Attach and \nRetaliation"],
	Warrior :
		["Units", 4, 0, 2, 3, "Rogue", "Melee,\nImmune to\nRetaliation"]
}
