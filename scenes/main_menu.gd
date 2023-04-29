extends Control

var game_scn = preload("res://scenes/main.tscn")


@onready var play_button = $PanelContainer/VBoxContainer/PanelContainer/play_button
@onready var custom_parameters = $PanelContainer/VBoxContainer/CustomParameters

@onready var columns = $PanelContainer/VBoxContainer/CustomParameters/VBoxContainer/columns
@onready var rows = $PanelContainer/VBoxContainer/CustomParameters/VBoxContainer/rows
@onready var mines = $PanelContainer/VBoxContainer/CustomParameters/VBoxContainer/mines

func _ready():
	if Global.cur_game != null: Global.cur_game.queue_free()
	get_viewport().get_window().size = Vector2(512, 512)

func _on_option_button_item_selected(index):
	match index:
		0:
			Global.h_cells = 8
			Global.v_cells = 8
			Global.mines = 10
			hide_custom()
		1:
			Global.h_cells = 14
			Global.v_cells = 14
			Global.mines = 40
			hide_custom()
		2:
			Global.h_cells = 22
			Global.v_cells = 22
			Global.mines = 99
			hide_custom()
		3:
			enable_custom()

func hide_custom():
	play_button.disabled = false
	custom_parameters.hide()

func enable_custom():
	play_button.disabled = true
	custom_parameters.show()

func _on_columns_text_changed(new_text):
	if int(new_text) == 0:
		columns.text = ""
	custom_boxes_filled()

func _on_rows_text_changed(new_text):
	if int(new_text) == 0:
		rows.text = ""
	custom_boxes_filled()

func _on_mines_text_changed(new_text):
	if int(new_text) == 0:
		mines.text = ""
	custom_boxes_filled()

func custom_boxes_filled():
	if int(columns.text) > 1 and int(rows.text) > 1 and int(mines.text) > 0:
		play_button.disabled = false
		Global.h_cells = int(rows.text)
		Global.v_cells = int(columns.text) 
		Global.mines = int(mines.text)
	else:
		print("gola")
		play_button.disabled = true

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(game_scn)
