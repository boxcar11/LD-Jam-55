extends MarginContainer

var Cardname = 'Archer'
@onready var CardInfo = CardDatabase.DATA[CardDatabase.get(Cardname)]
@onready var CardImg = str("res://assets/Cards/",CardInfo[0],"/",Cardname,".png")
var startpos = Vector2()
var targetpos = Vector2()
var startrot = 0
var targetrot = 0
var t = 0
var DRAWTIME = 1
var ORGANIZETIME = 0.5
@onready var Orig_scale = scale

var setup = true
var startscale = Vector2()
var Cardpos = Vector2()
var ZoomInSize = 2
var ZOOMINTIME = 0.2
var ReorganizeNeighbors = true
var NumberCardsHand = 0
var CardNum = 0
var NeighborCard
var Move_Neighbor_Card_Check = false
var state = InHand
var CARD_SELECT = true
var ZoomingIn = true
var oldstate
var INMOUSETIME = 0.1
var MovingtoPlay = false
var targetscale = Vector2()
var DiscardPile = Vector2()
var MovingToDiscard = false
var CardInPlay = false
var ZoomInSizeInPlay = 1.2
var oldpos = Vector2()
var oldscale = Vector2()
var Reparent = true

@onready var CardSlots = $"../../".slots
@onready var cardSlotEmpty = $'../../'.cardSlotEmpty
var CardSlotPos = Vector2()
var CardSlotSize = Vector2()
var mousepos = Vector2()
var curSlot
var modifer = 0

var oldAttack
var oldArmor
var oldHealth
var oldMaxHealth
var oldSpeed

var numEmpty = 0

@onready var mouseIsIn = $"../../".mouseIsIn

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand,
	MoveDrawnCardToDiscard
}

func _ready():
	# print(CardInfo)
	var CardSize = size
	#$Border.scale *= CardSize/$Border.texture.get_size()
	$Bars/CardFace/Image/Img.texture = load(CardImg)
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	$Focus.scale *= CardSize/$Focus.size
	var Attack = str(CardInfo[1])
	var Armor = str(CardInfo[2])
	var Health = str(CardInfo[3])
	var Speed = str(CardInfo[4])
	var SpecialText = str(CardInfo[7] + ", " + CardInfo[8])
	$Bars/TopBar/Name/CenterContainer/Name.text = CardInfo[6]
	$Bars/TopBar/Cost/CenterContainer/Cost.text = Speed
	$Bars/SpecialText/Type/CenterContainer/Type.text = SpecialText
	$Bars/BottomBar/Health/CenterContainer/Health.text = Health
	$Bars/BottomBar/Attack/CenterContainer/AandR.text = str(Attack,"/",Armor)

	oldAttack = CardInfo[1]
	oldArmor = CardInfo[2]
	oldHealth = CardInfo[3]
	oldMaxHealth= CardInfo[3]
	oldSpeed= CardInfo[4]

