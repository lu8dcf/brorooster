extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		apply_effect(body)
		queue_free()

func apply_effect(_player):
	pass  # Sobreescribir en los hijos
