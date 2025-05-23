extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
var system_ready := false

func _ready():
	if not has_node("MusicPlayer"):
		music_player = AudioStreamPlayer.new()
		music_player.name = "MusicPlayer"
		add_child(music_player)
		music_player.bus = "Music"
	system_ready = true

func play_music(stream: AudioStream, loop: bool = true) -> void:
	if not system_ready or not is_instance_valid(music_player):
		push_warning("Audio system not ready!")
		return
	
	# Configura el loop según el tipo de stream
	if stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if loop else AudioStreamWAV.LOOP_DISABLED
	elif stream is AudioStreamOggVorbis:
		stream.loop = loop
	
	# Si ya está reproduciendo la misma pista, no hacer nada
	if music_player.stream == stream and music_player.playing:
		return
	
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	if system_ready and is_instance_valid(music_player):
		music_player.stop()
