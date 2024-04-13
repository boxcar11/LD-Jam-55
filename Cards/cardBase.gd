extends MarginContainer

var Cardname = 'Archer'
@onready var CardInfo = CardDatabase.DATA[CardDatabase.get(Cardname)]
@onready var CardImg = str("res://assets/Cards/",CardInfo[0],"/",Cardname,".png")
var startpos = 0
var targetpos = 0
var startrot = 0
var targetrot = 0
var t = 0
var DRAWTIME = 1
var ORGANIZETIME = 0.5
@onready var Orig_scale = scale.x

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganizeHand
}

var state = InHand

func _ready():
	# print(CardInfo)
	var CardSize = size
	#$Border.scale *= CardSize/$Border.texture.get_size()
	$Bars/CardFace/Image/Img.texture = load(CardImg)
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
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
			pass
		InMouse:
			pass
		FocusInHand:
			pass
		MoveDrawnCardToHand: # Animate from deck to hand
			if t <= 1:
				position = startpos.lerp(targetpos, t)
				rotation_degrees = startrot * (1-t) + targetrot*t
				scale.x = Orig_scale * abs(2*t - 1)
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else:
				position = targetpos
				rotation_degrees = targetrot
				state = InHand
				t = 0
		ReOrganizeHand:
			if t <= 1:
				position = startpos.lerp(targetpos, t)
				rotation_degrees = startrot * (1-t) + targetrot*t
				t += delta/float(ORGANIZETIME)
			else:
				position = targetpos
				rotation_degrees = targetrot
				state = InHand
				t = 0
