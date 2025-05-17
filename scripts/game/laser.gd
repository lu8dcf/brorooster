extends Area2D

var speed = 1000.0  # Velocidad del láser
var tiempo_sonido = .2
var damage = 10 # Daño que genera la bala, esto se debera hacer generico
var direction: Vector2 # direccion hacia donde ira la bala, enemigo mas cercano

func _ready():
	$sonido_disparo.play() # Sonido del laser a disparar
	
	
func _physics_process(delta):
	position += direction * speed  * delta # Mover el disparo
	# Si el láser sale de la pantalla, se elimina
	if position.y < 0 or position.x < 0:  # falta agregar los exptremos para cuando la bala salga de pantalla
		queue_free()

func set_direction(dir: Vector2): # Direccion de la bala
	direction = dir
	
func _on_body_entered(body):   # cuando pege en el enemigo el daño que le provoca
	
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)  # Método en el enemigo de daño
		
	queue_free()
	
