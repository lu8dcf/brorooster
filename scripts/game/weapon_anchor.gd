extends Marker2D

var velocidad_rotacion = 5.0  # Ajusta la velocidad de amortiguamiento

func _ready():
	_actualizar_orientacion()
	rotation = 10
func _process(delta: float) -> void:
	var angulo_deseado = GlobalShoot.angulo_disparo
	var angulo_actual = rotation
	rotation = lerp_angle(angulo_actual, angulo_deseado, velocidad_rotacion * get_process_delta_time())
	print (angulo_deseado)

func _actualizar_orientacion():
	var angulo_deseado = GlobalShoot.angulo_disparo
	var angulo_actual = rotation
	rotation = lerp_angle(angulo_actual, angulo_deseado, velocidad_rotacion * get_process_delta_time())
	print (angulo_deseado)