func _input(event):
	if event.is_action_pressed("leftclick"): # Pick up card	
		if state == FocusInHand:
			if CARD_SELECT:
				# oldstate = state
				state = InMouse
				setup = true
				CARD_SELECT = false
	if event.is_action_released("leftclick"):
		if CARD_SELECT == false:
			var useCardSlot = false
			if curSlot != null:
				useCardSlot = true
			if oldstate == InHand || oldstate == ReOrganizeHand || useCardSlot: #Putting a card in to slot
				for i in range(CardSlots.size()):
					if cardSlotEmpty[i]:
						if mouseIsIn[i]: 
							if CardInfo[0] == "Modifier":
								break;
							#if curSlot != null:
								#RemoveCard()
							cardSlotEmpty[i] = false
							setup = true
							MovingtoPlay = true		
							visible = false						
							targetpos = Vector2(100,100)
							curSlot = i
							CardSlots[i].Card = self
							CardSlots[i].get_child(1).texture = load(CardImg)
							CardSlots[curSlot].get_child(2).visible = true
							CardSlots[i].Attack = oldAttack
							CardSlots[i].Armor = oldArmor
							CardSlots[i].Health = oldHealth
							CardSlots[i].maxHealth = oldMaxHealth
							CardSlots[i].UpdateHealthBar()
							CardSlots[i].Speed = oldSpeed
							CardSlots[i].AttackType = CardInfo[7]
							CardSlots[i].canFight = true
							if CardInfo[5] == 6:
								CardSlots[i].Immune = 1
							else:
								CardSlots[i].Immune = 0
							if CardInfo[5] == 7:
								CardSlots[i].Immune = 2
							else:
								CardSlots[i].Immune = 0
							targetscale = CardSlotSize/size
							state = InPlay
							CARD_SELECT = true
							CardInPlay = true
							break
					elif CardInfo[0] == "Modifier":
						if mouseIsIn[i]:
							modifer = CardInfo[5]
							# print(modifer)
							match modifer:
								0: #Default:
									pass
								1: #IncreaseAttack:
									if CardSlots[i].AttackType == "Melee":
										CardSlots[i].Attack += CardInfo[1]
										# print(CardSlots[i].Attack)
										state = MoveDrawnCardToDiscard
								2: #IncreaseArmor:
									CardSlots[i].Armor = CardInfo[2]
									state = MoveDrawnCardToDiscard
								3: #InCreaseRangeAttackDamage:
									if CardSlots[i].AttackType == "Range":
										CardSlots[i].Attack += CardInfo[1]
										state = MoveDrawnCardToDiscard
								4: #IncreaseHealth:
									CardSlots[i].Health += CardInfo[3]
									state = MoveDrawnCardToDiscard
								5: #IncreaseSpeed:
									CardSlots[i].Speed += CardInfo[4]
									state = MoveDrawnCardToDiscard
							CardInPlay = true
				if state != InPlay:
					setup = true
					targetpos = Cardpos
					state = ReOrganizeHand
					CARD_SELECT = true
			else: # Handle once card is in play
				var Enemies = $'../../Enemies'
				for i in range(Enemies.get_child_count()):
						var EnemyPos = Enemies.get_child(i).position
						var EnemySize = Enemies.get_child(i).size*Enemies.get_child(i).scale
						mousepos = get_global_mouse_position()
						if mousepos.x < EnemyPos.x + EnemySize.x && mousepos.x > EnemyPos.x && mousepos.y < EnemyPos.y + EnemySize.y && mousepos.y > EnemyPos.y:
							# deal with damage
							var AttackNo = int($Bars/BottomBar/Attack/CenterContainer/AandR.text.left(1))
							Enemies.get_child(i).ChangeHealth(AttackNo)
							setup = true
							MovingToDiscard = true
							state = MoveDrawnCardToDiscard
							CARD_SELECT = true
							break
				if CARD_SELECT == false:
					setup = true
					MovingtoPlay = true
					state = InPlay
					CARD_SELECT = true
					if CardInPlay:
						targetpos = oldpos

func _physics_process(delta):
	#Look for dead creatures
	for i in range(CardSlots.size()):
		if CardSlots[i].Health <= 0 && !cardSlotEmpty[i]:
			RemoveCard()
			queue_free()
		
	match state:
		InHand:
			pass
		InPlay:
			if MovingtoPlay:
				if setup:
					Setup()
					if Reparent:
						$'../../'.ReParentCard(CardNum)
						Reparent = false
				if t <= 1:				
					position = startpos.lerp(targetpos, t)
					rotation_degrees = startrot * (1-t) + targetrot*t
					scale = startscale * (1-t) + targetscale*t
					t += delta/float(INMOUSETIME)
				else:
					position = targetpos
					rotation_degrees = targetrot
					scale = targetscale
					MovingtoPlay = false

		InMouse:
			if setup:
				Setup()
			if t <= 1:				
				position = startpos.lerp(get_global_mouse_position() - $"../../".CardSize/2, t)
				rotation_degrees = startrot * (1-t) + targetrot*t
				scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(INMOUSETIME)
			else:
				position = get_global_mouse_position() - $"../../".CardSize/2
				rotation_degrees = 0
				visible = true
		FocusInHand:
			if ZoomingIn:
				if setup:
					Setup()
				if t <= 1:
					position = startpos.lerp(targetpos, t)
					if CardInPlay:
						scale = startscale  * (1-t) + startscale*ZoomInSizeInPlay*t
						rotation_degrees = startrot * (1-t) + targetrot*t
					else:
						rotation_degrees = startrot * (1-t) + 0*t
						scale = startscale  * (1-t) + Orig_scale*ZoomInSize*t
					t += delta/float(ZOOMINTIME)
					if CardInPlay == false:
						if ReorganizeNeighbors:
							ReorganizeNeighbors = false
							NumberCardsHand = $"../../".NumberCardsHand
							if CardNum - 1 >= 0:
								Move_Neighbor_Card(CardNum-1,true,1) # True is left
							if CardNum - 2 >= 0:
								Move_Neighbor_Card(CardNum-2,true,0.25) # True is left
							if CardNum + 1 <= NumberCardsHand:
								Move_Neighbor_Card(CardNum+1,false,1) # True is left
							if CardNum + 2 <= NumberCardsHand:
								Move_Neighbor_Card(CardNum+2,false,0.25) # True is left
				else:
					position = targetpos
					if CardInPlay:
						scale = ZoomInSizeInPlay*startscale
						rotation_degrees = targetrot
					else:
						rotation_degrees = 0
						scale = Orig_scale*ZoomInSize
					ZoomingIn = false
		MoveDrawnCardToHand: # Animate from deck to hand
			if setup:
				Setup()
			if t <= 1:				
				position = startpos.lerp(targetpos, t)
				rotation_degrees = startrot * (1-t) + targetrot*t
				scale.x = Orig_scale.x * abs(2*t - 1)
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else:
				position = targetpos
				rotation_degrees = targetrot
				state = InHand
		ReOrganizeHand:
			if setup:
				Setup()
			if t <= 1:
				if Move_Neighbor_Card_Check:
					Move_Neighbor_Card_Check = false
				position = startpos.lerp(targetpos, t)
				if CardInPlay:
					scale = startscale  * (1-t) + oldscale*t
				else:
					rotation_degrees = startrot * (1-t) + targetrot*t
					scale = startscale  * (1-t) + Orig_scale*t			
					if ReorganizeNeighbors == false:
						ReorganizeNeighbors = true
						if CardNum - 1 >= 0:
							Reset_Card(CardNum-1) # True is left
						if CardNum - 2 >= 0:
							Reset_Card(CardNum-2) # True is left
						if CardNum + 1 <= NumberCardsHand:
							Reset_Card(CardNum+1) # True is left
						if CardNum + 2 <= NumberCardsHand:
							Reset_Card(CardNum+2) # True is left
				t += delta/float(ORGANIZETIME)
			else:
				position = targetpos
				if CardInPlay:
					scale = oldscale
					state = InPlay
				else:
					rotation_degrees = targetrot
					scale = Orig_scale
					state = InHand
		MoveDrawnCardToDiscard:
			if MovingToDiscard:
				if setup:
					Setup()
					targetpos = DiscardPile
				if t <= 1:				
					position = startpos.lerp(targetpos, t)
					scale = startscale  * (1-t) + Orig_scale*t
					t += delta/float(DRAWTIME)
				else:
					position = targetpos
					scale = Orig_scale
					MovingToDiscard = false

