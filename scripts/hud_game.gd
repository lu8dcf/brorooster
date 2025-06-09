extends Control


@onready var life_bar: ProgressBar = $VBoxContainer/Background/HBoxContainer/VBoxContainer/life_bar
@onready var wave_text: Label = $VBoxContainer/Background/HBoxContainer/wave_text
@onready var time_text: Label = $VBoxContainer/Background/HBoxContainer/time
@onready var maiz_text: Label = $VBoxContainer/Background/HBoxContainer/VBoxContainer/maiz


func _ready() -> void:
	# Configuración inicia
	life_bar.max_value = Global.currentPlayer._max_health if Global.currentPlayer else 100
	life_bar.value = Global.currentPlayer._health if Global.currentPlayer else 100
	
	wave_text.text = "Oleada : "+str(GlobalOleada.oleada)
	time_text.text = str(GlobalOleada.tiempo_restante_oleada)
	maiz_text.text = str(GlobalOleada.maiz)
	
	# Conexión de señal
	Global.lives_changed.connect(_on_lives_changed)
	GlobalOleada.wave_changed.connect(_on_wave_changed)
	GlobalOleada.time_changed.connect(_on_time_wave_changed)  # Conecta la señal

func _process(delta: float) -> void:
	maiz_text.text = str(GlobalOleada.maiz)


func _on_lives_changed(new_value: int) -> void:
	life_bar.value = new_value
	# Aquí puedes agregar efectos visuales/auditivos cuando cambia la vida

func _on_wave_changed(new_value:int)-> void:
	wave_text.text = "Oleada : "+ str(new_value)
	
func _on_time_wave_changed(new_time: int):
	# Propaga el cambio de salud del personaje como señal global
	time_text.text = str(new_time) + " s"


func _on_pausa_pressed() -> void:
	pass # Replace with function body.
