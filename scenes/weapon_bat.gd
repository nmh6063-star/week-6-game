extends Node2D

@onready var bat_sprite: Sprite2D = $BatSprite

var mark_texture = preload("res://assets/weapons/fist/mark.png")
var home_pos: Vector2
var home_rotation: float = 0.0

const SWING_ANGLE = -80.0
const SWING_SPEED = 0.06
const RETURN_SPEED = 0.2
const MARK_FADE_TIME = 5.0
const BAT_MARK_SCALE = Vector2(0.3, 0.7)

func _ready():
	home_pos = bat_sprite.position

func swing(target_global: Vector2, computer_sprite: Sprite2D) -> void:
	var local_target = to_local(target_global)
	var tween = create_tween()
	tween.tween_property(bat_sprite, "position", local_target, SWING_SPEED)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(bat_sprite, "rotation", deg_to_rad(SWING_ANGLE), SWING_SPEED)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(_spawn_mark.bind(target_global, computer_sprite))
	tween.tween_property(bat_sprite, "position", home_pos, RETURN_SPEED)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(bat_sprite, "rotation", home_rotation, RETURN_SPEED)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func _spawn_mark(hit_global: Vector2, computer_sprite: Sprite2D) -> void:
	var mark = Sprite2D.new()
	mark.texture = mark_texture
	mark.scale = BAT_MARK_SCALE
	mark.z_index = 1
	var local_pos = computer_sprite.to_local(hit_global)
	mark.position = local_pos
	computer_sprite.add_child(mark)
	var fade_tween = create_tween()
	fade_tween.tween_property(mark, "modulate:a", 0.0, MARK_FADE_TIME)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_callback(mark.queue_free)
