extends Level

@onready var enemy_path: PathFollow3D = $Environment/RoomA/Enemies/Path3D/EnemyPath
@onready var enemy_path_1: PathFollow3D = $Environment/RoomA/Enemies/Path3D2/EnemyPath
@onready var enemy_path_2: PathFollow3D = $Environment/RoomB/Enemies/Path3D/EnemyPath
@onready var enemy_path_3: PathFollow3D = $Environment/RoomC/Enemies/Path3D/EnemyPath
@onready var enemy_path_4: PathFollow3D = $Environment/RoomD/Enemies/Path3D/EnemyPath
@onready var exit_area_control: Area3D = $Environment/RoomD/ExitAreaControl
@onready var progress_bar: CSGBox3D = $Environment/RoomD/ExitAreaControl/ProgressBar

var dialogues = {
	"default": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("2_1K_1"), tr("2_1K_2"), tr("2_1K_3")],
			[tr("2_1K_4")],
		],
		"dialogue_count": 0
	},
	"floor_1_a": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("2_1A_1")],
			[tr("2_1A_2")],
		],
		"dialogue_count": 0
	},
	"floor_1_b": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("2_1B_1")],
			[tr("2_1B_2")],
		],
		"dialogue_count": 0
	},
	"floor_1_c": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("2_1C_1"), tr("2_1C_2")],
			[tr("2_1C_3"), tr("2_1C_4")],
		],
		"dialogue_count": 0
	},	
	"floor_1_d": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("2_1D_1"), tr("2_1D_2")],
			[tr("2_1D_3"), tr("2_1D_4")],
		],
		"dialogue_count": 0
	},
}

func _init():
	super._init(tr("level_2"), dialogues)
	
func _on_immovable_exit_door_on_door_entered() -> void:
	if get_bodies_in_control_area().size() != 3:
		return;
	
	Globals.next_scene_info = {
		"current_level_key": "level_2",
		"next_scene": "res://scenes/levels/level_3.tscn",
		"new_time":  Time.get_unix_time_from_system() - Globals.time_pivot
	}
	
	Globals.save_time("level_2");
	Transition.change_scene("res://scenes/ui/level_completed.tscn");

func set_enemy_path():
	enemy_path.checkpoints = [
		{ "progress": 0.2, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.52, "has_passed": false, "turn_range": 1.5 },
		{ "progress": 0.91, "has_passed": false, "turn_range": 1.1 },
	];
	
	enemy_path_1.checkpoints = [
		{ "progress": 0.22, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.64, "has_passed": false, "turn_range": 1.5 },
	];
	
	enemy_path_2.checkpoints = [
		{ "progress": 0.15, "has_passed": false, "turn_range": 1.5 },
		{ "progress": 0.62, "has_passed": false, "turn_range": 1.4 },
	];
	
	enemy_path_3.checkpoints = [
		{ "progress": 0.18, "has_passed": false, "turn_range": 1.5 },
		{ "progress": 0.49, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.71, "has_passed": false, "turn_range": 1.5 },
		{ "progress": 0.94, "has_passed": false, "turn_range": 1.4 },
	];
	
	enemy_path_4.checkpoints = [
		{ "progress": 0.4, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.63, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.96, "has_passed": false, "turn_range": 1.4 },
	];

func _on_area_f1a_entered(body: Node3D) -> void:
	dialogue_key = "floor_1_a";

func _on_area_f1b_entered(body: Node3D) -> void:
	dialogue_key = "floor_1_b";
	
func _on_area_f1c_entered(body: Node3D) -> void:
	dialogue_key = "floor_1_c";

func _on_area_f1d_entered(body: Node3D) -> void:
	dialogue_key = "floor_1_d";

func update_progress_bar_color(body: Node3D) -> void:
	var bodies = get_bodies_in_control_area();
	
	if bodies.size() == 0:
		progress_bar.material.albedo_color= Color.RED;
	elif bodies.size() == 1:
		progress_bar.material.albedo_color= Color.ORANGE_RED;
	elif bodies.size() == 2:
		progress_bar.material.albedo_color= Color.ORANGE;
	elif bodies.size() == 3:
		progress_bar.material.albedo_color= Color.GREEN

func get_bodies_in_control_area():
	var bodies = exit_area_control.get_overlapping_bodies();
	return bodies.filter(func (el): el.is_in_group("Warehouse"));
