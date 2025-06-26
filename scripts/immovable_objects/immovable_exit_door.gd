extends StaticBody3D

signal on_door_entered;

func _on_area_3d_body_entered(_body: Node3D) -> void:
	on_door_entered.emit();
