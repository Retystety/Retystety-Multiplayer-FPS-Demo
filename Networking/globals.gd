extends Node

const PORT = 4242


const g = -100
const max_speed = 20
const jump_speed = 20
const acceleration = 20
const drag = 15
const max_elevation = 80

func process_movment(input,jump,is_on_floor,motion,delta) -> Vector3:
	input.y = 0
	input = input.normalized()
	
	motion.y += delta * g
	
	if jump && is_on_floor:
		motion.y += jump_speed
	
	var hmotion = motion
	hmotion.y = 0
	
	var target = input
	target *= max_speed
	
	var a
	if input.dot(hmotion) > 0:
		a = Globals.acceleration
	else:
		a = Globals.drag

	hmotion = hmotion.linear_interpolate(target, a * delta)
	
	motion.x = hmotion.x
	motion.z = hmotion.z
	
	return motion


const manager_name = "Manager"
const server_interface_name = "IServer"
const player_interface_name = "IPlayer"
const player_instance_name = "Player"

const server_scene = preload("res://Networking/Server/Server.tscn")
const client_scene = preload("res://Networking/Client/Client.tscn")

const server_interface_scene = preload("res://Networking/Interfaces/Server/IServer.tscn")
const player_interface_scene = preload("res://Networking/Interfaces/Player/IPlayer.tscn")

const server_player_scene = preload("res://Player/Server/ServerPlayer.tscn")
const remote_player_scene = preload("res://Player/Remote/RemotePlayer.tscn")

	

