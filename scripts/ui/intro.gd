extends Control

@onready var skip_button: Button = $MarginContainer/BoxContainer/SkipButton
@onready var go_on_button: Button = $MarginContainer/BoxContainer/GoOnButton
@onready var script_label: RichTextLabel = $MarginContainer2/ScriptLabel

var to_read_chars = [];
var current_index = 0;
var index = 0;
var intro_dialogues = [
	tr("intro_1"),
	tr("intro_2"),
	tr("intro_3"),
	tr("intro_4"),
	tr("intro_5"),
	tr("intro_6"),
];
const SPEED = 0.01;

func _ready() -> void:
	skip_button.text = "SKIP";
	go_on_button.text = tr("next");
	
	set_to_read_char(index);	

func _physics_process(delta: float) -> void:
	await get_tree().create_timer(delta * SPEED).timeout;
	if len(to_read_chars) > 0:
		script_label.append_text(to_read_chars.pop_at(0));

func set_to_read_char(curr_index):
	to_read_chars = Array(intro_dialogues[curr_index].split(""));
	script_label.clear();
	
func _on_skip_button_pressed() -> void:
	Transition.change_scene("res://scenes/levels/level_1.tscn");

func _on_go_on_button_pressed() -> void:
	if index == (intro_dialogues.size() - 1):
		Transition.change_scene("res://scenes/levels/level_1.tscn");
		return;
	
	index += 1;
	set_to_read_char(index)
