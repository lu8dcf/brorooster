extends ParallaxBackground

var DIR = Vector2(1, 1)
var speed = 100

func _physics_process(delta):
	scroll_base_offset +=DIR*speed*delta
	
