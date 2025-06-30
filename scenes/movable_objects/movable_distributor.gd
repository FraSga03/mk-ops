extends MovableObject

@onready var csg_box_3d: CSGBox3D = $CSGBox3D

func get_shader():
	return csg_box_3d.material_override.next_pass
