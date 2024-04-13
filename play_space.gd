extends Node2D

const CardSize = Vector2(150,200)
const CardBase = preload("res://Cards/cardBase.tscn")
const PlayerHand = preload("res://Cards/PlayerHand.gd")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()

@onready var CenterCardOval = get_viewport_rect().size * Vector2(0.5, 1.25)
@onready var Hor_Rad = get_viewport().size.x*0.45
@onready var Ver_Rad = get_viewport().size.y*0.4
var angle = 0
var CardSpread = 0.25
var NumberCardsHand = 0
var CardNum
var OvalAngleVector = Vector2()

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand
}

func _ready():
	pass

func drawCard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instantiate()
	CardSelected = randi() % DeckSize
	new_card.Cardname = PlayerHand.CardList[CardSelected]
	# new_card.position = get_global_mouse_position()
	OvalAngleVector = Vector2(Hor_Rad * cos(angle), -Ver_Rad * sin(angle))
	new_card.startpos = $Deck.position - CardSize/2
	new_card.targetpos = CenterCardOval + OvalAngleVector - CardSize
	new_card.startrot = 0
	new_card.targetrot = (90 - rad_to_deg(angle))/4
	new_card.scale = CardSize/new_card.size
	new_card.state = MoveDrawnCardToHand
	CardNum = 0
	for Card in $Cards.get_children(): # Reorganize hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - CardNum)
		OvalAngleVector = Vector2(Hor_Rad * cos(angle), -Ver_Rad * sin(angle))		
		Card.targetpos = CenterCardOval + OvalAngleVector - CardSize
		Card.startrot = Card.rotation
		Card.targetrot = (90 - rad_to_deg(angle))/4

		CardNum += 1
		if Card.state == InHand:
			Card.state = ReOrganizeHand
			Card.startpos = Card.position
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))
	$Cards.add_child(new_card)
	PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
	return DeckSize
