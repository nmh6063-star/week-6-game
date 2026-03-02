extends CharacterBody2D

var force = 300
var particles = preload("res://scenes/particles.tscn")
@onready var bound = self.position.y
var grounded = false

#items related to swinging
var position_start = Vector2.ZERO
var position_end = Vector2.ZERO
var vector = Vector2.ZERO

var mode = 1

func _physics_process(delta):
	# get the Physics2DDirectSpaceState object
	var space = get_world_2d().direct_space_state
	# Get the mouse's position
	var mousePos = get_global_mouse_position()
	var local = to_local(mousePos)
	var rect_shape = get_node("Area2D/CollisionShape2D").shape
	var size = rect_shape.size
	var half_size = size/2.0
	var adjusted_pos = local + half_size
	adjusted_pos.x = clamp(adjusted_pos.x, 0, size.x)
	adjusted_pos.y = clamp(adjusted_pos.y, 0, size.y)
	var percent_x = (((adjusted_pos.x / size.x) * 99) + 1 - 50)/100
	var percent_y = (((adjusted_pos.y / size.y) * 99) + 1 - 50)/100
	
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = mousePos
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = true
	# Check if there is a collision at the mouse position
	var intersection = space.intersect_point(parameters)
	if intersection && Input.is_action_just_pressed("click"):
		if mode == 0:
			Global.score += 1
			velocity = Vector2.ZERO
			velocity -= Vector2(force * percent_x, force + force * percent_y)
			self.position.y -= 0.1
			var inst = particles.instantiate()
			inst.position = mousePos
			get_node("/root/Node2D").add_child(inst)
			Global.combo += 1
		else:
			_drag_click(mousePos)
		grounded = false
	elif Input.is_action_pressed("click") && mode == 1:
		#clicked = false
		position_end = mousePos
		vector = clamp(-(position_end - position_start), Vector2.ZERO, Vector2(20.0, 20.0))
		update()
	var sprite = get_node("Computer")
	if self.position.y < bound:
		var gravity = get_gravity()
		if velocity.y > 0:
			gravity *= 2
		velocity += gravity * delta
		move_and_slide()
		sprite.scale.y = remap(abs(velocity.y), 0, force * 1.5, 0.75, 1.0)
		sprite.scale.x = remap(abs(velocity.y), 0, force * 1.5, 1.25, 1.0)
	else:
		if !grounded:
			grounded = true
			sprite.scale.y = remap(abs(velocity.y), 0, abs(1700), 1.2, 2.0)
			sprite.scale.y = remap(abs(velocity.y), 0, abs(1700), 0.8, 0.5)
			for i in range(3):
				var inst = particles.instantiate()
				inst.position.y += 200
				inst.position.x = self.position.x - 100 + (100 * i)
				var particleScript : CPUParticles2D = inst
				particleScript.amount = clamp(abs(velocity.y)/50, 0, 25)
				print(clamp(abs(velocity.y)/50, 0, 25))
				get_node("/root/Node2D").add_child(inst)
		velocity = Vector2.ZERO
		self.position.y = bound
		Global.combo = 0
	
	sprite.scale.x = lerp(sprite.scale.x, 1.0, 1.0 - pow(0.01, delta))
	sprite.scale.y = lerp(sprite.scale.y, 1.0, 1.0 - pow(0.01, delta))
	

func _drag_click(pos):
	position_start = pos
	

func _draw():
	draw_line(position_start - global_position, (position_end - global_position), Color.BLUE, 8)
	draw_line(position_start - global_position, position_start - global_position + vector, Color.RED, 16)
