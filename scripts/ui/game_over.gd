extends Control

@onready var resume_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/ExitButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	
	resume_button.text = tr("try_again");
	exit_button.text = tr("exit");

func _on_resume_button_pressed() -> void:
	if Globals.current_play_scene == null:
		return;
	Transition.change_scene(Globals.current_play_scene);

func _on_exit_button_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn");
