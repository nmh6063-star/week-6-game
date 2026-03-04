extends CharacterBody2D

var force = 300
var particles = preload("res://scenes/particles.tscn")
@onready var bound = self.position.y
var grounded = false
var clicked = false

#items related to swinging
var position_start = Vector2.ZERO
var position_end = Vector2.ZERO
var vector = Vector2.ZERO

var mode = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("weapon_fist"):
		Global.weapon_mode = 0
	if Input.is_action_just_pressed("weapon_bat"):
		Global.weapon_mode = 1
	if Input.is_action_just_pressed("weapon_pistol"):
		Global.weapon_mode = 2
	var weapon_fist = get_node_or_null("/root/Node2D/WeaponFist")
	var weapon_bat = get_node_or_null("/root/Node2D/WeaponBat")
	var weapon_pistol = get_node_or_null("/root/Node2D/WeaponPistol")
	if weapon_fist:
		weapon_fist.visible = Global.weapon_mode == 0
	if weapon_bat:
		weapon_bat.visible = Global.weapon_mode == 1
	if weapon_pistol:
		weapon_pistol.visible = Global.weapon_mode == 2

	# get the Physics2DDirectSpaceState object
	var space = get_world_2d().direct_space_state
	# Get the mouse's position
	var mousePos = get_global_mouse_position()
	var local = to_local(mousePos)
	var rect_shape = get_node("Area2D/CollisionShape2D").shape
	var size = rect_shape.size
	var half_size = size/2.0
	var adjusted_pos = local + half_size + Vector2(0, 287)
	adjusted_pos.x = clamp(adjusted_pos.x, 0, size.x)
	adjusted_pos.y = clamp(adjusted_pos.y, 0, size.y)
	var percent_x = (((adjusted_pos.x / size.x) * 99) + 1 - 50)/100
	var percent_y = (((adjusted_pos.y / size.y) * 99) + 1 - 50)/100
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = mousePos
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	# Check if there is a collision at the mouse position
	var intersection = space.intersect_point(parameters)
	if intersection && Input.is_action_just_pressed("click"):
		clicked = true
		if mode == 0:
			Global.score += 1
			velocity = Vector2.ZERO
			velocity -= Vector2(force * percent_x, force + force * percent_y)
			var computer = get_node("Computer")
			if Global.weapon_mode == 0:
				var weapon = get_node_or_null("/root/Node2D/WeaponFist")
				if weapon:
					weapon.punch(mousePos, computer)
			elif Global.weapon_mode == 1:
				var weapon = get_node_or_null("/root/Node2D/WeaponBat")
				if weapon:
					weapon.swing(mousePos, computer)
			elif Global.weapon_mode == 2:
				var weapon = get_node_or_null("/root/Node2D/WeaponPistol")
				if weapon:
					weapon.fire(mousePos, computer)
			var inst = particles.instantiate()
			inst.position = mousePos
			get_node("/root/Node2D").add_child(inst)
			self.position.y -= 0.1
			Global.combo += 1
		else:
			_drag_click(mousePos)
		grounded = false
	elif Input.is_action_pressed("click") && mode == 1 && clicked:
		position_end = mousePos
		vector = -(position_end - position_start).limit_length(200)
	var sprite = get_node("Computer")
	if Input.is_action_just_released("click") && clicked && mode == 1:
		clicked = false
		position_start = Vector2.ZERO
		position_end = Vector2.ZERO
		self.position.y -= 0.1
		velocity = Vector2.ZERO
		velocity -= Vector2(-vector.x * force / 40, -vector.y * force / 40)
		grounded = false
	if self.position.y < bound:
		var gravity = get_gravity()
		if velocity.y > 0:
			gravity *= 2
		velocity += gravity * delta
		if not Global.frozen:
			var collision = move_and_collide(velocity*delta)
			if velocity.length() > 0.01:
				var target_angle = velocity.angle() + deg_to_rad(90)
				rotation = clamp(lerp_angle(rotation, target_angle, 1.0 * delta), -PI/4, PI/4)
			if collision and collision.get_collider().name.contains("Border"):
				var collision_normal = collision.get_normal()
				if collision_normal.y > 0.5:
					velocity.y *= -0.75
					Global.combo += 1
					Global.score += 1
					get_viewport().get_camera_2d().shake(abs(velocity.y)/1000)
					Global.wallBounceDir = "U"
					for i in range(3):
						var inst = particles.instantiate()
						inst.position = collision.get_position()
						inst.position.x = inst.position.x - 100 + (100 * i)
						var particleScript : CPUParticles2D = inst
						particleScript.amount = clamp(abs(velocity.y)/50, 0, 25)
						get_node("/root/Node2D").add_child(inst)
				elif collision_normal.y < -0.5:
					pass
					#print("Hit from above / Ceiling")
				elif collision_normal.x > 0.5:
					velocity.x *= -0.9
					Global.combo += 1
					Global.score += 1
					get_viewport().get_camera_2d().shake(abs(velocity.x)/1000)
					print("left")
					print(abs(velocity.x)/1000)
					Global.wallBounceDir = "L"
					for i in range(3):
						var inst = particles.instantiate()
						inst.position = collision.get_position()
						inst.position.x = inst.position.x - 100 + (100 * i)
						var particleScript : CPUParticles2D = inst
						particleScript.amount = clamp(abs(velocity.x)/50, 0, 25)
						get_node("/root/Node2D").add_child(inst)
				elif collision_normal.x < -0.5:
					velocity.x *= -0.9
					Global.combo += 1
					Global.score += 1
					print("right")
					print(velocity.x)
					get_viewport().get_camera_2d().shake(abs(velocity.x)/1000)
					for i in range(3):
						var inst = particles.instantiate()
						inst.position = collision.get_position()
						inst.position.x = inst.position.x - 100 + (100 * i)
						var particleScript : CPUParticles2D = inst
						particleScript.amount = clamp(abs(velocity.x)/50, 0, 25)
						get_node("/root/Node2D").add_child(inst)
					Global.wallBounceDir = "R"
				Global.wallBounce = true
				sprite.scale.y = remap(abs(velocity.x), 0, force * 1.5, 1, 1.1)
				sprite.scale.x = remap(abs(velocity.y), 0, force * 1.5, 1.1, 1)
			else:
				sprite.scale.y = remap(abs(velocity.y), 0, force * 1.5, 1, 1.1)
				sprite.scale.x = remap(abs(velocity.y), 0, force * 1.5, 1.1, 1)
	else:
		if !grounded:
			get_viewport().get_camera_2d().shake(velocity.y/2000)
			grounded = true
			sprite.scale.y = remap(abs(velocity.y), 0, abs(1700), 1.05, 1.85)
			sprite.scale.y = remap(abs(velocity.y), 0, abs(1700), 0.95, 0.7)
			for i in range(3):
				var inst = particles.instantiate()
				inst.position.y += 200
				inst.position.x = self.position.x - 100 + (100 * i)
				var particleScript : CPUParticles2D = inst
				particleScript.amount = clamp(abs(velocity.y)/50, 0, 25)
				get_node("/root/Node2D").add_child(inst)
		velocity = Vector2.ZERO
		self.position.y = bound
		Global.combo = 0
		rotation = lerp_angle(rotation, 0, 10.0 * delta)
	
	sprite.scale.x = lerp(sprite.scale.x, 1.0, 1.0 - pow(0.01, delta))
	sprite.scale.y = lerp(sprite.scale.y, 1.0, 1.0 - pow(0.01, delta))
	

func _drag_click(pos):
	position_start = pos
