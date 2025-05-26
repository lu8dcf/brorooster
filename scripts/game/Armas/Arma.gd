extends Item

class_name Arma

#Atributos

var id : int
var danio: int
var tiempoAccion : float
var tipoBullet =["Fuego", "Electrico","Comun"]
var nivel : int


#Metodos
func Atacar():
	pass

func SubirNivel():
	pass
	
func CombinarArma(condiciones):
	if(condiciones):
		print("Cumpli con las condiciones y retorno el path del obj")
	else:
		print("No es posoble combinar")
	pass
pass
