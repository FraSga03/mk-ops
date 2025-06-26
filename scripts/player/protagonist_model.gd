extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func idle():
	playIfItsStopped("idle");

func walk_forward():
	playIfItsStopped("walkingForward");
	
func walk_backward():
	playIfItsStopped("walkingForward", true);
	
func walk_left(isBackward = false):
	playIfItsStopped("walkingLeft", isBackward);
	
func walk_right(isBackward = false):
	playIfItsStopped("walkingRight", isBackward);
	
func crouch_idle():
	playIfItsStopped("crouchIdle");
	
func crouch_forward():
	playIfItsStopped("crouchForward");
	
func crouch_backward():
	playIfItsStopped("crouchForward", true);
	
func crouch_right(isBackward = false):
	playIfItsStopped("crouchRight", isBackward);
	
func crouch_left(isBackward = false):
	playIfItsStopped("crouchLeft", isBackward);
	
func run_forward():
	playIfItsStopped("runningForward");
	
func run_backward():
	playIfItsStopped("runningForward", true);
	
func run_right(isBackward = false):
	playIfItsStopped("runningRight", isBackward);
	
func run_left(isBackward = false):
	playIfItsStopped("runningLeft", isBackward);

func from_stand_to_crouch():
	playIfItsStopped("standingToCrouch");
	
func from_crouch_to_stand():
	playIfItsStopped("crouchToStand");

func playIfItsStopped(animation, isBackward = false):
	if animation_player.current_animation != animation:
		if isBackward:
			animation_player.play_backwards(animation)
		else: 
			animation_player.play(animation)
