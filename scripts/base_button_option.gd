extends Button
@onready var audio_player: AudioStreamPlayer = $button_sound


func _on_pressed() -> void:
	audio_player.play()
