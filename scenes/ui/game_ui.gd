extends Control

@onready var power_progress: ProgressBar = $LaunchPower/PowerMarginContainer/HBoxContainer/PowerProgress
@onready var time_label: Label = $Time/MarginContainer/HBoxContainer/TimeLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_label: Label = $LevelLabelControl/PowerMarginContainer/HBoxContainer/LevelLabel
@onready var level_label_control: Control = $LevelLabelControl
@onready var time_title_label: Label = $Time/MarginContainer/HBoxContainer/TimeTitleLabel

var sb = StyleBoxFlat.new();

func _ready() -> void:
	level_label.position.x = -350;
	power_progress.add_theme_stylebox_override("fill", sb);
	
	time_title_label.text = tr("time");


func _process(_delta: float) -> void:
	power_progress.value = Globals.launch_power;
	
	var time_passed = Time.get_time_dict_from_unix_time(
		Time.get_unix_time_from_system() - Globals.time_pivot
	);
	time_label.text = "%02d:%02d" % [time_passed.minute, time_passed.second];

	if power_progress.value > 5:
		if power_progress.value > 8:
			sb.bg_color = Color.html("#8B1E3F")
		else:
			sb.bg_color = Color.html("#00B8A9")
	else:
		sb.bg_color = Color.html("#3E4C59")
		
func show_level_label(level_name: String):
	level_label.text = level_name;
	var tween = create_tween();
	tween.tween_property(level_label_control, "position:x", 0, 0.8);
	
	await get_tree().create_timer(7).timeout;
	
	var tween_b = create_tween();
	tween_b.tween_property(level_label_control, "modulate", Color.html("ffffff00"), 0.5);
