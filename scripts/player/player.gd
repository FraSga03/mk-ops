extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity = 0.25;

@onready var main_character = %protagonist
@onready var camera: Camera3D = %Camera
@onready var camera_pivot: Node3D = %CameraPivot
@onready var pointer: RayCast3D = %Pointer
@onready var movable_object_marker: Marker3D = %MovableObjectMarker
@onready var sprint_timer: Timer = $SprintTimer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var spring_arm_3d: SpringArm3D = $CameraPivot/SpringArm3D
@onready var domain_animation: AnimationPlayer = $DomainAnimation
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export() var acceleration = 60;
@export() var rotation_speed = 20;

var SPEED_MAP = {
	Globals.MOVEMENT_TYPE.WALK: 5.0,
	Globals.MOVEMENT_TYPE.RUN: 10,
	Globals.MOVEMENT_TYPE.CROUCH: 4.0,
};
var is_camera_motion = false;
var last_movement = Vector3.BACK;
var camera_input_direction = Vector2.ZERO;
var movement_type = Globals.MOVEMENT_TYPE.WALK;
var personal_object = null;
var is_charging = false;
var movement_map = {};
var is_freezed = false;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var height_settings = {
	Globals.MOVEMENT_TYPE.WALK: {
		"height": 1.8,
		"y": 0.875,
		"camera_y": 1.75,
		"spring_length": 1.5
	},
	Globals.MOVEMENT_TYPE.CROUCH: {
		"height": 1.0,
		"y": 0.4,
		"camera_y": 1.3,
		"spring_length": 1.3
	},
}

func _ready():
	movement_map = {
		Globals.MOVEMENT_TYPE.WALK: {
			"idle": main_character.idle,
			"right": main_character.walk_right,
			"left": main_character.walk_left,
			"forward": main_character.walk_forward,
			"backward": main_character.walk_backward,
		},
		Globals.MOVEMENT_TYPE.CROUCH: {
			"idle": main_character.crouch_idle,
			"right": main_character.crouch_right,
			"left": main_character.crouch_left,
			"forward": main_character.crouch_forward,
			"backward": main_character.crouch_backward,
		},
		Globals.MOVEMENT_TYPE.RUN: {
			"idle": main_character.idle,
			"right": main_character.run_right,
			"left": main_character.run_left,
			"forward": main_character.run_forward,
			"backward": main_character.run_backward,
		}
	}

