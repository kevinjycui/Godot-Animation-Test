extends Control

@export var start_animation_speed = 100

var started = false

func _ready():
	hide()

func start():
	show()
	started = true

func _process(delta):
	if started:
		$ProgressBar.value += delta * start_animation_speed
