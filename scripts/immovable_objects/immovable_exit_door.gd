extends StaticBody3D

@onready var door_sound_player: AudioStreamPlayer3D = $DoorSoundPlayer

signal on_door_entered;

var is_door_disabled = false;

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if !is_door_disabled:
		door_sound_player.play();
	
	on_door_entered.emit();
