extends Node

class_name Item

#Atributos
var nombre : String
#var tipoObjeto : String
var precio : int

#Metodos

func Vender():
	print("Vendo objeto")
	pass


func Comprar(valor):
	if (valor < Global.item.maiz):
		print("Compro el objeto")
	else:
		print("No me alcanza para comprarlo")
	pass
pass
