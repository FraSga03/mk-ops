extends HBoxContainer

@export var text = ""
@export var texture_path = ""
@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	label.text = text;
	texture_rect.texture = load(texture_path);
