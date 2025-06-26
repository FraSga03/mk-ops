extends CharacterBody3D

@onready var stun_timer: Timer = $StunTimer
@onready var enemy_body: Node3D = $EnemyBody
@onready var particles: Node3D = $Particles
@onready var player_pointer: RayCast3D = $PlayerPointer
@onready var exclamation_mark: CSGCombiner3D = $ExclamationMark
@onready var camera_pivot: Node3D = $CameraPivot
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var detection_timer: Timer = $DetectionTimer
@onready var hit_sound_player: AudioStreamPlayer3D = $HitSoundPlayer

signal on_enemy_death;
signal on_player_detect;

var tween = null;

var detected_player = null;
var is_inspecting = false;
var is_stunned = false;
var is_player_detected = false;
var is_player_noticed = false;
var previous_rotation = null;

const ROTATION_SPEED = 10;

func _physics_process(delta: float) -> void:	
	if tween != null and !tween.is_running():
		is_inspecting = false;
			
	if is_stunned:
		particles.rotation.y += ROTATION_SPEED / delta;
		return;
		
	if detected_player != null:
		player_pointer.look_at(detected_player.global_position + Vector3(0, 0.8, 0));

		if player_pointer.is_colliding() and player_pointer.get_collider() is Node:	
			var node_collided = player_pointer.get_collider() as Node;
			if node_collided.is_in_group("Player"):
				audio_stream_player_3d.stop();
				is_player_detected = true;
				on_detect_player();

func on_detect_player():
	show_exlamation_mark();
	enemy_body.aiming();
	look_at(detected_player.global_position);
	on_player_detect.emit();

func manage_hit(force, delta):	
	if !stun_timer.is_stopped():
		return;
		
	hit_sound_player.play();
	is_stunned = true;
	stun_timer.start();
	enemy_body.idle();
	stun_animation(true);
	
	if tween != null:
		tween.stop();
		tween = null;

func stun_animation(val):
	particles.visible = true;
	for child in particles.get_children():
		child.emitting = val;

func _on_detection_area_body_entered(body: Node3D) -> void:
	if is_player_noticed or is_stunned or body.movement_type == Globals.MOVEMENT_TYPE.CROUCH:
		return;
	
	is_player_noticed = true;
	if previous_rotation == null:
		previous_rotation = rotation;
		
	stop_and_remove_tween();
	is_inspecting = false;
	show_exlamation_mark(Color.YELLOW);
	
	var tween_detection = create_tween();
	enemy_body.idle();

	var dir = (body.global_position - global_position)
	dir.y = 0;
	dir = dir.normalized();
	var current_yaw = rotation.y;
	var target_yaw = atan2(dir.x, dir.z) - PI;
	var shortest_yaw = current_yaw + wrapf(target_yaw - current_yaw, -PI, PI)

	# Tween rotation.y (yaw) only
	tween_detection.tween_property(
		self,
		"global_rotation:y",
		target_yaw,
		2.0
	)
	await tween_detection.finished;
	
	detection_timer.start();
		
func rotate_by_range(rotation_range):
	is_inspecting = true;
	previous_rotation = rotation;
	tween = get_tree().create_tween();
	enemy_body.aiming();
	tween.chain().tween_property(
		self,
		"rotation",
		Vector3(previous_rotation.x, previous_rotation.y + rotation_range, previous_rotation.z), 
		1.5
	);
	tween.chain().tween_property(
		self,
		"rotation", 
		Vector3(previous_rotation.x, previous_rotation.y - rotation_range, previous_rotation.z),
		2.5
	);
	tween.chain().tween_property(self, "rotation", previous_rotation, 1);
	
func _on_stun_timer_timeout() -> void:
	is_stunned = false;
	particles.visible = false;

func _on_game_over_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		detected_player = body;

func _on_game_over_area_body_exited(_body: Node3D) -> void:
	detected_player = null;

func make_visible():
	enemy_body.make_visible();
	
func stop_and_remove_tween():
	if tween != null:
		tween.stop();
	tween = null;

func is_enemy_stopped():
	return is_inspecting or is_player_detected or is_stunned or is_player_noticed;

func _on_detection_timer_timeout() -> void:	
	var tween_detection = create_tween();
	tween_detection.tween_property(
		self,
		"rotation",
		Vector3(previous_rotation.x, previous_rotation.y, rotation.z), 
		2
	);
	
	await tween_detection.finished;
	
	is_player_noticed = false;
	exclamation_mark.visible = false;
	previous_rotation = null;
	
func show_exlamation_mark(color: Color = Color.RED):
	exclamation_mark.material_override.albedo_color = color;
	exclamation_mark.visible = true;
