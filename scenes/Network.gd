extends Node


const DEFAULT_PORT = 29850
const MAX_CLIENTS = 6

var server = null
var client = null

var ip_address = ''

func _ready():
	if OS.get_name() == 'Windows':
		ip_address = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		ip_address = IP.get_local_addresses()[3]
		
	for ip in IP.get_local_addresses():
		if ip.begins_with('192.168.') and not ip.ends_with('.1'):
			ip_address = ip
			
	get_tree().connect("connected_to_server", self, '_connected_to_server')
	get_tree().connect("server_disconnected", self, '_server_disconnected')
	
func is_html()->bool:
	return true
	if OS.get_name() == "HTML":
		return true
	else:
		return false
		
func create_server():
	if is_html():
		server = WebSocketServer.new()
		server.listen(DEFAULT_PORT, PoolStringArray(), true)
	else:
		server = NetworkedMultiplayerENet.new()
		server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)
	
func join_server():
	if is_html():
		client = WebSocketClient.new()
		var url = 'ws://'+ip_address+':'+str(DEFAULT_PORT)
		client.connect_to_url(url, PoolStringArray(), true)
	else:
		client = NetworkedMultiplayerENet.new()
		client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)
	
func _process(delta):
	if is_html():
		if server != null:
			server.poll()
		if client != null:
			if client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED || client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING:
				client.poll()
			
	

func _connected_to_server():
	print('successfully connected to the server')
	
func _server_disconnected():
	print('disconnected from the server')
