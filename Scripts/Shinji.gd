extends BlendAnimatableCharacter

var start_fall = false

var started = false

func start():
	started = true
	$AutoDeathTimer.start()

func _process(delta):
	if not started:
		return
	super._process(delta)
	if start_fall:
		$AnimationTree["parameters/Sub/blend_amount"] = lerpf(0.0, 1.0, animation_t)

func _on_auto_death_timer_timeout():
	lerp_animation(1.0)
	start_fall = true
