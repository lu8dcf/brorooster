extends Node

@export var CadenciaDisparo :  float = 1.0 #Recordar que hay velocidades de por ejemplo 0,2
#Por lo tando 15.0 * 0.2 da 3, 3 segundos entre disparo. (15.0 es excelente para probar)
@export var danio :float = 1.0
var sprite_arma_default = "res://assets/graphics/character_graphics/armas/armas_con_sus_niveles/arma" # se le agregara el numero de arma y nivel
var direccionEnemigoCerca
@export var weapons: Array[ArmaData] = []
var currentWeapon


# Señales
signal weapon_updatedStats #PARA QUE ESTO FUNCIONE, hay que usar si o si, los SET
signal cambioArma (new_weapon: ArmaData)



#set
func set_CadenciaGlobal (valor: float):
	CadenciaDisparo = valor
	emit_signal("weapon_updatedStats")
	pass
func set_danioGlobal(valor: float):
	danio = valor
	emit_signal("weapon_updatedStats")
	pass
	
#getter
func get_CadenciaGlobal() -> float:
	return CadenciaDisparo
	pass
	
func get_danioGlobal() -> float:
	return danio
	pass

# Métodos


func CombinarArma(arma : ArmaData) -> ArmaData:
	#solo modifico y retorno
	var sprite_path = sprite_arma_default + str(arma.id) + "_nivel" + str(arma._rarety+1) + ".png"
	arma.sprite = load(sprite_path)
	arma._rarety +=1
	arma.damage +=  randf_range(4,11) #esto se puede mejorar
	return arma
pass

func cambiarArma(arma: ArmaData):
	cambioArma.emit(arma)
	pass

##Obtengo la direccion del enemigo mas cercano
#func _on_enemy_detected(angle: float):
	#direccionEnemigoCerca = angle
	#pass
#
#func getDireccionEnemigo() -> float:
	#return direccionEnemigoCerca
#pass



#Funcion para retornar las armas que haya(por si despues se crean mas
func listaArmas () -> Array[ArmaData]:
	var carpeta = "res://scripts/game/Arma/Armas/"
	var dir = DirAccess.open(carpeta) #manejo de directorio
	if dir == null: #por las dudas
		push_error("No se pudo abrir la carpeta de armas.")
		return weapons
	dir.list_dir_begin() #comienza a listar
	while true: #me permite recorrer todos los archivos de la carpeta de arriba
		var archivo = dir.get_next()
		if archivo == "":
			break
		if archivo.ends_with(".tres"):
			weapons.append(load(carpeta + archivo)) #Agrega a la lista ese archivo
	dir.list_dir_end()
	return weapons

#funcion que genere una arma rara (con rareza)
func get_armaRara()-> ArmaData:
	var armaR = listaArmas().pick_random()
	var i=0
	while (i<= randi_range(0,4)):
		armaR = subirRareza(armaR)
		i+=1
	return armaR

func subirRareza(arma : ArmaData)-> ArmaData:
	var sprite_path = sprite_arma_default + str(arma.id) + "_nivel" + str(arma._rarety+1) + ".png"
	arma.sprite = load(sprite_path)
	arma._rarety +=1
	arma.damage +=  randf_range(4,11) #esto se puede mejorar
	arma.costo += randi_range(4,8)
	return arma
	
#Ey, con esto se puede proponer algo interesante
#func _ready():
	#match dificultad_actual:
		#"fácil":
			#GlobalWeapon.daño_base_global = 15
			#GlobalWeapon.cadencia_base_global = 0.4
		#"difícil":
			#GlobalWeapon.daño_base_global = 8
			#GlobalWeapon.cadencia_base_global = 0.7
