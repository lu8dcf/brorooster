extends Enemy

var target: CharacterBody2D = null  # ← Asegurate de tener esto

func SetUp():
	stats["nombre"] = "Gusano"
	stats["vida"] = 5
	stats["alcance"] = 0
	stats["dano"] = 5
	stats["velocidad"] = 50  # velocidad en píxeles por segundo

func SetTarget(p_target: CharacterBody2D):
	target = p_target

func _physics_process(delta):
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * stats["velocidad"] * delta
