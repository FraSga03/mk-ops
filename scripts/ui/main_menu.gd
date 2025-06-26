extends Control

@onready var background: ColorRect = $Background;
@onready var play_button: Button = $Buttons/VBoxContainer/PlayButton
@onready var command_button: Button = $Buttons/VBoxContainer/CommandButton
@onready var record_button: Button = $Buttons/VBoxContainer/RecordButton
@onready var lang_button: Button = $Buttons/VBoxContainer/LangButton
@onready var exit_button: Button = $Buttons/VBoxContainer/ExitButton

var options = preload("res://scenes/ui/commands.tscn");
var records = preload("res://scenes/ui/records.tscn");
var levels = preload("res://scenes/ui/levels_menu.tscn");

var colors = [
	Color.html("0B0C10"),
	Color.html("3E4C59"),
	Color.html("A2A2A2"),
];
const COLOR_SPEED_CHANGE = 10;

func _init() -> void:
	TranslationServer.set_locale(Globals.lang);

func _process(_delta: float) -> void:
	if background.color.to_abgr32() == colors[0].to_abgr32():
		animate_bg();
	
func animate_bg():
	var tween = get_tree().create_tween();
	tween.tween_property(background, "color", colors[1], COLOR_SPEED_CHANGE);
	tween.tween_property(background, "color", colors[2], COLOR_SPEED_CHANGE);
	tween.tween_property(background, "color", colors[0], COLOR_SPEED_CHANGE);
	
func _ready() -> void:
	$Buttons/VBoxContainer/PlayButton.grab_focus();
	
	update_labels();
	
func update_labels():
	play_button.text = tr("play");
	command_button.text = tr("commands");
	record_button.text = tr("records");
	lang_button.text = tr("language");
	exit_button.text = tr("exit");

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/levels_menu.tscn");	

func _on_commands_button_pressed() -> void:
	get_tree().get_root().add_child(options.instantiate());

func _on_exit_button_pressed() -> void:
	get_tree().quit();

func _on_record_button_pressed() -> void:
	get_tree().get_root().add_child(records.instantiate());

func _on_lang_button_pressed() -> void:
	Globals.lang = "it" if Globals.lang == "eng" else "eng";
	update_labels();
