extends Control

@onready var animation_player = $AnimationPlayer

func win():
	animation_player.play("victory_appear")

func lose():
	animation_player.play("defeat_appear")
