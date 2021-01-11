extends Node

var my_name
var my_id
var my_interface
var server_interface
var instance

func _process(delta):
	get_tree().network_peer.put_packet("tak".to_ascii())

func _ready():
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	my_id = get_tree().get_network_unique_id()
	my_interface = Globals.player_interface_scene.instance()
	my_interface.set_network_master(my_id)
	my_interface.name = Globals.player_interface_name + str(my_id)
	add_child(my_interface)
	my_interface = get_node(my_interface.name)
	
	server_interface = Globals.server_interface_scene.instance()
	server_interface.set_network_master(1)
	server_interface.name = Globals.server_interface_name
	add_child(server_interface)
	server_interface = get_node(server_interface.name)
	
	instance = get_node(Globals.player_instance_name + str(my_id))

func _server_disconnected():
	print("Server disconnected")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().visible = true
	queue_free()

func set_inputs(move,dir,jump,key):
	my_interface.set_inputs(move,dir,jump,key)


func pool_info():
	my_interface.reply_info(my_name)
	instance.acknowledged = true
	
func add_player(id):
	if id != my_id:
		print("Player " + str(id) + " added")
		var player = Globals.remote_player_scene.instance()
		player.name = Globals.player_instance_name + str(id)
		add_child(player)

func remove_player(id):
	var player = get_node(Globals.player_instance_name + str(id))
	
	if player != null:
		player.queue_free()
		print("Player " + str(id) + " removed")

func set_up(players):
	var player = Globals.remote_player_scene.instance()
	for i in players:
		player.name = str(players[i]["id"])
		player.translation = players[i]["position"]
		add_child(player)
		
