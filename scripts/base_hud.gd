extends Button

@onready var audio_player: AudioStreamPlayer = $button_sound

func _on_pressed():
	audio_player.play()
