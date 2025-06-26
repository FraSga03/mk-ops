extends Control

@onready var time_1: Label = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/Time1
@onready var time_2: Label = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/Time2
@onready var time_3: Label = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/Time3
@onready var level_1_label: Label = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/Level1Label
@onready var level_2_label: Label = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/Level2Label
@onready var level_3_label: Label = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/Level3Label
@onready var exit_button: Button = $VBoxContainer/MainVerticalBox/MarginContainer/ExitButton

func _ready() -> void:
	level_1_label.text = tr("level_1");
	level_2_label.text = tr("level_2");
	level_3_label.text = tr("level_3");
	
	exit_button.text = tr("exit");
	
	set_time_label(time_1, "level_1");
	set_time_label(time_2, "level_2");
	set_time_label(time_3, "level_3");

func set_time_label(label, key):
	var time = Globals.load_time(key);
	
	if time == -1:
		time = Time.get_time_dict_from_unix_time(time);
	
	label.text = "%02d:%02d:%02d" % [time.hour, time.minute, time.second] if time != null else tr("no_time");

func _on_exit_button_pressed() -> void:
	queue_free();
