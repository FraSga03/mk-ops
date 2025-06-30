extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visibility_player: AnimationPlayer = $VisibilityPlayer
@onready var rifle_animation_player: AnimationPlayer = $RifleAnimationPlayer

func idle():
	playIfItsStopped(animation_player, "idle");
	playIfItsStopped(rifle_animation_player, "idle");

func aiming():
	playIfItsStopped(animation_player, "aiming");
	playIfItsStopped(rifle_animation_player, "aiming");

func walking():
	playIfItsStopped(animation_player, "walking");
	playIfItsStopped(rifle_animation_player, "walking");

func playIfItsStopped(player, animation, isBackward = false):
	if player.current_animation != animation:
		if isBackward:
			player.play_backwards(animation)
		else: 
			player.play(animation)
			
func make_visible():
	visibility_player.play("make_visible");