func _input(event: InputEvent) -> void:
	if is_freezed:
		return;
	
	if event is InputEventKey:
		if event.is_action_pressed("scan_objects"):
			domain_animation.play("expand_sphere");
		elif event.is_action_pressed("esc"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		elif Input.is_action_pressed("run"):
			set_posture(Globals.MOVEMENT_TYPE.WALK);
			if Globals.stamina > 0 && !Globals.is_recovering_stamina:
				movement_type = Globals.MOVEMENT_TYPE.RUN;
		elif Input.is_action_just_released("run"):
			movement_type = Globals.MOVEMENT_TYPE.WALK;
		if Input.is_action_just_pressed("crouch"):
			movement_type = Globals.MOVEMENT_TYPE.CROUCH if movement_type == Globals.MOVEMENT_TYPE.WALK else Globals.MOVEMENT_TYPE.WALK;
			if movement_type == Globals.MOVEMENT_TYPE.CROUCH:
				set_posture(Globals.MOVEMENT_TYPE.CROUCH);
				main_character.from_stand_to_crouch();
			else:
				set_posture(Globals.MOVEMENT_TYPE.WALK);
				main_character.from_crouch_to_stand();
		return;
	
	if event is InputEventMouseMotion:
		is_camera_motion = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED;
		if is_camera_motion:
			camera_input_direction = event.screen_relative * mouse_sensitivity;
		return;
	
	if event.is_action_released("left_click") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	elif event.is_action_released("left_click") and personal_object == null:
		pick_object();
	elif event.is_action_released("right_click") and personal_object != null:
		launch_object(true);
	elif event.is_action_pressed("left_click") and personal_object != null:
		is_charging = true;
	elif event.is_action_released("left_click") and personal_object != null and is_charging:
		launch_object();

func _physics_process(delta: float) -> void:
	if is_freezed:
		animate_character("idle");
		return;
	
	position.y -= gravity * delta;
	
	if personal_object:
		personal_object.lockToPosition(movable_object_marker.global_position);
		
	if is_charging:
		Globals.launch_power += delta * 10;
	
	camera_pivot.rotation.x += camera_input_direction.y * delta;
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 6.0, PI / 3.0);
	camera_pivot.rotation.y -= camera_input_direction.x * delta;

	var raw_input = Input.get_vector("left", "right", "forward", "backward");
	var forward = camera.global_basis.z;
	var right = camera.global_basis.x;
	
	var move_direction = (forward * raw_input.y + right * raw_input.x).normalized();
	move_direction.y = 0.0;
	velocity = velocity.move_toward(move_direction * SPEED_MAP[movement_type], acceleration * delta);
	
	update_stamina(movement_type, velocity, delta)
	move_and_slide();
		
	if move_direction.length() > 0.2:
		last_movement = move_direction;
	
	main_character.rotation.y = camera_pivot.rotation.y;
	
	if raw_input != Vector2.ZERO && !audio_stream_player_3d.playing:
		audio_stream_player_3d.play();
	
	var lenght_sqared_input = raw_input.length_squared();
	if lenght_sqared_input > 0 and lenght_sqared_input < 1:
		var is_right = raw_input.x > 0;
		var is_backward = raw_input.y > 0;
		
		if (is_right && !is_backward) || (!is_right && is_backward):
			animate_character("right", is_backward);
		else:
			animate_character("left", is_backward);
	else:
		if raw_input == Vector2.ZERO:
			animate_character("idle");
		elif raw_input == Vector2.UP:
			animate_character("forward");
		elif raw_input == Vector2.RIGHT:
			animate_character("right");
		elif raw_input == Vector2.LEFT:
			animate_character("left");
		elif raw_input == Vector2.DOWN:
			animate_character("backward");
	
	camera_input_direction = Vector2.ZERO;	
	
func animate_character(movement, arg = null):
	var action = movement_map[movement_type][movement];
		
	if arg == null:
		action.call();
	else:
		action.call(arg);	
		
func pick_object():
	var body = pointer.get_collider();	
	if body and body.has_method("lockToPosition"):
		personal_object = body;
		personal_object.disableGravity();
		Globals.launch_power = 0;
	
func launch_object(isDrop = false):
	var difference_dir = pointer.to_global(pointer.target_position) - movable_object_marker.global_position;
	var temp = personal_object;
	personal_object = null;
	is_charging = false;
	
	if isDrop:
		temp.launch(difference_dir.normalized(), 0);
	else:
		temp.launch(difference_dir.normalized(), Globals.launch_power);
	Globals.launch_power = 0;
	
func update_stamina(current_movement_type, c_velocity, delta): 
	if current_movement_type == Globals.MOVEMENT_TYPE.RUN and c_velocity != Vector3.ZERO:
		Globals.stamina = Globals.stamina - 1 * delta;
		
		if Globals.stamina == 0:
			movement_type = Globals.MOVEMENT_TYPE.WALK;
			if !Globals.is_recovering_stamina:
				sprint_timer.start();
				Globals.is_recovering_stamina = true;
	elif Globals.is_recovering_stamina:
		var time_passed = sprint_timer.wait_time - sprint_timer.time_left;
		Globals.stamina = (time_passed * Globals.MAX_STAMINA) / sprint_timer.wait_time;
		
	elif !Globals.is_recovering_stamina && Globals.stamina < Globals.MAX_STAMINA:
		Globals.stamina = Globals.stamina + 1 * delta;
	
func set_posture(posture):	
	var tween = create_tween();
	tween.parallel().tween_property(spring_arm_3d, "spring_length", height_settings[posture]["spring_length"], 0.4);
	tween.parallel().tween_property(camera_pivot, "position:y", height_settings[posture]["camera_y"], 0.2);
	
	collision_shape_3d.shape.height = height_settings[posture]["height"];
	collision_shape_3d.position.y =  height_settings[posture]["y"];			

func move_cam():
	camera.global_position = Vector3.ZERO;

func _on_domain_sphere_body_entered(body: Node3D) -> void:
	if "make_visible" in body:
		body.make_visible();

func _on_sprint_timer_timeout() -> void:
	Globals.is_recovering_stamina = false;
