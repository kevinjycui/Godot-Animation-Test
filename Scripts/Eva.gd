extends BlendAnimatableCharacter

@export var speed = 40
@export var angular_speed = 0.005
@export var jump_impulse = 100
@export var fall_acceleration = 200
@export var autoplay = true

var stomp1 = false
var stomp2 = true

@export var controls := {
	move_right = "move_right",
	move_left = "move_left",
	move_forward = "move_forward",
	move_back = "move_back",
	jump = "jump"
}

enum state {RUNNING, JUMP_BEGIN, JUMPING, CRASHING, LANDING}
var current_state = state.RUNNING

var started = false

var particle_fade = false

func _ready():
	$Particles.set_emitting(false)

func start():
	started = true
	$AutoJumpTimer.start()
	$Particles.set_emitting(true)

func trigger_jump():
	$AnimationTree["parameters/JumpTime/seek_request"] = 0.0
	lerp_animation(1.0)
	current_state = state.JUMP_BEGIN
	
func move_forward():
	velocity = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), rotation.y)

func _on_auto_jump_timer_timeout():
	trigger_jump()

func _process(delta):
	if not started:
		return
	
	velocity.x = 0
	velocity.z = 0
	
	if autoplay:
		move_forward()
	elif Input.is_action_pressed(controls.move_forward):
		move_forward()
		if Input.is_action_pressed(controls.move_left):
			rotation.y += angular_speed
		if Input.is_action_pressed(controls.move_right):
			rotation.y -= angular_speed
	
	if current_state == state.RUNNING and not autoplay:
		if Input.is_action_just_pressed(controls.jump):
			trigger_jump()
			
	if $AnimationTree["parameters/Jumping/time"] != null:
		if current_state == state.CRASHING and $AnimationTree["parameters/Jumping/time"] > 3.0:
			lerp_animation(0.0)	
			current_state = state.LANDING
		elif current_state == state.JUMPING and $AnimationTree["parameters/Jumping/time"] > 2.5:
			current_state = state.CRASHING
			$CrashSound.play()
			$StompSound.play()
			$FlySound.position.y += 100
		elif current_state == state.JUMP_BEGIN and $AnimationTree["parameters/Jumping/time"] > 1.6:
			velocity.y = jump_impulse
			current_state = state.JUMPING
			$FlySound.play()
			
	if $AnimationTree["parameters/Running/time"] != null and $AnimationTree["parameters/Main/blend_amount"] < 0.7:
		if $AnimationTree["parameters/Running/time"] < 0.1 and not stomp1:
			stomp1 = true
			stomp2 = false
			$StompSound.play()
		elif $AnimationTree["parameters/Running/time"] > 0.3 and not stomp2:
			stomp1 = false
			stomp2 = true
			$StompSound.play()
		
	var y = velocity.y
	velocity = velocity.normalized() * speed
	velocity.y = y - fall_acceleration * delta
	
	move_and_slide()
	
	super._process(delta)
	if current_state == state.LANDING and animation_t == 1.0:
		current_state = state.RUNNING
		particle_fade = true
	
	if particle_fade:
		$Particles.position.y -= delta * 10
		if $Particles.position.y < -100:
			$Particles.set_emitting(false)
