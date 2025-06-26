extends Control

@onready var level_1_button: Button = $VBoxContainer/MainVerticalBox/VBoxContainer/Level1Button
@onready var level_2_button: Button = $VBoxContainer/MainVerticalBox/VBoxContainer/Level2Button
@onready var level_3_button: Button = $VBoxContainer/MainVerticalBox/VBoxContainer/Level3Button
@onready var exit_button: Button = $VBoxContainer/MainVerticalBox/MarginContainer/ExitButton
@onready var title_label: Label = $VBoxContainer/MainVerticalBox/TitleLabel

func _on_exit_button_pressed() -> void:
	queue_free();

func _ready() -> void:
	var level_one_record = Globals.load_time("level_1");
	var level_two_record = Globals.load_time("level_2");

	if level_one_record != -1:
		level_2_button.disabled = false;
		
	if level_two_record != -1:
		level_3_button.disabled = false;

	exit_button.text = tr("exit");
	level_1_button.text = tr("level_1");
	level_2_button.text = tr("level_2");
	level_3_button.text = tr("level_3");
	title_label.text = tr("select_level");
	
func _on_play_level_1() -> void:
	Transition.change_scene("res://scenes/ui/intro.tscn", queue_free);
	
func _on_play_level_2() -> void:
	Transition.change_scene("res://scenes/levels/level_2.tscn");
	
func _on_play_level_3() -> void:
	Transition.change_scene("res://scenes/levels/level_3.tscn")
