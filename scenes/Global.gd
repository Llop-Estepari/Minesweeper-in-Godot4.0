extends Node

var game_scn = preload("res://scenes/main.tscn")
var cur_game

var gameover := false

var h_cells : int = 12
var v_cells : int = 8
var mines : int = 10

signal lose
signal reveal_around(tile)
signal tile_discovered()
signal flagged(placed : bool)

func new_game(h, v, m):
	h_cells = h
	v_cells = v
	mines = m
	create_game()

func play_again():
	create_game()

func create_game():
	if cur_game: cur_game.queue_free()
	var game = game_scn.instantiate()
	get_tree().get_root().add_child(game)
