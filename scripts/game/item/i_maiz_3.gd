extends ItemBase
class_name Maiz3

# Variables exportables para ajustar desde el editor
@export var cantidad: int = 4


	
# el payer recoje el maiz
func _on_body_entered(body): 
	if body.is_in_group("player") and not siendo_recolectado:
		siendo_recolectado = true
		GlobalOleada.maiz += cantidad
		recolectar_efecto()
