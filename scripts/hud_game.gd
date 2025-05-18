extends Control


@onready var life_bar: ProgressBar = $VBoxContainer/Background/HBoxContainer/VBoxContainer/life_bar

func _ready() -> void:
	# Configuración inicial
	life_bar.max_value = Global.lives
	life_bar.value = Global.lives
	
	# Conexión de señal
	Global.lives_changed.connect(_on_lives_changed)

func _on_lives_changed(new_value: int) -> void:
	life_bar.value = new_value
	# Aquí puedes agregar efectos visuales/auditivos cuando cambia la vida


func _on_pausa_pressed() -> void:
	pass # Replace with function body.
