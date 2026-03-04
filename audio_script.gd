extends AudioStreamPlayer2D

func _ready():
	if Global.mute:
		self.volume_db = -10000

func _on_finished() -> void:
	queue_free()
