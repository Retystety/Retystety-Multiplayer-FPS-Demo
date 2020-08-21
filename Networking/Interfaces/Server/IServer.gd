extends Node

puppet func pool_info():
	var parent = get_parent()
	
	if parent.has_method("pool_info"):
		parent.pool_info()
		
func get_info(id):
	rpc_id(id,"pool_info")	

func send_to_add_player(id,player_id):
	rpc_id(id,"add_player",player_id)

puppet func add_player(id):
	var parent = get_parent()
	
	if parent.has_method("add_player"):
		parent.add_player(id)

func add_player_instance(id):
	rpc("add_player",id)

puppet func remove_player(id):
	var parent = get_parent()
	
	if parent.has_method("remove_player"):
		parent.remove_player(id)

func remove_player_instance(id):
	rpc("remove_player",id)

puppet func set_up(players):
	var parent = get_parent()
	
	if parent.has_method("set_up"):
		parent.set_up(players)

func client_set_up(id,players):
	rpc_id(id,"set_up",players)

