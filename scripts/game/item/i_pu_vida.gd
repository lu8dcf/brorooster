extends ItemBase
class_name PU_Vidaa

# Variables exportables para ajustar desde el editor
#@export var cantidad: int = 2

	
# el payer recoje el maiz
func _on_body_entered(body): 
	if body.is_in_group("player") and not siendo_recolectado:
		siendo_recolectado = true
		Global.currentPlayer.heal(20)
		# Funcion caracteristica
		
		recolectar_efecto()
