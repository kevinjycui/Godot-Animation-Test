extends CanvasLayer

signal awaken_sahaquiel

func start():
	$HealthBar.start()
	emit_signal("awaken_sahaquiel")
