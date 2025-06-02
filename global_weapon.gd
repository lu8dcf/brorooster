extends Node

@export var CadenciaDisparo :  float = 1.0 #Recordar que hay velocidades de por ejemplo 0,2
#Por lo tando 15.0 * 0.2 da 3, 3 segundos entre disparo. (15.0 es excelente para probar)
@export var danio :int = 1



#set
func set_CadenciaGlobal (valor: float):
	CadenciaDisparo = valor
	pass
func set_danioGlobal(valor: int):
	danio = valor
	pass
	
#getter
func get_CadenciaGlobal() -> float:
	return CadenciaDisparo
	pass
	
func get_danioGlobal() -> int:
	return danio
	pass

# Señales
signal weapon_updated

# Métodos
func atack(amount: int) -> void:
	pass
	
func buy(amount: float) -> void:
	pass
func sell(amount: float) -> void:
	pass
 
#Ey, con esto se puede proponer algo interesante
#func _ready():
	#match dificultad_actual:
		#"fácil":
			#GlobalWeapon.daño_base_global = 15
			#GlobalWeapon.cadencia_base_global = 0.4
		#"difícil":
			#GlobalWeapon.daño_base_global = 8
			#GlobalWeapon.cadencia_base_global = 0.7
