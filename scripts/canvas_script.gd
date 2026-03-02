extends CanvasLayer

@onready var label = get_node("MarginContainer/Label")
@onready var label2 = get_node("MarginContainer2/RichTextLabel")
@onready var label3 = get_node("MarginContainer3/RichTextLabel")

var size = 16
var sizeVal = float(size)
var lastNum = 0

var flavorTextRoot = 16
var flavorText = float(flavorTextRoot)
var modifier = ""


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
		Global.wallBounce = false
		modifier = "Wall Bounce!"
	label3.text = "[font_size=" + str(flavorText) + "]" + modifier + "[/font_size]"
	flavorText = lerp(flavorText, float(flavorTextRoot), 10.0 * delta)
	sizeVal = lerp(sizeVal, float(size), 5.0 * delta)
