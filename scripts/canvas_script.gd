extends CanvasLayer

@onready var label = get_node("MarginContainer/Label")
@onready var label2 = get_node("MarginContainer2/RichTextLabel")
@onready var label3 = get_node("MarginContainer3/RichTextLabel")
@onready var achievement = $AchievementManager
@onready var shop_toggle = get_node("Shop Toggle/Button")
@onready var selected = get_node("Shop/Selected")
@onready var shop = get_node("Shop")
@onready var grid = get_node("Shop/GridContainer")
@onready var select_item = get_node("Shop/GridContainer/0")

var size = 16
var sizeVal = float(size)
var lastNum = 0

var flavorTextRoot = 16
var flavorText = float(flavorTextRoot)
var modifier = ""
var children = []

@onready var player = get_node("/root/Node2D/Player")

func _ready():
	shop.visible = false
	shop_toggle.connect("pressed", _shop_toggle)
	children = grid.get_children()
	for child in children:
		var button = child.find_child("Button")
		if button:
			button.connect("pressed", func():self._set_mode(child.name, child))
		if int(child.name) > 1:
			var color = Color.from_hsv(0.0, 0.0, 0.5, 0.5)
			child.modulate = Color(color)
			if button:
				button.disabled = true
	
func _set_mode(mode, select):
	player.mode = int(mode)
	select_item = select

func _shop_toggle():
	shop.visible = !shop.visible
	if shop.visible:
		shop_toggle.text = "\\/"
	else:
		shop_toggle.text = "/\\"

func _process(delta):
	label.text = str(Global.score)
	if Global.combo > 0:
		label2.text = "[font_size=" + str(sizeVal*2) + "]" + str(Global.combo) + "[/font_size][font_size=" + str(sizeVal) + "]hits[/font_size]"
		if lastNum != Global.combo:
			lastNum += 1
			sizeVal = size *  (1.5 + Global.combo/500)
	else:
		label2.text = ""
		lastNum = 0
	if flavorText < flavorTextRoot + 1.0:
		label3.visible = false
	else:
		label3.visible = true
	if Global.wallBounce:
		flavorText = flavorTextRoot*2.0
		modifier = "Wall Bounce!"
	label3.text = "[font_size=" + str(flavorText) + "]" + modifier + "[/font_size]"
	flavorText = lerp(flavorText, float(flavorTextRoot), 30.0 * delta)
	sizeVal = lerp(sizeVal, float(size), 5.0 * delta)
	if Global.score >= achievement.next_score:
		achievement.display()
	selected.position = Vector2(100 + (500 * player.mode), 200)
