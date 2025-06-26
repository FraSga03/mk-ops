extends MovableObject

@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D

func get_shader():
	return csg_cylinder_3d.material.next_pass
