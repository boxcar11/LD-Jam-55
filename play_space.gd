extends Node2D

const CardSize = Vector2(150,200)
const CardBase = preload("res://Cards/cardBase.tscn")
const PlayerHand = preload("res://Cards/PlayerHand.gd")
const CardSlot = preload("res://Cards/card_slot.tscn")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()

@onready var CenterCardOval = get_viewport_rect().size * Vector2(0.5, 1.25)
@onready var Hor_Rad = get_viewport().size.x*0.45
@onready var Ver_Rad = get_viewport().size.y*0.4
@onready var DeckPosition = $Deck.position
@onready var DiscardPosition = $Discard.position
var angle = 0
var CardSpread = 0.25
var NumberCardsHand = -1
var CardNum = 0
var OvalAngleVector = Vector2()

var cardSlotEmpty = []

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
	randomize()
	$Enemies/Enemy.visible = true
	$Enemies/Enemy.position = get_viewport().size*0.4 + Vector2(200,0)
	$Enemies/Enemy.scale *= 0.3
	var NewSlot = CardSlot.instantiate()
	NewSlot.position = get_viewport().size*0.4
	NewSlot.size = CardSize
	$CardSlots.add_child(NewSlot)
	cardSlotEmpty.append(true)

func drawCard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instantiate()
	CardSelected = randi() % DeckSize
	new_card.Cardname = PlayerHand.CardList[CardSelected]
	new_card.position = DeckPosition
	new_card.DiscardPile = DiscardPosition
	new_card.scale = CardSize/new_card.size
	new_card.state = MoveDrawnCardToHand
	CardNum = 0
	$Cards.add_child(new_card)
	PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
	OrganizeHand()
	return DeckSize

func ReParentCard(CardNo):
	NumberCardsHand -= 1
	CardNum = 0
	var Card = $Cards.get_child(CardNo)
	$Cards.remove_child(Card)
	$CardsInPlay.add_child(Card)
	OrganizeHand()

func OrganizeHand():
	for Card in $Cards.get_children(): # Reorganize hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - CardNum)
		OvalAngleVector = Vector2(Hor_Rad * cos(angle), -Ver_Rad * sin(angle))		
		Card.targetpos = CenterCardOval + OvalAngleVector - CardSize
		Card.Cardpos  = Card.targetpos# Card default pos
		Card.startrot = Card.rotation
		Card.targetrot = (90 - rad_to_deg(angle))/4
		Card.CardNum = CardNum
		CardNum += 1
		if Card.state == InHand:
			Card.setup = true
			Card.state = ReOrganizeHand
			Card.startpos = Card.position
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))
