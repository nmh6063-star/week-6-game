extends Node2D
@onready var player = get_node("/root/Node2D/Player")

func _physics_process(delta):
	queue_redraw()

func _draw():
	if player.mode == 1 && player.clicked:
		draw_line(player.position_start, player.position_end, Color.BLUE, 8)
		draw_line(player.position_start, player.position_start + player.vector, Color.RED, 16)
