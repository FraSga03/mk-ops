extends Control

@onready var forward_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/ForwardLabel
@onready var backward_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/BackwardLabel
@onready var right_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/RightLabel
@onready var left_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/LeftLabel
@onready var run_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/RunLabel
@onready var crouch_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer/CrouchLabel
@onready var pick_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/PickLabel
@onready var throw_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/ThrowLabel
@onready var release_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/ReleaseLabel
@onready var scan_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/ScanLabel
@onready var radio_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/RadioLabel
@onready var pause_label: HBoxContainer = $VBoxContainer/MainVerticalBox/CommandListBox/VBoxContainer2/PauseLabel
@onready var exit_button: Button = $VBoxContainer/MainVerticalBox/MarginContainer/ExitButton

func _ready() -> void:
	forward_label.label.text = tr("forward");
	backward_label.label.text = tr("backward");
	right_label.label.text = tr("right");
	left_label.label.text = tr("left");
	run_label.label.text = tr("run");
	crouch_label.label.text = tr("crouch");
	pick_label.label.text = tr("pick");
	throw_label.label.text = tr("throw");
	release_label.label.text = tr("release");
	scan_label.label.text = tr("scan");
	radio_label.label.text = tr("radio");
	pause_label.label.text = tr("pause");
	
	exit_button.text = tr("exit");

func _on_exit_button_pressed() -> void:
	queue_free();
