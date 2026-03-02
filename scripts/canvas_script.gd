extends CanvasLayer

@onready var label = get_node("MarginContainer/Label")
@onready var label2 = get_node("MarginContainer2/RichTextLabel")
var size = 16
var sizeVal = float(size)
var lastNum = 0


func _process(delta):
	label.text = str(Global.score)
	if Global.combo > 0:
		label2.text = "[font_size=" + str(sizeVal*2) + "]" + str(Global.combo) + "[/font_size][font_size=" + str(size) + "]hits[/font_size]"
		if lastNum != Global.combo:
			lastNum += 1
			sizeVal = size *  (1.5 + Global.combo/100)
	else:
		label2.text = ""
		lastNum = 0
	sizeVal = lerp(sizeVal, float(size), 5.0 * delta)
