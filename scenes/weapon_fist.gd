extends Node2D

@onready var left_fist: Sprite2D = $LeftFist
@onready var right_fist: Sprite2D = $RightFist

var mark_texture = preload("res://assets/weapons/fist/mark.png")
var punch_sound = preload("res://assets/sounds/punch.mp3")
var audio_player: AudioStreamPlayer
var left_home: Vector2
var right_home: Vector2
var is_left_punching := false
var is_right_punching := false

const PUNCH_SPEED = 0.07
const RETURN_SPEED = 0.25
const MARK_FADE_TIME = 5.0
const MARK_SCALE = Vector2(0.3, 0.3)

const audio = preload("res://scenes/audio_player.tscn")
var current_tween: Tween = null

func _ready():
	left_home = left_fist.position
	right_home = right_fist.position

func punch(target_global: Vector2, computer_sprite: Sprite2D, use_left) -> void:
	if current_tween and current_tween.is_running():
		current_tween.kill()
		current_tween = null
		
		left_fist.position = left_home
		right_fist.position = right_home
		
		is_left_punching = false
		is_right_punching = false

	var audio_player = audio.instantiate()
	audio_player.stream = punch_sound
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	add_child(audio_player)

	var local_target = to_local(target_global)
	#var use_left = target_global.x < global_position.x
	
	var fist: Sprite2D
	var home: Vector2
	
	if use_left:
		fist = left_fist
		home = left_home
		is_left_punching = true
	else:
		fist = right_fist
		home = right_home
		is_right_punching = true
	
	current_tween = create_tween()
	current_tween.tween_property(fist, "position", local_target, PUNCH_SPEED)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	current_tween.tween_callback(func():
		audio_player.play()
		if Global.weapon_mode == 0:
			_spawn_mark(target_global, computer_sprite)
	)
	
	current_tween.tween_property(fist, "position", home, RETURN_SPEED)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	current_tween.tween_callback(func():
		if use_left:
			is_left_punching = false
		else:
			is_right_punching = false
		current_tween = null
	)

func _spawn_mark(hit_global: Vector2, computer_sprite: Sprite2D) -> void:
	var mark = Sprite2D.new()
	mark.texture = mark_texture
	mark.scale = MARK_SCALE
	mark.z_index = 1
	var local_pos = computer_sprite.to_local(hit_global)
	mark.position = local_pos
	var scalar = randf_range(MARK_SCALE.x * 0.75, MARK_SCALE.x)
	mark.scale = Vector2(scalar, scalar)
	computer_sprite.add_child(mark)
	
	var fade_tween = create_tween()
	fade_tween.tween_property(mark, "modulate:a", 0.0, MARK_FADE_TIME)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_callback(mark.queue_free)
