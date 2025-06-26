extends Node2D

const radius = 20;
const width = 8;

func _draw():
	if Globals.stamina > Globals.MAX_STAMINA - 0.01:
		return;
		
	draw_circle(Vector2.ZERO, radius, Color.html("#3E4C59"), false, width, true);
	
	var end_angle = (2*PI * Globals.stamina) / Globals.MAX_STAMINA;
	
	draw_arc(
		Vector2.ZERO,
		radius, 
		0, 
		end_angle, 
		100, 
		Color.html("#8B1E3F") if Globals.is_recovering_stamina else Color.html("#8B17FF"), 
		width, 
		true
	);
	

func _process(_delta):
	queue_redraw();
