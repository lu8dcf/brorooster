class_name PlayerFactory

static func load_player(scene_path: String, health: int, speed: int, armor: int, sprite_path: String) -> Player:
	var player_scene = load(scene_path) as PackedScene
	if player_scene:
		var player = player_scene.instantiate() as Player
		player.setup(health, speed, armor, sprite_path)
		return player
	push_error("No se pudo cargar la escena del jugador en: ", scene_path)
	return null
