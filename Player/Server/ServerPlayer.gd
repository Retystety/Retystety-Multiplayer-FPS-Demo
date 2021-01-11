extends KinematicBody

var id = 0
var motion = Vector3()

var move = Vector3()
var dir = Vector2()
var jump = false
var key = 0


onready var Xaxis = $RotateX


func _ready():
	set_network_master(1)
	add_to_group("update")

func update():
	rpc_unreliable("set_physics",translation,motion,dir,key)

func _physics_process(delta):
	process_input(dir)
	motion = Globals.process_movment(move,jump,is_on_floor(),motion,delta)
	motion = move_and_slide(motion,Vector3(0,1,0))


func process_input(dir):
	
	self.rotation_degrees.y = dir.y
	Xaxis.rotation_degrees.x = clamp(dir.x,-Globals.max_elevation,Globals.max_elevation)

