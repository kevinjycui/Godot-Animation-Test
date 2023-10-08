extends Control

func _ready():
	hide()

func _on_show_timeout():
	show()
	$HideTimer.start()

func _on_hide_timeout():
	hide()
