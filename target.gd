extends Sprite2D

@onready var player = get_node("/root/Node2D/Player")

func _physics_process(delta: float) -> void:
	self.position = get_global_mouse_position()
