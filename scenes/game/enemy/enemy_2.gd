extends Enemy
	
func SetUp():
	stats["nombre"] = "Gusano"
	stats["vida"] = 5
	stats["alcance"] = 0
	stats["dano"] = 5
	stats["velocidad"] = 1
	pass
	
func UsarStats(enemyGlobal: Dictionary):
	stats["nombre"] += enemyGlobal["nombre"]
	stats["vida"] += enemyGlobal["vida"]
	stats["alcance"] += enemyGlobal["alcance"]
	stats["dano"] += enemyGlobal["dano"]
	stats["velocidad"] += enemyGlobal["velocidad"]
	pass
	
