extends RichTextLabel

@export var type_speed = 20

var lapsed = 0
var started = false

func _ready():
	lapsed = 0
	visible_characters = 0

func _physics_process(delta):
	if not started:
		return
	lapsed += delta * type_speed
	visible_characters = lapsed
