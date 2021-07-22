extends Panel

onready var main_ui = $MainUI
onready var server_ip_address = $MainUI/ServerIPAddress
onready var device_ip_address = $CanvasLayer/DeviceIPAddress


func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	device_ip_address.text = Network.ip_address

# hosting을 시작함.
func _on_ButtonHost_pressed():
	main_ui.hide()
	Network.create_server()
	

# join
func _on_ButtonJoin_pressed():
	if server_ip_address.text != '':
		main_ui.hide()
		Network.ip_address = server_ip_address.text
		Network.join_server()
	
func _player_disconnected(id):
	print('player ' + str(id) + ' has disconnected')
	
# player가 연결됨
func _player_connected(id):
	print('player ' + str(id) + ' has connected')
