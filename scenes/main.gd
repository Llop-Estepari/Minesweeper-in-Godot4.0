extends Node2D

var tile_scn = preload("res://scenes/tile.tscn")

@onready var flags = $Camera2D/CanvasLayer/HBoxContainer/HBoxContainer/Panel/HBoxContainer/Flags
@onready var time_minuts = $Camera2D/CanvasLayer/HBoxContainer/HBoxContainer2/Panel/HBoxContainer/HBoxContainer/TimeMinuts
@onready var time_seconds = $Camera2D/CanvasLayer/HBoxContainer/HBoxContainer2/Panel/HBoxContainer/HBoxContainer/TimeSeconds

@onready var tiles_node = $Tiles
@onready var gameover_screen = $gameover_screen

#Game config
var panel_size : Vector2i

var offsets = [
	(Vector2.UP + Vector2.LEFT) * 64,
	(Vector2.UP) * 64,
	(Vector2.UP + Vector2.RIGHT) * 64,
	(Vector2.LEFT) * 64,
	(Vector2.RIGHT) * 64,
	(Vector2.DOWN + Vector2.LEFT) * 64,
	(Vector2.DOWN) * 64,
	(Vector2.DOWN + Vector2.RIGHT) * 64]
var tiles : Array
var tiles_with_bomb : Array
var tiles_discovered : int = 0

var time_start = 0
var time_now = 0

func _ready():
	time_start = Time.get_unix_time_from_system()
	Global.gameover = false
	Global.cur_game = self
	panel_size = Vector2i(Global.h_cells*64, Global.v_cells*64)
	get_viewport().get_window().size = panel_size
	gameover_screen.position = panel_size / 2
	$Camera2D.position = panel_size / 2
	connect_signals()
	create_board()
	spawn_mines()
	set_numbers()

func _process(_delta):
	set_timer()

func set_timer():
	if Global.gameover:
		return
	time_now = Time.get_unix_time_from_system()
	if int(time_seconds.text) < 10: time_seconds.text = str("0",int(time_now - time_start))
	else: time_seconds.text = str(int(time_now - time_start))
	if time_seconds.text == "60":
		time_minuts.text = str(int(time_minuts.text) + 1)
		if int(time_minuts.text) < 10:
			time_minuts.text = str("0", int(time_minuts.text))
		time_start = Time.get_unix_time_from_system()

func connect_signals():
	Global.connect("lose", lose)
	Global.connect("reveal_around", reveal_around)
	Global.connect("tile_discovered", tile_discovered)
	Global.connect("flagged", on_flag_placed)

func create_board():
	for h in Global.h_cells:
		for v in Global.v_cells:
			var new_tile = tile_scn.instantiate()
			tiles_node.add_child(new_tile)
			new_tile.position = Vector2(h,v) * 64
	tiles = tiles_node.get_children()

func spawn_mines():
	var aux = 0
	flags.text = str(Global.mines)
	while aux < Global.mines:
		var tile = tiles[randi() % len(tiles)]
		if not tile.has_bomb:
			tile.set_bomb()
			aux += 1
			tiles_with_bomb.append(tile)

func set_numbers():
	for t in tiles:
		get_surrounds(t)

func get_surrounds(_tile):
	var surrounds : Array = []
	for offset in offsets:
		for t in tiles:
			if t.position == _tile.position + offset:
				if t.has_bomb: surrounds.append(t)
	_tile.set_number(surrounds.size())

func reveal_around(_tile):
	var tiles_to_reveal = []
	for offset in offsets:
		for t in tiles:
			if t.position == _tile.position + offset:
				tiles_to_reveal.append(t)
	for i in tiles_to_reveal: i.uncover()

func on_flag_placed(placed):
	if placed:
		flags.text = str(int(flags.text) - 1)
	else:
		flags.text = str(int(flags.text) + 1)

func tile_discovered():
	tiles_discovered += 1
	if tiles_discovered == tiles.size() - Global.mines: victory()

func victory():
	Global.gameover = true
	gameover_screen.win()
	for t in tiles: t.show_bomb()

func lose():
	Global.gameover = true
	for t in tiles: t.show_bomb()
	gameover_screen.lose()
