extends Node2D

const CardSize = Vector2(150,200)*0.6
const CardBase = preload("res://Cards/cardBase.tscn")
const PlayerHand = preload("res://Cards/PlayerHand.gd")
const CardSlot = preload("res://Cards/card_slot.tscn")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()

@onready var CenterCardOval = get_viewport_rect().size * Vector2(0.4, 1.42)
@onready var Hor_Rad = get_viewport().size.x*0.45
@onready var Ver_Rad = get_viewport().size.y*0.4
@onready var DeckPosition = $Deck.position
@onready var DiscardPosition = $Discard.position
var angle = 0
var CardSpread = 0.002*CardSize.x
var NumberCardsHand = -1
var CardNum = 0
var OvalAngleVector = Vector2()

var cardSlotEmpty = []
var numberColumns = 1
var numberRows = 5
var CardSlots = numberColumns*numberRows
@onready var ViewPortSize = get_viewport().size
@onready var OuterxMargin = ViewPortSize.x/25
@onready var OuteryMargin = ViewPortSize.y/25
@onready var MiddlexMargin = ViewPortSize.x/10
@onready var CardZoneHeight = ViewPortSize.y - (CenterCardOval.y - CardSize.y - Ver_Rad)# max height of card zone
@onready var CardSlotyGaps = ViewPortSize.y/40
@onready var CardSlotxGaps = ViewPortSize.x/40
@onready var CardSlotBaseWidth =  ViewPortSize.x/10
@onready var CardSlotTotalHeight = ViewPortSize.y - OuteryMargin - CardZoneHeight
@onready var CardSlotTotalWidth = ViewPortSize.x/2 - OuterxMargin - MiddlexMargin/2 - CardSlotBaseWidth  ##### only for one side
@onready var HeightforCard = (CardSlotTotalHeight - (numberRows - 1)*CardSlotyGaps)/numberRows
@onready var WidthforCard = (CardSlotTotalWidth - (numberColumns - 1)*CardSlotxGaps)/numberColumns

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
	for j in range(numberColumns):
		for k in range(numberRows):
			var NewSlot = CardSlot.instantiate()
			NewSlot.size = CardSize
			NewSlot.position = Vector2(OuterxMargin + CardSlotBaseWidth,OuteryMargin) + k*Vector2(0,HeightforCard + CardSlotyGaps) + j*Vector2(CardSlotTotalWidth/numberColumns,0)
			NewSlot.scale *= (HeightforCard)/NewSlot.size.y
			$CardSlots.add_child(NewSlot)
			cardSlotEmpty.append(true)
	# $Enemies/Enemy.visible = true
	# $Enemies/Enemy.position = get_viewport().size*0.4 + Vector2(200,0)
	# $Enemies/Enemy.scale *= 0.3
	# var NewSlot = CardSlot.instantiate()
	# NewSlot.position = get_viewport().size*0.4
	# NewSlot.size = CardSize
	# $CardSlots.add_child(NewSlot)
	# cardSlotEmpty.append(true)

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
		Card.targetpos = CenterCardOval + OvalAngleVector - Vector2(0, CardSize.y)
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
			Card.t -= 0.1
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))
