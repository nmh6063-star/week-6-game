extends Control

@onready var aname : Label = $AchievementName
@onready var atext : Label = $AchievementText

#scorebased achievements
var destination : Vector2
const SPEED = 1000

var rootPos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destination = position
	rootPos = self.position
	
func _physics_process(delta: float) -> void:
	if position.y < destination.y + 1.0 and position.y > destination.y - 1.0:
		position = destination
	else:
		position += position.direction_to(destination) * SPEED * delta
	
func display(num) -> void:
	aname.text = Global.achievements[num][0]
	atext.text = Global.achievements[num][1]
	self.visible = true
	destination = rootPos - Vector2(0, 300)
	await get_tree().create_timer(2).timeout
	destination = rootPos
	await get_tree().create_timer(0.5).timeout
	self.visible = false
