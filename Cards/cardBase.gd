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

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand,
	MoveDrawnCardToDiscard
}

func _input(event):
	match state:
		FocusInHand, InMouse, InPlay:
			if event.is_action_pressed("leftclick"): # Pick up card
				if CARD_SELECT:
					oldstate = state
					state = InMouse
					setup = true
					CARD_SELECT = false
			if event.is_action_released("leftclick"):
				if CARD_SELECT == false:
					if oldstate == FocusInHand: #Putting a card in to slot
						var CardSlots = $"../../CardSlots"
						var cardSlotEmpty = $'../../'.cardSlotEmpty
						for i in range(CardSlots.get_child_count()):
							if cardSlotEmpty[i]:
								var CardSlotPos = CardSlots.get_child(i).position
								var CardSlotSize = CardSlots.get_child(i).size
								var mousepos = get_global_mouse_position()
								if mousepos.x < CardSlotPos.x + CardSlotSize.x && mousepos.x > CardSlotPos.x && mousepos.y < CardSlotPos.y + CardSlotSize.y && mousepos.y > CardSlotPos.y:
									setup = true
									MovingtoPlay = true
									targetpos = CardSlotPos - $'../../'.CardSize/2
									targetscale = CardSlotSize/size
									state = InPlay
									CARD_SELECT = true
									break
						if state != InPlay:
							setup = true
							targetpos = Cardpos
							state = ReOrganizeHand
							CARD_SELECT = true
					else: # Handle once card is in play
						var Enemies = $'../../Enemies'
						for i in range(Enemies.get_child_count()):
								var EnemyPos = Enemies.get_child(i).position
								var EnemySize = Enemies.get_child(i).size
								var mousepos = get_global_mouse_position()
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

func _ready():
	# print(CardInfo)
	var CardSize = size
	#$Border.scale *= CardSize/$Border.texture.get_size()
	$Bars/CardFace/Image/Img.texture = load(CardImg)
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	$Focus.scale *= CardSize/$Focus.size
	var Attack = str(CardInfo[1])
	var Retaliation = str(CardInfo[2])
	var Health = str(CardInfo[3])
	var Cost = str(CardInfo[4])
	var SpecialText = str(CardInfo[6])
	$Bars/TopBar/Name/CenterContainer/Name.text = Cardname
	$Bars/TopBar/Cost/CenterContainer/Cost.text = Cost
	$Bars/SpecialText/Type/CenterContainer/Type.text = SpecialText
	$Bars/BottomBar/Health/CenterContainer/Health.text = Health
	$Bars/BottomBar/Attack/CenterContainer/AandR.text = str(Attack,"/",Retaliation)

func _physics_process(delta):
	match state:
		InHand:
			pass
		InPlay:
			if MovingtoPlay:
				if setup:
					Setup()
				if t <= 1:				
					position = startpos.lerp(targetpos, t)
					rotation_degrees = startrot * (1-t) + 0*t
					scale = startscale * (1-t) + targetscale*t
					t += delta/float(INMOUSETIME)
				else:
					position = targetpos
					rotation_degrees = 0
					scale = targetscale
					MovingtoPlay = false
					$'../../'.ReParentCard(CardNum)
		InMouse:
			if setup:
				Setup()
			if t <= 1:				
				position = startpos.lerp(get_global_mouse_position() - $"../../".CardSize, t)
				rotation_degrees = startrot * (1-t) + targetrot*t
				scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(INMOUSETIME)
			else:
				position = get_global_mouse_position() - $"../../".CardSize
				rotation_degrees = 0
		FocusInHand:
			if ZoomingIn:
				if setup:
					Setup()
				if t <= 1:
					position = startpos.lerp(targetpos, t)
					rotation_degrees = startrot * (1-t) + 0*t
					scale = startscale  * (1-t) + Orig_scale*2*t
					t += delta/float(ZOOMINTIME)
					if ReorganizeNeighbors:
						ReorganizeNeighbors = false
						NumberCardsHand = $"../../".NumberCardsHand - 1
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
				rotation_degrees = startrot * (1-t) + targetrot*t
				scale = startscale  * (1-t) + Orig_scale*t
				t += delta/float(ORGANIZETIME)
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
			else:
				position = targetpos
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
		NeighborCard.targetpos = NeighborCard.Cardpos - SpreadFactor*Vector2(65,0)
	else:
		NeighborCard.targetpos = NeighborCard.Cardpos + SpreadFactor*Vector2(65,0)
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

func _on_focus_mouse_entered():
	match state:
		InHand, ReOrganizeHand:
			setup = true
			targetpos = Cardpos
			targetpos.y = get_viewport().size.y - $"../../".CardSize.y * ZoomInSize
			ZoomingIn = true
			state = FocusInHand

func _on_focus_mouse_exited():
	match state:
		FocusInHand:
			setup = true
			targetpos = Cardpos
			state = ReOrganizeHand
