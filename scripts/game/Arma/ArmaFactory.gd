extends Node
class_name ArmaFactory
# factory
static func crear_arma(scene_path: String, nombre : String, sprite : Texture2D, damage : float, tiempoDisparo : float, bullet_scene : PackedScene, costo : int) -> Arma:
	var arma_scene = load(scene_path) as PackedScene
	if arma_scene:
		var arma_node = arma_scene.instantiate() as Arma
		arma_node.setup(nombre, sprite, damage, tiempoDisparo, bullet_scene, costo)
		return arma_node
	push_error("No se pudo cargar la escena del arma en: " + scene_path)
	return null
