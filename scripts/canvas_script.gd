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
@onready var achievo = get_node("Achievo/Button")
@onready var achievements = get_node("Achievements")

const audio = preload("res://scenes/audio_player.tscn")
var error = preload("res://assets/sounds/error.wav")
var cash = preload("res://assets/sounds/cash.wav")
var select = preload("res://assets/sounds/select.wav")
var achieve = preload("res://scenes/achieve.tscn")

var size = 16
var sizeVal = float(size)
var lastNum = 0

var flavorTextRoot = 16
var flavorText = float(flavorTextRoot)
var modifier = ""
var children = []

@onready var player = get_node("/root/Node2D/Player")

func _ready():
	achievo.connect("pressed", _achievo_toggle)
	achievements.visible = false
	var base = get_node("Achievements/ScrollContainer/GridContainer")
	for a in Global.achievements:
		var inst = achieve.instantiate()
		inst.find_child("Title").text = Global.achievements[a][0]
		inst.find_child("Desc").text = Global.achievements[a][1]
		inst.name = str(a)
		base.add_child(inst)
		
	shop.visible = false
	shop_toggle.connect("pressed", _shop_toggle)
	children = grid.get_children()
	for child in children:
		var button = child.find_child("Button")
		var cost = child.find_child("Cost")
		if button:
			button.connect("pressed", func():self._set_mode(child.name, child))
		if int(child.name) > 1:
			var color = Color.from_hsv(0.0, 0.0, 0.5, 0.5)
			var rect = child.find_child("TextureRect")
			if rect:
				rect.modulate = Color(color)
			if button:
				button.disabled = true
			if cost:
				cost.text = str(int(pow(10, int(child.name)) + 500))
				cost.connect("pressed", func(): self._pricing(child.name, pow(10, int(child.name)) + 500, cost, button, rect))
				
				

func _achievo_toggle():
	achievements.visible = !achievements.visible
	player.operate = !player.operate
	if achievements.visible:
		var base = get_node("Achievements/ScrollContainer/GridContainer")
		var children = base.get_children()
		for c in children:
			if Global.achievements[int(c.name)][2] == false:
				c.modulate = Color(0.5, 0.5, 0.5, 1.0)
			else:
				c.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _set_mode(mode, select):
	Global.weapon_mode = int(mode)
	select_item = select
	var audio_player = audio.instantiate()
	audio_player.stream = select
	add_child(audio_player)
	

func _pricing(mode, cost, obj, button, rect):
	if cost <= Global.score:
		Global.score -= cost
		button.disabled = false
		rect.modulate = Color.from_hsv(0.0, 0.0, 1.0, 1.0)
		Global.unlocked.append(int(mode))
		var audio_player = audio.instantiate()
		audio_player.stream = cash
		add_child(audio_player)
		obj.queue_free()
	else:
		var audio_player = audio.instantiate()
		audio_player.stream = error
		add_child(audio_player)

func _shop_toggle():
	shop.visible = !shop.visible
	player.operate = !player.operate
	if shop.visible:
		shop_toggle.text = "\\/"
	else:
		shop_toggle.text = "/\\"
	children = grid.get_children()
				

func _process(delta):
	if achievements.visible:
		shop_toggle.visible = false
		shop_toggle.disabled = true
	else:
		shop_toggle.visible = true
		shop_toggle.disabled = false
	if shop.visible:
		achievo.visible = false
		achievo.disabled = true
	else:
		achievo.visible = true
		achievo.disabled = false
	label.text = str(int(Global.score))
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
	label3.text = "[font_size=" + str(flavorText) + "]" + modifier + " x" + str(Global.wallBounceCount) + "[/font_size]"
	flavorText = lerp(flavorText, float(flavorTextRoot), 15.0 * delta)
	sizeVal = lerp(sizeVal, float(size), 5.0 * delta)
	selected.position = Vector2(100 + (500 * Global.weapon_mode), 200)
