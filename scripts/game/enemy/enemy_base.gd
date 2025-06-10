class_name EnemigoBase
extends CharacterBody2D

var health : float # vida del bicho
var damage : float # daño que genera 
var veloci : float # velicidad e movimiento
var items : int  # tipo de item que tiene al morir (  0 - 7 )
var sprite : String  # direccion del sprite que tiene asociado
var red : int    #  cambio de color para las oleadas mayor a 20
var green : int
var blue : int

var movimiento = Vector2()
var recibe_danio = true  # en ocasiones los bichos son inmunes al daño
var cpu_particles : Node  # o $CPUParticles2D

func _ready():
	$Sprite2D.texture = load(sprite)
	$Sprite2D.modulate = Color(red, green, blue)
	cpu_particles = get_node("CPUParticles2D")  # o $CPUParticles2D
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("toco")

func take_damage(amount: float):
	if recibe_danio: # inmunidad al daño
		health -= amount
		cpu_particles.emitting = true  # Activa la emisión
		cpu_particles.one_shot = true  # Asegura que sea solo una vez
		if health <= 0:
			die()

func die():
	# Obtener la fábrica de items y pedirle que cree el item
	var item_factory = get_node("/root/main_game/ItemFactory")
	
	if item_factory:
		item_factory.spawn_item(items, global_position)
	GlobalOleada.experiencia += 5	
	queue_free()  # se elimina el enemigo
	
	

# daño a player
func _on_area_daño_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
