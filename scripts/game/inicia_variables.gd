extends Node2D
# modulo para iniciar variables de cero al reiniciar el juego

func reiniciar():
	
	GlobalOleada.oleada=1
	GlobalOleada.experiencia=0
	GlobalOleada.maiz=0
	GlobalOleada.eliminar_todos_enemigos()
	
	# Player
	Global.currentPlayer=null
	Global.currentWeapon=null
	Global.inventory_player=[null,null,null,null,null,null]
	
	# weapon
	
