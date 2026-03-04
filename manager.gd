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
	elif Global.combo > 999 and Global.achievements[13][2] == false:
		Global.achievements[13][2] = true
		display.display(13)
	if Global.wallBounceCount > 3 and Global.achievements[8][2] == false:
		Global.achievements[8][2] = true
		display.display(8)
	
	if Global.switch > 2 and Global.achievements[9][2] == false:
		Global.achievements[9][2] = true
		display.display(9)
	if Global.switch > 0 and Global.weapon_mode == 3 and Global.achievements[5][2] == false:
		Global.achievements[5][2] = true
		display.display(5)
	
	if Global.unlocked.has(2) and Global.achievements[10][2] == false:
		Global.achievements[10][2] = true
		display.display(10)
	elif Global.unlocked.has(3) and Global.achievements[11][2] == false:
		Global.achievements[11][2] = true
		display.display(11)
	elif Global.unlocked.has(4) and Global.achievements[12][2] == false:
		Global.achievements[12][2] = true
		display.display(12)
	elif Global.unlocked.has(5) and Global.achievements[15][2] == false:
		Global.achievements[15][2] = true
		display.display(15)
		
	if Global.wallBounceCount > 99 and Global.combo < 151 and Global.achievements[14][2] == false:
		Global.achievements[14][2] = true
		display.display(14)
	if Global.combo > 999 and Global.switch > 14 and Global.achievements[16][2] == false:
		Global.achievements[16][2] = true
		display.display(16)
		
