extends Node

puppet func send_inputs(move,dir,jump,key):
	var parent = get_parent()
	
	if parent.has_method("send_inputs"):
		parent.send_inputs(self,move,dir as Vector2,jump,key)

puppet func send_actions(use):
	var parent = get_parent()
	
	if parent.has_method("send_actions"):
		parent.send_actions(self,use)

puppet func send_info(name):
	var parent = get_parent()
	
	if parent.has_method("send_info"):
		parent.send_info(self,name as String)

func set_inputs(move,dir,jump,key):
	rpc_unreliable_id(1,"send_inputs",move,dir,jump,key)

func reply(use):
	rpc_id(1,"send_actions",use)

func reply_info(name):
	rpc_id(1,"send_info",name)
	
