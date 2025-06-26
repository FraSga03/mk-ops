extends Control

@onready var animation_player_bg: AnimationPlayer = $AnimationPlayerBG
@onready var animation_player_show_content: AnimationPlayer = $AnimationPlayerShowContent
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var exit_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/ExitButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	animation_player_bg.play("change_bg");
	animation_player_show_content.play("show_content");
	
	title_label.text = tr("thanks");
	exit_button.text = tr("exit");

func _on_commands_button_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn");
