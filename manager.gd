extends Node2D

var display

var last_weapon = 0

func _ready():
	display = get_node("CanvasLayer/AchievementManager")

func _physics_process(delta):
	if Global.score > 0 and Global.achievements[0][2] == false:
		Global.achievements[0][2] = true
		display.display(0)
	elif Global.score > 1000 and Global.achievements[1][2] == false:
		Global.achievements[1][2] = true
		display.display(1)
	elif Global.score > 9999 and Global.achievements[2][2] == false:
		Global.achievements[2][2] = true
		display.display(2)
	elif Global.score > 99999 and Global.achievements[3][2] == false:
		Global.achievements[3][2] = true
		display.display(3)
	elif Global.score > 999999 and Global.achievements[4][2] == false:
		Global.achievements[4][2] = true
		display.display(4)
		
	if last_weapon != Global.weapon_mode:
		Global.switch += 1
	last_weapon = Global.weapon_mode
	if Global.combo > 49 and Global.achievements[6][2] == false:
		Global.achievements[6][2] = true
		display.display(6)
	if Global.wallBounceCount > 3 and Global.achievements[8][2] == false:
		Global.achievements[8][2] = true
		display.display(8)
	
	if Global.switch > 2 and Global.achievements[9][2] == false:
		Global.achievements[9][2] = true
		display.display(9)
		
