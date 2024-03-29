extends Control

var player = load('res://scenes/Player.tscn')
onready var main_ui = $MainUI
onready var in_game = $InGame
onready var server_ip_address = $MainUI/ServerIPAddress
onready var device_ip_address = $CanvasLayer/DeviceIPAddress


func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_to_server')

	device_ip_address.text = Network.ip_address
	main_ui.show()
	in_game.hide()

# hosting을 시작함.
func _on_ButtonHost_pressed():
	main_ui.hide()
	in_game.show()
	in_game.start()
	Network.create_server()
	
	instance_player(get_tree().get_network_unique_id())
	
func _connected_to_server():
	yield(get_tree().create_timer(0.1), 'timeout')
	instance_player(get_tree().get_network_unique_id())
# join
func _on_ButtonJoin_pressed():
	if server_ip_address.text != '':
		main_ui.hide()
		in_game.show()
		in_game.start()
		Network.ip_address = server_ip_address.text
		Network.join_server()
	
func _player_disconnected(id):
	print('player ' + str(id) + ' has disconnected')
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()
	
# player가 연결됨
func _player_connected(id):
	print('player ' + str(id) + ' has connected')
	instance_player(id)
	
func instance_player(id):
	var player_instance = Globals.instance_node_at_location(player, Players, Vector2(rand_range(0, 100), rand_range(0, 100)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
