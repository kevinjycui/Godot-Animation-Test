class_name BlendAnimatableCharacter
extends CharacterBody3D

@export var blend_speed = 0.5

var target_animation = 0.0
var current_animation = 0.0
var animation_t = 0.0

var blend_name = "Main"

func lerp_animation(to):
	current_animation = $AnimationTree["parameters/" + blend_name + "/blend_amount"]
	target_animation = to
	animation_t = 0.0

func _process(delta):
	animation_t = min(animation_t + delta * blend_speed, 1.0)
	$AnimationTree["parameters/" + blend_name + "/blend_amount"] = lerpf(current_animation, target_animation, animation_t)
	
