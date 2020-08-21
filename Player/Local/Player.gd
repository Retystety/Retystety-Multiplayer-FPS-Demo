extends KinematicBody

var acknowledged = false

const min_interpolation_distance = 0.1
const interpolation_scale = 10

var server_side_position = Vector3()
var server_side_velocity = Vector3()

var input = Vector3()
var queued_input = Vector3()
var local_dir = Vector2()
var jump = false


var motion = Vector3()
const sens = 0.2

const max_key_time = 0.5
const key_range = 1000
var keys = {}


onready var Xaxis = $RotateX
onready var Client = get_parent()


func _ready():
	name = Globals.player_instance_name + str(get_tree().get_network_unique_id())
	set_network_master(1)

puppet func set_physics(position,move,dir,key):
	
	if keys.has(key):
		var dist = position - keys[key]["position"]
		if dist.length() >= min_interpolation_distance:
			speed = dist * interpolation_scale
		else:
			speed = Vector3()
		
		keys.erase(key)
		
	

var input_timer = 0
var trans = Vector3()
var speed = Vector3()
func _physics_process(delta):
	
	if acknowledged:
		input = get_input(delta)
		
		var new_key = randi() % key_range
		
		keys[new_key] = {"delta": delta, "position": translation, "motion": motion}
		
		if jump && is_on_floor():
			motion.y = Globals.jump_speed
	
		Client.set_inputs(input,local_dir,jump,translation,new_key)
		jump = false
		
			
		process_movment(input,delta)
			
			
		for key in keys:
			keys[key]["delta"] += delta
				
			if keys[key]["delta"] >= max_key_time:
				keys.erase(key)
	

	

func get_input(delta) -> Vector3:
	
	var dir = Vector3(0,0,0)
	var xform = Xaxis.global_transform
	var input = Vector2(0,0)
	
	if Input.is_action_pressed("forward"):
		input.y += 1
	if Input.is_action_pressed("backward"):
		input.y -= 1
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	
	input = input.normalized()
	
	dir += -xform.basis.z * input.y
	dir += xform.basis.x * input.x
	
	if Input.is_action_just_pressed("jump"):
		jump = true
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

	return dir

func process_movment(input,delta):
	input.y = 0
	input = input.normalized()
	
	motion -= speed 
	
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
	
	motion = move_and_slide(motion + speed,Vector3(0,1,0))
	
func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Xaxis.rotate_x(deg2rad(event.relative.y * sens * -1))
		self.rotate_y(deg2rad(event.relative.x * sens * -1))
		Xaxis.rotation_degrees.x = clamp(Xaxis.rotation_degrees.x,-80,80)
		
		local_dir = Vector2(Xaxis.rotation_degrees.x,rotation_degrees.y)
