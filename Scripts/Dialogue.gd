extends Panel

@export var speaker = [
	"",
	""
]

@export var dialogue = [
	"Angel approaching! Approximate distance: 20000!",
	"Very well. Commence operation."
]

var index = 0

func next_line():
	$Label.text = "[center]" + speaker[index] + dialogue[index] + "[/center]"
	index += 1	

func _ready():
	next_line()

func _process(delta):
	if $Label.visible_ratio >= 1.1 and index < len(dialogue):
		next_line()

func _on_hide_timer_timeout():
	hide()

func _on_dialogue_timer_timeout():
	if index >= len(dialogue):
		$DialogueTimer.stop()
	else:
		next_line()
