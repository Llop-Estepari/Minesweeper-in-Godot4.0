extends Node2D

var tile_scn = preload("res://scenes/tile.tscn")

@onready var tiles_node = $Tiles
@onready var gameover_screen = $gameover_screen

#Game config
var h_cells : int = 12
var v_cells : int = 8
var mines : int = 10
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

func _ready():
	panel_size = Vector2i(h_cells*64, v_cells*64)
	get_viewport().get_window().size = panel_size
	gameover_screen.position = panel_size / 2
	$Camera2D.position = panel_size / 2
	reset_globals()
	connect_signals()
	create_board()
	spawn_mines()
	set_numbers()

func reset_globals():
	Global.gameover = false

func connect_signals():
	Global.connect("lose", lose)
	Global.connect("reveal_around", reveal_around)
	Global.connect("tile_flagged", tile_flagged)
	Global.connect("tile_discovered", tile_discovered)

func create_board():
	for h in h_cells:
		for v in v_cells:
			var new_tile = tile_scn.instantiate()
			tiles_node.add_child(new_tile)
			new_tile.position = Vector2(h,v) * 64
	tiles = tiles_node.get_children()

func spawn_mines():
	var aux = 0
	while aux < mines:
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

func tile_discovered():
	tiles_discovered += 1
	if tiles_discovered == tiles.size() - mines: victory()

func tile_flagged():
	var mines_flagged = 0
	for t in tiles:
		if t.flagged and t.has_bomb: mines_flagged += 1
		if mines_flagged > mines: return
	if mines_flagged == mines: victory()

func victory():
	Global.gameover = true
	gameover_screen.win()
	for t in tiles: t.show_bomb()

func lose():
	Global.gameover = true
	for t in tiles: t.show_bomb()
	gameover_screen.lose()
