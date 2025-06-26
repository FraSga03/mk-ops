extends MovableObject

@onready var csg_combiner_3d: CSGCombiner3D = $CSGCombiner3D

func get_shader():
	return csg_combiner_3d.material.next_pass
