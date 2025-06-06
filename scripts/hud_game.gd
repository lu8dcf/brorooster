extends Control


@onready var life_bar: ProgressBar = $VBoxContainer/Background/HBoxContainer/VBoxContainer/life_bar
@onready var wave_text: Label = $VBoxContainer/Background/HBoxContainer/wave_text

func _ready() -> void:
	# Configuración inicia
	life_bar.max_value = Global.currentPlayer._max_health if Global.currentPlayer else 100
	life_bar.value = Global.currentPlayer._health if Global.currentPlayer else 100
	
	wave_text.text = str(GlobalOleada.oleada)
	
	
	# Conexión de señal
	if Global.lives_changed.is_connected(_on_lives_changed):
		Global.lives_changed.disconnect(_on_lives_changed)
	Global.lives_changed.connect(_on_lives_changed)



func _on_lives_changed(new_value: int) -> void:
	life_bar.value = new_value
	# Aquí puedes agregar efectos visuales/auditivos cuando cambia la vida

func _on_wave_changed(new_value:String)-> void:
	wave_text.text = new_value



func _on_pausa_pressed() -> void:
	pass # Replace with function body.
