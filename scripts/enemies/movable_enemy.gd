extends PathFollow3D

@onready var enemy_path: PathFollow3D = $"."
@onready var enemy: CharacterBody3D = $Enemy

var path: Path3D;
var checkpoints: Array = [
	{ "progress": 0.2, "has_passed": false, "turn_range": 1 },
	{ "progress": 0.4, "has_passed": false, "turn_range": 1.2 },
	{ "progress": 0.8, "has_passed": false, "turn_range": 1.5 },
];
var current_progress = 0;
var tween;
@export var SPEED = 5;

func _physics_process(delta: float) -> void:
	if enemy.is_enemy_stopped():
		return;
			
	enemy_path.progress += delta * SPEED;
	enemy.enemy_body.walking();
	
	if enemy.audio_stream_player_3d.playing:
		enemy.audio_stream_player_3d.play();
	
	var new_progress_ratio = snapped(enemy_path.progress_ratio, 0.01);

	if new_progress_ratio < current_progress:
		reset_checkpoint();
	current_progress = new_progress_ratio;

	var checkpoint = find_checkpoint(current_progress);
	if checkpoint != null:
		enemy.rotate_by_range(checkpoint.get("turn_range"));
	
func find_checkpoint(path_progress):
	var i = 0;
	for item in checkpoints:
		if (item["progress"] == path_progress and !item["has_passed"]):
			checkpoints[i]["has_passed"] = true;
			return item;
		i += 1;
	
	return null;
	
func reset_checkpoint():
	for i in checkpoints.size():
		checkpoints[i]["has_passed"] = false;	

func _on_enemy_on_enemy_death() -> void:
	queue_free();
