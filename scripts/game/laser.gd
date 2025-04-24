extends Area2D

var speed = 600.0  # Velocidad del láser
var tiempo_sonido = .2

func _ready():
	$laser.play() # Sonido del laser a disparar
	
	
func _physics_process(delta):
	position.y -= speed * delta # Mover el láser hacia arriba
	# Si el láser sale de la pantalla, se elimina
	if position.y < 0:
		queue_free()
