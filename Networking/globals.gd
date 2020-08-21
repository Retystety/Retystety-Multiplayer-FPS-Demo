extends Node

const PORT = 4242

const g = -50
const max_speed = 20
const jump_speed = 15
const acceleration = 20
const drag = 15
const max_angle = 45

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

	

