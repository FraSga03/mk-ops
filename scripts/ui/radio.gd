extends Control

@onready var character_name: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/CharacterName
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var content_text: RichTextLabel = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ContentText
@onready var close_button: Button = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/BoxContainer/CloseButton
@onready var go_on_button: Button = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/BoxContainer/GoOnButton
@onready var radio_toggle_sound: AudioStreamPlayer = $RadioToggleSound
@onready var radio_talking_sound: AudioStreamPlayer = $RadioTalkingSound

var character_name_text = "CIAO";
var dialogue = [];
var index = 0;
var to_read_chars = [];

const SPEED = 0.01;
	
func _ready() -> void:
	radio_talking_sound.play();
	character_name.add_text(character_name_text);
	
	close_button.text = tr("close");
	go_on_button.text = tr("next");
	
func init_vars(obj):
	character_name_text = obj["character_name_text"]
	dialogue = obj["dialogue"];

func _physics_process(delta: float) -> void:
	await get_tree().create_timer(delta * SPEED).timeout;
	if len(to_read_chars) > 0:
		content_text.append_text(to_read_chars.pop_at(0));
		
		if !radio_talking_sound.playing:
			radio_talking_sound.play();
	else:
		radio_talking_sound.stop();	
	

func read_text():
	to_read_chars = Array(dialogue[index].split(""));
	content_text.clear();
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		read_text();
	elif anim_name == "hide":
		Globals.on_resume.emit();
		queue_free();

func _on_go_on_button_pressed() -> void:
	index += 1;
	if index >= len(dialogue):
		radio_toggle_sound.play();
		animation_player.play("hide");
	else:
		read_text();

func _on_close_button_pressed() -> void:
	radio_toggle_sound.play();
	animation_player.play("hide");
