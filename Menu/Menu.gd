extends Node2D

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")

func _connected_ok():
	visible = false
	print("Connection OK")
	var client = Globals.client_scene.instance()
	client.name = Globals.manager_name
	client.my_name = $ClientButton/Name.text
	add_child(client)

func _connected_fail():
	print("Connection failed")
	get_tree().network_peer = null

func _on_HostButton_pressed():
	print("Server started")
	visible = false
	var peer = NetworkedMultiplayerENet.new()
	peer.channel_count = 100
	peer.create_server(Globals.PORT, 32)
	get_tree().network_peer = peer
	var server = Globals.server_scene.instance()
	server.name = Globals.manager_name
	add_child(server)
	

func _on_ClientButton_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.channel_count = 100
	peer.create_client($ClientButton/IP.text, Globals.PORT)
	get_tree().network_peer = peer
	


