extends Node3D

@onready var elevator_door: CSGBox3D = $ElevatorFloor/ElevatorDoor
@onready var elevator_floor: StaticBody3D = $ElevatorFloor
@export var  is_bottom_position = false;
@onready var audio_stream_player_init: AudioStreamPlayer3D = $AudioStreamPlayerInit
@onready var audio_stream_player_ending: AudioStreamPlayer3D = $AudioStreamPlayerEnding

const TOP_POSITION = Vector3(0, 1.5, 0);
const BOTTOM_POSITION = Vector3(0, -8.5, 0);

func _ready() -> void:
	elevator_floor.position = BOTTOM_POSITION if is_bottom_position else TOP_POSITION;

func _on_area_3d_body_entered(_body: Node3D) -> void:
	await get_tree().create_timer(1).timeout;
	
	var tween = get_tree().create_tween();
	
	tween.tween_property(
		elevator_door,
		"position:z",
		0,
		0.5
	);
	tween.tween_property(
		elevator_floor,
		"position",
		TOP_POSITION if elevator_floor.position == BOTTOM_POSITION else BOTTOM_POSITION,
		2
	);
	
	audio_stream_player_init.play();
	
	await tween.finished;
	
	audio_stream_player_ending.play();
	tween = get_tree().create_tween();
	tween.tween_property(
		elevator_door,
		"position:z",
		3.3,
		1.5
	);
