extends Node2D

@onready var aname : Label = $AchievementName
@onready var atext : Label = $AchievementText

var names = ["I give it a 10", "Taking no Ls", "Aced the exam", "Happy anniversary",
"A new millenium"]
var scores = [10, 50, 100, 365, 1000]
var next_score : int
var destination : Vector2
const SPEED = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_score = scores[0]
	destination = position
	aname.text = names.pop_front()
	atext.text = "Reach a score of " + str(scores.pop_front())
	
func _process(delta: float) -> void:
	position += position.direction_to(destination) * SPEED * delta
	
func display() -> void:
	next_score = scores[0]
	destination = position - Vector2(0, 300)
	await get_tree().create_timer(2).timeout
	destination = position + Vector2(0, 300)
	await get_tree().create_timer(0.5).timeout
	aname.text = names.pop_front()
	atext.text = "Reach a score of " + str(scores.pop_front())
	if scores.is_empty():
		scores.append(next_score * 10)
		names.append(str(next_score) + "!")
	pass