func Move_Neighbor_Card(Card_Num, Left, SpreadFactor):
	NeighborCard = $"../".get_child(Card_Num)
	if Left:
		NeighborCard.targetpos = NeighborCard.Cardpos - SpreadFactor*Vector2($'../../'.CardSize.x/2,0)
	else:
		NeighborCard.targetpos = NeighborCard.Cardpos + SpreadFactor*Vector2($'../../'.CardSize.x/2,0)
	NeighborCard.setup = true
	NeighborCard.state = ReOrganizeHand
	NeighborCard.Move_Neighbor_Card_Check = true

func Reset_Card(Card_Num):
	if NeighborCard.Move_Neighbor_Card_Check == false:
		NeighborCard = $"../".get_child(Card_Num)
		if NeighborCard.state != FocusInHand:
			NeighborCard.state = ReOrganizeHand
			NeighborCard.targetpos = NeighborCard.Cardpos
			NeighborCard.setup = true

func Setup():
	startpos = position
	startrot = rotation
	startscale = scale
	t= 0
	setup = false

func RemoveCard():
	CardSlots[curSlot].Card = null
	oldAttack = CardSlots[curSlot].Attack
	oldArmor = CardSlots[curSlot].Armor
	oldHealth = CardSlots[curSlot].Health
	oldMaxHealth= CardSlots[curSlot].maxHealth
	oldSpeed= CardSlots[curSlot].Speed
	CardSlots[curSlot].get_child(1).texture = null
	CardSlots[curSlot].get_child(2).visible = false
	#CarsSlots[curSlot].get_child(1)
	CardSlots[curSlot].canFight = false
	CardSlots[curSlot].fighting = false
	cardSlotEmpty[curSlot] = true

func mouse_entered():
	match state:
		InHand, ReOrganizeHand, InPlay:
			if CardInPlay:
				oldstate = InPlay
				oldpos = targetpos
				oldscale = targetscale
				targetpos = oldpos + CardSlotSize*0.5*(ZoomInSizeInPlay - 1)*Vector2(1,-1)
				setup = true
				ZoomingIn = true
				state = FocusInHand
			else:
				oldstate = state
				setup = true
				targetpos.x = Cardpos.x - $'../../'.CardSize.x/2
				targetpos.y = get_viewport().size.y - $"../../".CardSize.y * ZoomInSize
				ZoomingIn = true
				state = FocusInHand

func mouse_exited():
	match state:
		FocusInHand:
			setup = true
			state = ReOrganizeHand
			if(CardInPlay):
				targetpos = oldpos
			else:
				targetpos = Cardpos

func _on_focus_mouse_entered():
	mouse_entered()
	
func _on_focus_mouse_exited():
	mouse_exited()
