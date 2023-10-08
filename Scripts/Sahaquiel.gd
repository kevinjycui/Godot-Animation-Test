extends CharacterBody3D

var started = false

func start():
	started = true
	velocity.z = -5

func _process(delta):
	if not started:
		return
	move_and_slide()

func play_noise():
	$Noise.play()
