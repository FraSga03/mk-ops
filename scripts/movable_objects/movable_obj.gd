extends RigidBody3D
class_name MovableObject

@onready var launch_sound_player: AudioStreamPlayer3D = $LaunchSoundPlayer

const MIN_THROW_FORCE = 4;
var life = 500;

func lockToPosition(newPosition):	
	var tween = get_tree().create_tween();
	tween.tween_property(self, "global_position", newPosition, 0.25);
	
func disableGravity():	
	gravity_scale = 0;

func launch(force, power):
	launch_sound_player.play();
	var currentForce = max(power, 0);
	apply_central_impulse(force * currentForce * MIN_THROW_FORCE);
	gravity_scale = 1;

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		body.manage_hit(abs(linear_velocity.length()), 50);
		
func get_shader() -> Shader:
	return null;
		
func make_visible() -> void:
	var shader = get_shader();
	shader.set_shader_parameter("effect_enabled", true);
	await get_tree().create_timer(8).timeout;
	shader.set_shader_parameter("effect_enabled", false);
