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
	process_input(dir,jump)
	process_movment(move,delta)


func process_input(dir,jump):
	
	if jump:
		jump = false
		if is_on_floor():
			motion.y = Globals.jump_speed
		
	self.rotation_degrees.y = dir.y
	Xaxis.rotation_degrees.x = dir.x

func process_movment(input,delta):
	input.y = 0
	input = input.normalized()
	
	motion.y += delta * Globals.g
	
	var hmotion = motion
	hmotion.y = 0
	
	var target = input
	target *= Globals.max_speed
	
	var a
	if input.dot(hmotion) > 0:
		a = Globals.acceleration
	else:
		a = Globals.drag
	
	hmotion = hmotion.linear_interpolate(target, a * delta)
	
	motion.x = hmotion.x
	motion.z = hmotion.z
	
	
	
	motion = move_and_slide(motion,Vector3(0,1,0))

