class_name bulletFactory


static func load_bullet(scene_path: String, speed: int, tiempo_sonido: int, damage: int, direction: Vector2, sprite_path: String) -> bulletClass:
	var bullet_scene = load(scene_path) as PackedScene
	if bullet_scene:
		var bullet = bullet_scene.instantiate() as bulletClass
		bullet.setup(speed, tiempo_sonido, damage, direction, sprite_path)
		return bullet
	push_error("No se pudo cargar la escena 'bullet'  en: ", scene_path)
	return null
#Comprobar
