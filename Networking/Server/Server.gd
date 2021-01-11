extends Node

var tick_rate = 60
var input_rate = 1
var max_valid_ping = 0

var players = {}
var interfaces = {}
var instances = {}

var names = {}
var id_form_name = {}
var server_interface

var players_count = 0

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	
	server_interface = Globals.server_interface_scene.instance()
	server_interface.set_network_master(1)
	server_interface.name = Globals.server_interface_name
	add_child(server_interface)
	server_interface = get_node(server_interface.name)


func _physics_process(delta):
	
	var update_nodes = get_tree().get_nodes_in_group("update")
	for node in update_nodes:
		if node.has_method("update"):
			node.update()


var tick_timer = 0
var delay = 1.0 / tick_rate

func update(delta):
	if tick_timer >= delay:
		tick_timer = 0
		
		var update_nodes = get_tree().get_nodes_in_group("update")
		for node in update_nodes:
			if node.has_method("update"):
				node.update()
	else:
		tick_timer += delta


func _player_connected(id):
	players_count += 1
	print("Player count: " + str(players_count))
	
	print("Player " + str(id) + " connected")
	var player_interface = Globals.player_interface_scene.instance()
	player_interface.set_network_master(id)
	player_interface.name = Globals.player_interface_name + str(id)
	add_child(player_interface)
	players[id] = get_node(player_interface.name)
	interfaces[players[id]] = id
	server_interface.get_info(id)
	
	for player in players:
		server_interface.send_to_add_player(id,player)

func _player_disconnected(id):
	players_count -= 1
	print("Player count: " + str(players_count)) 
	  
	print("Player " + str(id) + " disconnected")
	remove_player_instance(id)
	id_form_name.erase(names[id])
	names.erase(id)
	interfaces.erase(players[id])
	players[id].queue_free()
	players.erase(id)

func send_actions(interface,use):
	pass
		

func send_inputs(interface,move,dir,jump,key):
	var id = interfaces[interface]
	var player = get_node(Globals.player_instance_name + str(id))
	
	if player != null:
		
		player.move = move.normalized()
		player.dir = dir
		player.jump = jump
		player.key = key


func send_info(interface,name : String):
	if !names.has(interfaces[interface]):
		if !id_form_name.has(name):
			names[interfaces[interface]] = name
			id_form_name[name] = interfaces[interface]
			print("Player " + str(interfaces[interface]) +  " disguised as " + name)
			add_player_instance(interfaces[interface])
			
		else:
			name += "@"
			send_info(interface,name)

func add_player_instance(id):
	var player = Globals.server_player_scene.instance()
	player.name = Globals.player_instance_name + str(id)
	server_interface.add_player_instance(id)
	add_child(player)
	instances[id] = get_node(player.name)

func remove_player_instance(id):
	var player = instances[id]
	if player != null:
		server_interface.remove_player_instance(id)
		player.queue_free()
		instances.erase(id)
