extends Arma

class_name ArmaExplosiva

#Atributos
var tiempoHastaExplotar: int

#Metodos
func Atacar():
	print("Arrojo...")
	await get_tree().create_timer(tiempoHastaExplotar).timeout
	print ("Boom!")
	pass
pass
