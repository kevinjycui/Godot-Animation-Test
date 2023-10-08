extends Control

@export var start_animation_speed = 300

var started = false

func _ready():
	$ProgressBar.value = 1000
	hide()

func start():
	show()
	started = true

func _process(delta):
	$Value.text = str($ProgressBar.value)
	if started:
		$ProgressBar.value += delta * start_animation_speed
