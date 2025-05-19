extends CanvasLayer

@export var Characters: Array[CharacterData]
@onready var char_portrait = $Sprite2D


var index_selection = 0
 
func _ready() -> void:
	update_portrait(index_selection)
	

func  update_portrait(index):
	char_portrait.texture = Characters[index].Imagen

func _on_btn_lef_pressed() -> void:
	if (index_selection > 0):
		index_selection-=1
	elif(index_selection == 0):
		index_selection = Characters.size()-1
	update_portrait(index_selection)
	
func _on_btn_rig_pressed() -> void:
	if (index_selection < Characters.size()-1):
		index_selection+=1
	elif(index_selection == Characters.size()-1):
		index_selection = 0
	update_portrait(index_selection)

# funcionalidad con teclado
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		_on_btn_ok_pressed()
	elif(event.is_action_pressed("ui_cancel")):
		get_tree().change_scene_to_file("res://scenes/Main_menu.tscn")
	elif (event.is_action_pressed("ui_right")):
		_on_btn_rig_pressed()
	elif (event.is_action_pressed("ui_left")):
		_on_btn_lef_pressed()

func select():
	Global.currentPlayer = Characters[index_selection]

func _on_btn_ok_pressed() -> void:
	select()
	get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")
