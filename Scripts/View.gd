extends Node

@export var lerp_speed = 0.4

@onready var viewports := {
	"main": {
		viewport = $"HBoxContainer/MainViewportContainer/MainViewport",
		cameras = {
			"1": $"HBoxContainer/MainViewportContainer/MainViewport/MainCamera",
			"2": $"HBoxContainer/MainViewportContainer/MainViewport/Main/Eva/Camera",
			"3":  $"HBoxContainer/MainViewportContainer/MainViewport/Main/Shinji/Camera",
			"4":  $"HBoxContainer/MainViewportContainer/MainViewport/Main/Eva/Camera2",
			"5":  $"HBoxContainer/MainViewportContainer/MainViewport/SecondCamera",
			"6":  $"HBoxContainer/MainViewportContainer/MainViewport/IntermediateCamera",
		}
	}
}

@onready var transition_camera = $"HBoxContainer/MainViewportContainer/MainViewport/TransitionCamera"

var lerp_t = 1.0

var current_cam
var target_cam

@export var cam_sequence = ["1", "4", "2", "1", "6", "5"]
@export var timed = [false, true, false, true, true, false]

var index = 0

var started = false

func set_target_cam(cam_num):
	current_cam = target_cam
	target_cam = viewports["main"].cameras[cam_num]
	lerp_t = 0.0

func _ready():
	set_target_cam(cam_sequence[index])
	current_cam = viewports["main"].cameras[cam_sequence[index]]
	index += 1
	transition_camera.global_position = current_cam.global_position
	transition_camera.rotation = current_cam.rotation
	transition_camera.fov = current_cam.fov
	transition_camera.current = true

func _process(delta):
	if not started:
		return
	if target_cam != null:
		lerp_t = min(lerp_t + delta * lerp_speed, 1.0)
		transition_camera.global_position = current_cam.global_position.lerp(target_cam.global_position, lerp_t)
		transition_camera.rotation = current_cam.rotation.lerp(target_cam.rotation, lerp_t)
		transition_camera.fov = lerpf(current_cam.fov, target_cam.fov, lerp_t)
		
		if lerp_t == 1.0 and index < len(cam_sequence) and $CamSwitchTimer.is_stopped():
			if timed[index]:
				$CamSwitchTimer.start()
			else:
				next_cam_in_sequence()

func next_cam_in_sequence():
	set_target_cam(cam_sequence[index])
	index += 1

func _on_cam_switch_timer_timeout():
	next_cam_in_sequence()

func _on_start_timer_timeout():
	started = true
	$"HBoxContainer/MainViewportContainer/MainViewport/Main/Eva".start()
	$"HBoxContainer/MainViewportContainer/MainViewport/Main/Shinji".start()
	$"HBoxContainer/MainViewportContainer/MainViewport/Main/Sahaquiel".start()

func _on_audio_stream_player_finished():
	get_tree().change_scene_to_file("res://Scenes/Main2.tscn")

