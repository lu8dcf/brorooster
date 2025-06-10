extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
var current_music: AudioStream
var system_ready := false

func _ready():
	if not has_node("MusicPlayer"):
		var player = AudioStreamPlayer.new()
		player.name = "MusicPlayer"
		add_child(player)
		player.bus = "Music"
		music_player = player
	system_ready = true

func play_music(stream: AudioStream, loop: bool = true) -> void:
	if not system_ready or not is_instance_valid(music_player):
		push_warning("Audio system not ready!")
		return
	

	
	# Si ya está reproduciendo la misma pista, no hacer nada
	if music_player.stream == stream and music_player.playing:
		return
		
	current_music = stream
			# Configura el loop según el tipo de stream
	if stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if loop else AudioStreamWAV.LOOP_DISABLED
	elif stream is AudioStreamOggVorbis:
		stream.loop = loop
	
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	if system_ready and is_instance_valid(music_player):
		music_player.stop()
		current_music = null
		
func set_music_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(volume))

func set_sfx_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear_to_db(volume))
	
	
	
