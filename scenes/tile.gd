extends Node2D

@onready var undiscovered = $Undiscovered
@onready var label = $Label
@onready var bomb = $Bomb
@onready var flag = $Flag

var flagged := false
var has_bomb := false

func _on_control_gui_input(event):
	if bomb.visible == true or not undiscovered.visible or Global.gameover: return
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse"):
			uncover()
		if event.is_action_pressed("right_mouse"):
			flagged = !flagged
			flag.visible = !flag.visible
			Global.emit_signal("flagged", flag.visible)

func set_bomb():
	has_bomb = true

func uncover():
	if flagged or not undiscovered.visible:
		return
	undiscovered.hide()
	if has_bomb:
		Global.emit_signal("lose")
		show_bomb()
		return
	label.show()
	Global.emit_signal("tile_discovered")
	if label.text == "":
		Global.emit_signal("reveal_around", self)

func show_bomb():
	if has_bomb: 
		bomb.show()
		flag.hide()
		undiscovered.hide()

func set_number(num:int):
	if num == 0 or has_bomb:
		return
	if num == 1:
		label.modulate = Color.ANTIQUE_WHITE
	elif num == 2:
		label.modulate = Color.GREEN_YELLOW
	elif num == 3:
		label.modulate = Color.CORNFLOWER_BLUE
	elif num == 4:
		label.modulate = Color.DARK_ORANGE
	elif num == 5:
		label.modulate = Color.DARK_BLUE
	elif num == 6:
		label.modulate = Color.YELLOW
	elif num == 7:
		label.modulate = Color.ORANGE_RED
	elif num == 8:
		label.modulate = Color.HOT_PINK
	label.text = str(num)
