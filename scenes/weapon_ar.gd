extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $ARSprite

var mark_texture = preload("res://assets/weapons/fist/mark.png")
var pistol_sound = preload("res://assets/sounds/ak_fire.mp3")
var audio_player: AudioStreamPlayer

const FRAME_COUNT = 19
const FPS = 24.0
const MARK_FADE_TIME = 5.0
const PISTOL_MARK_SCALE = Vector2(0.15, 0.15)

const audio = preload("res://scenes/audio_player.tscn")

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.play("idle")

func _on_animation_finished():
	animated_sprite.play("idle")
	print("huh")

func fire(target_global: Vector2, computer_sprite: Sprite2D) -> void:
	var audio_player = audio.instantiate()
	audio_player.stream = pistol_sound
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	add_child(audio_player)
	animated_sprite.play("fire")
	_spawn_mark(target_global, computer_sprite)
	print("firing")

func _spawn_mark(hit_global: Vector2, computer_sprite: Sprite2D) -> void:
	var mark = Sprite2D.new()
	mark.texture = mark_texture
	mark.scale = PISTOL_MARK_SCALE
	mark.z_index = 1
	var local_pos = computer_sprite.to_local(hit_global)
	mark.position = local_pos
	var scalar = randf_range(PISTOL_MARK_SCALE.x * 0.75, PISTOL_MARK_SCALE.x)
	mark.scale = Vector2(scalar, scalar)
	computer_sprite.add_child(mark)
	var fade_tween = create_tween()
	fade_tween.tween_property(mark, "modulate:a", 0.0, MARK_FADE_TIME)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_callback(mark.queue_free)
