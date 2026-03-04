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

func _ready():
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = punch_sound
	add_child(audio_player)
	left_home = left_fist.position
	right_home = right_fist.position

func punch(target_global: Vector2, computer_sprite: Sprite2D) -> void:
	var local_target = to_local(target_global)
	var use_left = target_global.x < global_position.x
	
	if use_left and is_left_punching:
		return
	if !use_left and is_right_punching:
		return
	
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
	
	var tween = create_tween()
	tween.tween_property(fist, "position", local_target, PUNCH_SPEED)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func():
		audio_player.play()
		_spawn_mark(target_global, computer_sprite)
	)
	tween.tween_property(fist, "position", home, RETURN_SPEED)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func():
		if use_left:
			is_left_punching = false
		else:
			is_right_punching = false
	)

func _spawn_mark(hit_global: Vector2, computer_sprite: Sprite2D) -> void:
	var mark = Sprite2D.new()
	mark.texture = mark_texture
	mark.scale = MARK_SCALE
	mark.z_index = 1
	var local_pos = computer_sprite.to_local(hit_global)
	mark.position = local_pos
	computer_sprite.add_child(mark)
	
	var fade_tween = create_tween()
	fade_tween.tween_property(mark, "modulate:a", 0.0, MARK_FADE_TIME)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_callback(mark.queue_free)
