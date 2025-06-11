extends Control

var current_weapon_index := -1 #variable para saber si esa arma ya se selecciono
@onready var life_bar: ProgressBar = $VBoxContainer/Background/HBoxContainer/VBoxContainer/life_bar
@onready var wave_text: Label = $VBoxContainer/Background/HBoxContainer/wave_text
@onready var time_text: Label = $VBoxContainer/Background/HBoxContainer/time
@onready var maiz_text: Label = $VBoxContainer/Background/HBoxContainer/VBoxContainer/maiz
@onready var weapon_hud: Control = $BaseHudgameWeapon
@onready var exp: Label = $VBoxContainer/weapon_player_hudgame/exp

func _ready() -> void:
	# Configuración inicia
	life_bar.max_value = Global.currentPlayer._max_health if Global.currentPlayer else 100
	life_bar.value = Global.currentPlayer._health if Global.currentPlayer else 100
	
	wave_text.text = "Oleada : "+str(GlobalOleada.oleada)
	exp.text = "puntos: " + str(GlobalOleada.experiencia)
	time_text.text = str(GlobalOleada.tiempo_restante_oleada)
	maiz_text.text = str(GlobalOleada.maiz)
	
	# Conexión de señal
	Global.lives_changed.connect(_on_lives_changed)
	GlobalOleada.wave_changed.connect(_on_wave_changed)
	GlobalOleada.time_changed.connect(_on_time_wave_changed)  # Conecta la señal

func _process(delta: float) -> void:
	maiz_text.text = str(GlobalOleada.maiz)
	exp.text = "puntos: " + str(GlobalOleada.experiencia)
	
	if life_bar.value <= 0:
		get_tree().change_scene_to_file("res://scenes/game/lost.tscn")
		
	# Detección de teclas numéricas
	for i in range(6):  # 0-5 para teclas 1-6
		if Input.is_key_pressed(KEY_1 + i) and Global.inventory_player.size() > i:
			if i != current_weapon_index: #Hago esta verificacion para que no se vuelva a cargar (si es igual al index, es decir que ya se cargo)
				select_weapon(i)
			break


func select_weapon(index: int):
	if index < Global.inventory_player.size() and Global.inventory_player[index] is ArmaData:
		#Global.current_weapon = Global.inventory_player[index]
		current_weapon_index = index #lo actualizo
		Global.change_currentWeapon(Global.inventory_player.get(index)) #envio el arma a change_currentWeapon
		#print("se cambia arma, de ",  Global.current_weapon.nombre, " a ",Global.inventory_player[index].nombre )
		# Aquí puedes agregar lógica adicional como:
		# - Actualizar el arma equipada en el jugador
		# - Resaltar el slot seleccionado en el HUD
		weapon_hud.update_inventory()  # Actualiza el HUD si es necesario

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
