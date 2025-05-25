extends bulletClass  # Asegúrate de que bulletClass hereda de Area2D

var tiempoAtaque := 0.1
var estoyAtacando := false


func _ready():
	speed = 0  # por las dudas, pero no es necesario si sobrescribís _physics_process
	$Deteccion/CollisionShape2D.disabled = true
	await get_tree().process_frame
	Ataque()

func _physics_process(_delta):  # sobrescribe el movimiento de bulletClass
	pass  # no hacer nada, la bala queda estática

func Ataque():
	if estoyAtacando:
		return
	estoyAtacando = true
	$Deteccion/CollisionShape2D.disabled = false
	$sonido_disparo.play()

	await get_tree().create_timer(tiempoAtaque).timeout

	queue_free()  # Se autodestruye después del ataque


func _on_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		
	pass # Replace with function body.
