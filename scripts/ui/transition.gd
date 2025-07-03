extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.color = Color.TRANSPARENT;
	layer = 0;

func change_scene(target: String, func_after_change = null) -> void:
	layer = 1;
	$AnimationPlayer.play("fade_to_black");
	await $AnimationPlayer.animation_finished;
	if func_after_change != null:
		func_after_change.call();
	
	get_tree().change_scene_to_file(target);	
	$AnimationPlayer.play_backwards("fade_to_black");
	await $AnimationPlayer.animation_finished;
	layer = 0;
