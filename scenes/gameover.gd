extends Control

var main_menu = preload("res://scenes/main_menu.tscn")

@onready var animation_player = $AnimationPlayer
@onready var label = $Panel/VBoxContainer/Label

func win():
	animation_player.play("panel_appear")
	label.text = "Victory!"

func lose():
	animation_player.play("panel_appear")
	label.text = "Defeat!"

func _on_play_again_button_pressed():
	Global.play_again()

func _on_new_game_button_pressed():
	get_tree().change_scene_to_packed(main_menu)
