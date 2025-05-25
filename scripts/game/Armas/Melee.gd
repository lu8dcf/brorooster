extends Arma

class_name esMelee

#Atributos
var damage = 10;
var estoyAtacando = false;

#Metodo



func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("enemies") and body.has_method("take_damage") and !estoyAtacando:
		estoyAtacando=true
		body.take_damage(damage)  # Método en el enemigo de daño
		await get_tree().create_timer(.1).timeout
		estoyAtacando=false
pass # Replace with function body.
