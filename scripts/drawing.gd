extends Node2D
@onready var player = get_node("/root/Node2D/Player")
var canFreeze = true

func _physics_process(delta):
	queue_redraw()
	if Global.wallBounce and canFreeze:
		_time_freeze()

func _draw():
	if player.mode == 1 && player.clicked:
		draw_line(player.position_start, player.position_end, Color.BLUE, 8)
		draw_line(player.position_start, player.position_start + player.vector, Color.RED, 16)
	
	
func _time_freeze():
	if canFreeze:
		var waitVal
		if Global.wallBounceDir == "U":
			waitVal = abs(player.velocity.y)/11000
		else:
			waitVal = abs(player.velocity.x)/11000
		print("wait")
		print(waitVal)
		canFreeze = false
		Global.frozen = true
		await get_tree().create_timer(waitVal).timeout
		Global.frozen = false
		await get_tree().create_timer(waitVal).timeout
		canFreeze = true
		Global.wallBounce = false
