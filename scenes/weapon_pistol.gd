extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $PistolSprite

var mark_texture = preload("res://assets/weapons/fist/mark.png")
var pistol_sound = preload("res://assets/sounds/Pistol.mp3")
var audio_player: AudioStreamPlayer

const FRAME_COUNT = 19
const FPS = 24.0
const MARK_FADE_TIME = 5.0
const PISTOL_MARK_SCALE = Vector2(0.15, 0.15)

func _ready():
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = pistol_sound
	add_child(audio_player)
	var frames = SpriteFrames.new()
	frames.add_animation("fire")
	frames.add_animation("idle")
	var frame_duration = 1.0 / FPS
	for i in range(FRAME_COUNT):
		var path = "res://assets/weapons/pistol/pistol/d11317d6-9951-4b92-a46f-f6f97d1134f4-%d.png" % i
		var tex = load(path) as Texture2D
		if tex:
			frames.add_frame("fire", tex, frame_duration)
			if i == 0:
				frames.add_frame("idle", tex, 1.0)
	frames.set_animation_loop("fire", false)
	animated_sprite.sprite_frames = frames
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.play("idle")

func _on_animation_finished():
	animated_sprite.play("idle")

func fire(target_global: Vector2, computer_sprite: Sprite2D) -> void:
	audio_player.play()
	animated_sprite.play("fire")
	_spawn_mark(target_global, computer_sprite)

func _spawn_mark(hit_global: Vector2, computer_sprite: Sprite2D) -> void:
	var mark = Sprite2D.new()
	mark.texture = mark_texture
	mark.scale = PISTOL_MARK_SCALE
	mark.z_index = 1
	var local_pos = computer_sprite.to_local(hit_global)
	mark.position = local_pos
	computer_sprite.add_child(mark)
	var fade_tween = create_tween()
	fade_tween.tween_property(mark, "modulate:a", 0.0, MARK_FADE_TIME)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_callback(mark.queue_free)
