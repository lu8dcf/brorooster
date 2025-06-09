# Clase abstracta "items"
extends Area2D
class_name ItemBase

# Variables exportables para ajustar desde el editor

@export var rotacion_velocidad: float = 50.0
@export var flotar_amplitud: float = 5.0
@export var flotar_velocidad: float = 2.0
@export var tiempo_vida: float = 5.0  # Tiempo antes de desaparecer automáticamente

# Variables internas
var tiempo_flotacion: float = 0.0
var tiempo_transcurrido: float = 0.0
var siendo_recolectado: bool = false

func _ready():
	# Configuración inicial
	scale = Vector2(0.5, 0.5)
	modulate.a = 0.8
	
	# Efecto al aparecer
	var tween_appear = create_tween()
	tween_appear.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_appear.parallel().tween_property(self, "modulate:a", 1.0, 0.3)
	tween_appear.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
	# Iniciar temporizador de vida
	if tiempo_vida > 0:
		await get_tree().create_timer(tiempo_vida).timeout
		if not siendo_recolectado:
			desaparecer_suavemente()
			
func _process(delta):
	if siendo_recolectado:
		return
		
	# Rotación continua
	$Sprite2D.rotation_degrees += rotacion_velocidad * delta
	
	# Efecto de flotación
	tiempo_flotacion += delta * flotar_velocidad
	var offset_y = sin(tiempo_flotacion) * flotar_amplitud
	$Sprite2D.position.y = offset_y
	
	# Temporizador de vida 
	tiempo_transcurrido += delta
	if tiempo_vida > 0 and tiempo_transcurrido > tiempo_vida * 0.7:
		# Comenzar a parpadear cuando le queda poco tiempo
		$AnimationPlayer.play("parpadeo")

func recolectar_efecto():
	# Efecto visual al ser recolectado
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	
	# Reproducir sonido 
	if has_node("AudioStreamPlayer"):
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
	queue_free()

func desaparecer_suavemente():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)	

func apply_effect(_player):
	pass  # Sobreescribir en los hijos
