extends Node2D

onready var players = $Players
onready var spawn_pos = $SpawnPos

# Called when the node enters the scene tree for the first time.
func _ready():
	make_other_players()
#	make_my_player()
	

func make_other_players():
	for p in Globals.players:
		var other_player = preload("res://scenes/Player.tscn").instance()
		var network_id = p
		other_player.set_name(str(network_id))
		other_player.set_network_master(network_id)
		other_player.global_transform = spawn_pos.global_transform
		players.add_child(other_player)
	
func make_my_player():
	var my_player = preload("res://scenes/Player.tscn").instance()
	var network_id = get_tree().get_network_unique_id()
	my_player.set_name(str(network_id))
	my_player.set_network_master(network_id)
	my_player.global_transform = spawn_pos.global_transform
	players.add_child(my_player)
	Globals.players[my_player.get_network_master()] = my_player.get_name()


