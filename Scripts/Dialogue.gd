extends Panel

@export var speaker = [
	"",
	"COMMANDER KATSURAGI MISATO: "
]

@export var dialogue = [
	"Angel approaching! Approximate distance: 20000!",
	"Very well. Commence operation."
]

var index = 0

func next_line():
	$Label.visible_characters = 0
	$Label.text = speaker[index] + dialogue[index]
	$Label.lapsed = len(speaker[index])
	index += 1	

func _ready():
	$Label.started = true
	next_line()

func _process(delta):
	if $Label.visible_ratio >= 1.1 and index < len(dialogue):
		next_line()

func _on_hide_timer_timeout():
	hide()
