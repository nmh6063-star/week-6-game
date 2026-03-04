extends CPUParticles2D
	
func _ready():
	self.emitting = true
	if !Global.particles:
		queue_free()

func _on_finished() -> void:
	queue_free()
