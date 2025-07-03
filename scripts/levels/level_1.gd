extends Level

@onready var enemy_path_1: PathFollow3D = $Environment/Floor1/Enemies/Path3D2/EnemyPath1
@onready var enemy_path_2: PathFollow3D = $Environment/Floor1/Enemies/Path3D3/EnemyPath2
@onready var enemy_path_3: PathFollow3D = $Environment/Floor1/Enemies/Path3D/EnemyPath3
@onready var enemy_path_4: PathFollow3D = $Environment/Floor2/Enemies/Path3D/EnemyPath4
@onready var enemy_path_5: PathFollow3D = $Environment/Floor2/Enemies/Path3D2/EnemyPath5

var dialogues = {
	"init": {
		"character_name_text": tr("major"),
		"dialogues": [
			[
				tr("1_INIT_1"),
				tr("1_INIT_2"),
				tr("1_INIT_3"),
				tr("1_INIT_4"),
				tr("1_INIT_5"),
				tr("1_INIT_6"),
				tr("1_INIT_7"),
				tr("1_INIT_8"),
				tr("1_INIT_9"),
				tr("1_INIT_10"),
				tr("1_INIT_11"),
				tr("1_INIT_12"),
			]
		],
		"dialogue_count": 0
	},
	"default": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("1_1K_1"), tr("1_1K_2")],
			[tr("1_1K_3"), tr("1_1K_4")],
		],
		"dialogue_count": 0
	},
	"floor_1_a": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("1_1A_1")],
			[tr("1_1A_2"), tr("1_1A_3")],
		],
		"dialogue_count": 0
	},
	"floor_1_b": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("1_1B_1"), tr("1_1B_1")],
			[tr("1_1B_3"), tr("1_1B_4")],
		],
		"dialogue_count": 0
	},
	"floor_1_c": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("1_1C_1"), tr("1_1C_2")],
			[tr("1_1C_3"), tr("1_1C_4")],
		],
		"dialogue_count": 0
	},	
	"floor_2_a": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("1_2A_1"), tr("1_2A_2")],
			[tr("1_2A_3"), tr("1_2A_4")],
		],
		"dialogue_count": 0
	},
	"floor_2_b": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("1_2B_1"), tr("1_2B_2")],
		],
		"dialogue_count": 0
	},
}

func _init():
	super._init(tr("level_1"), dialogues, "res://scenes/levels/level_1.tscn");

func set_enemy_path():
	enemy_path_1.checkpoints =  [
		{ "progress": 0.22, "has_passed": false, "turn_range": 1.2 },
		{ "progress": 0.565, "has_passed": false, "turn_range": 1.3 },
		{ "progress": 0.968, "has_passed": false, "turn_range": 1.4 },
	];
	
	enemy_path_2.checkpoints = [
		{ "progress": 0, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.16, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.55, "has_passed": false, "turn_range": 1.2 },
	];
	
	enemy_path_3.checkpoints = [
		{ "progress": 0.1, "has_passed": false, "turn_range": 1.1 },
		{ "progress": 0.44, "has_passed": false, "turn_range": 1.3 },
	];
	
	enemy_path_4.checkpoints = [
		{ "progress": 0.14, "has_passed": false, "turn_range": 1.1 },
		{ "progress": 0.35, "has_passed": false, "turn_range": 1.3 },
		{ "progress": 0.715, "has_passed": false, "turn_range": 1.3 },
		{ "progress": 0.95, "has_passed": false, "turn_range": 1.2 },
	];
	
	enemy_path_5.checkpoints = [
		{ "progress": 0.52, "has_passed": false, "turn_range": 1.3 },
		{ "progress": 0.97, "has_passed": false, "turn_range": 1.2 },
	];	

func _on_immovable_exit_door_on_door_entered() -> void:
	Globals.next_scene_info = {
		"current_level_key": "level_1",
		"next_scene": "res://scenes/levels/level_2.tscn",
		"new_time":  Time.get_unix_time_from_system() - Globals.time_pivot
	}
	
	Globals.save_time("level_1");
	Transition.change_scene("res://scenes/ui/level_completed.tscn");

func _on_area_f1a_entered(_body: Node3D) -> void:
	dialogue_key = "floor_1_a";

func _on_area_f1b_entered(_body: Node3D) -> void:
	dialogue_key = "floor_1_b";
	
func _on_area_f1c_entered(_body: Node3D) -> void:
	dialogue_key = "floor_1_c";

func _on_area_f2a_entered(_body: Node3D) -> void:
	dialogue_key = "floor_2_a";
	
func _on_area_f2b_entered(_body: Node3D) -> void:
	dialogue_key = "floor_2_b";
