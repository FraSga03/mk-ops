extends Node3D
class_name Level

@onready var player = $Player
@onready var game_ui: Control = $GameUI

var RADIO = preload("res://scenes/ui/radio.tscn");
var PAUSE_MENU = preload("res://scenes/ui/pause_menu.tscn");

var is_game_over = false;
var scripts = {
	"default": {
		"character_name_text": "UOMO",
		"dialogues": [
			["La missione è ancora in corso!", "Corri lì", "Vai bastardo!"],
			["La missione è la vita!", "O la vica se preferisci", "Vaiiii!"]	
		],
		"dialogue_count": 0
	},
}
var dialogue_key = null;
var level_name;

func _init(name_l, sc):
	self.level_name = name_l;
	self.scripts = sc;

func _input(event: InputEvent) -> void:	
	if event is InputEventKey and !is_game_over:
		if Input.is_action_pressed("pause"):
			on_pause();
		if Input.is_action_pressed("radio"):
			open_radio();

func _game_over(e):
	is_game_over = true;
	player.is_freezed = true;
	var tween = create_tween();
	tween.parallel().tween_property(player.camera_pivot, "global_position", e.camera_pivot.global_position, 0.5);
	tween.parallel().tween_property(player.camera_pivot, "global_rotation", e.camera_pivot.global_rotation, 0.5);
	
	await get_tree().create_timer(2).timeout;
	Transition.change_scene("res://scenes/ui/game_over.tscn")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	Globals.on_resume.connect(resume_game);
	
	set_enemy_path();
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		enemy.on_player_detect.connect(_game_over.bind(enemy))
	
	game_ui.show_level_label(level_name)
		
	dialogue_key = "init";
	Globals.time_pivot = Time.get_unix_time_from_system()
	
	call_deferred("open_radio")

func after_ready():
	pass;

func set_enemy_path():
	pass;

func disable_game():
	game_ui.visible = false;
	process_mode = PROCESS_MODE_DISABLED;
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func on_pause():
	disable_game();
	get_tree().get_root().add_child(PAUSE_MENU.instantiate());

func resume_game():
	game_ui.visible = true;
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	process_mode = Node.PROCESS_MODE_INHERIT;

func open_radio():
	if dialogue_key == null:
		if !scripts.keys().has("default"):
			return;
		else:
			dialogue_key = "default";

	var dialogue = scripts[dialogue_key];
	if dialogue == null:
		return;
		
	var radio_instance = RADIO.instantiate();
	radio_instance.init_vars({ 
		"character_name_text": dialogue.character_name_text,
		"dialogue": dialogue.dialogues[dialogue.dialogue_count]
	});
	
	if dialogue.dialogue_count < len(dialogue.dialogues) - 1:
		scripts[dialogue_key].dialogue_count +=  1;
	
	disable_game();
	get_tree().get_root().add_child(radio_instance);
	
func _on_area_exited(_body: Node3D) -> void:
	dialogue_key = "default";
