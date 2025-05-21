extends Node2D
@onready var animation_player = $AnimationPlayer


	
	
	#muestra el retroceso 
func play_retroceso():
	animation_player.play("retroceso")	
