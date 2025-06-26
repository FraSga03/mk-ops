extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visibility_player: AnimationPlayer = $VisibilityPlayer

func idle():
	playIfItsStopped("idle");

func aiming():
	playIfItsStopped("aiming");

func walking():
	playIfItsStopped("walking");

func playIfItsStopped(animation, isBackward = false):
	if animation_player.current_animation != animation:
		if isBackward:
			animation_player.play_backwards(animation)
		else: 
			animation_player.play(animation)
			
func make_visible():
	visibility_player.play("make_visible");
