extends ItemBase
class_name PU_WeaponDanio

# Variables exportables para ajustar desde el editor
#@export var cantidad: int = 2

	
# el payer recoje el maiz
func _on_body_entered(body): 
	if body.is_in_group("player") and not siendo_recolectado:
		siendo_recolectado = true
		GlobalWeapon.set_danioGlobal(randf_range(1.5,3.6)) #Es multiplicado por el danio que ya tiene el arma
		
		recolectar_efecto()
