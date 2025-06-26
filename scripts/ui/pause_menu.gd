extends Control

var options = preload("res://scenes/ui/commands.tscn");
@onready var title_label: Label = $ColorRect/VBoxContainer/TitleLabel
@onready var resume_button: Button = $ColorRect/VBoxContainer/VBoxContainer/ResumeButton
@onready var commands_button: Button = $ColorRect/VBoxContainer/VBoxContainer/CommandsButton
@onready var exit_button: Button = $ColorRect/VBoxContainer/VBoxContainer/ExitButton

func _ready() -> void:
	title_label.text = tr("pause");
	exit_button.text = tr("exit");
	commands_button.text = tr("commands");
	resume_button.text = tr("resume");
	
func _on_exit_button_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn", queue_free);


func _on_resume_button_pressed() -> void:
	Globals.on_resume.emit();
	queue_free();
	
func _on_commands_button_pressed() -> void:
	get_tree().get_root().add_child(options.instantiate());
