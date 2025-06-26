extends Control

@onready var time_label: Label = $VBoxContainer/VBoxContainer/TimeLabel
@onready var record_label: Label = $VBoxContainer/VBoxContainer/RecordLabel
@onready var level_completed_label: Label = $VBoxContainer/LevelCompletedLabel

@onready var animation_player_bg: AnimationPlayer = $AnimationPlayerBG
@onready var animation_player_show_content: AnimationPlayer = $AnimationPlayerShowContent

@onready var continue_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/ContinueButton
@onready var exit_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/ExitButton


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	animation_player_bg.play("change_bg");
	animation_player_show_content.play("show_content");
	
	var current_time_unix = Globals.next_scene_info["new_time"]
	var record_time_unix = Globals.load_time(
		Globals.next_scene_info["current_level_key"]
	);
	
	var time = Time.get_time_dict_from_unix_time(current_time_unix);
	var record_time = Time.get_datetime_dict_from_unix_time(record_time_unix);
	
	level_completed_label.text = tr("level_completed");
	
	time_label.text = tr("time");
	time_label.text += ": %02d:%02d:%02d" % [time.hour, time.minute, time.second];
	
	record_label.text += "%02d:%02d:%02d" % [record_time.hour, record_time.minute, record_time.second];
	
	continue_button.text = tr("next")
	exit_button.text = tr("exit");

func _on_exit_button_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn");

func _on_continue_button_pressed() -> void:
	Transition.change_scene(Globals.next_scene_info["next_scene"]);
