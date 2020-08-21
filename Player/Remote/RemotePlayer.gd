extends StaticBody

var interpolation_time = 0.05

onready var Xaxis = $RotateX

var target = Vector3()
var current = Vector3()

func _ready():
	set_network_master(1)
	

var timer = 0 
func _process(delta):
	timer += delta
	translation = current + ((target - current) * (min(timer,interpolation_time)/interpolation_time))

	
puppet func set_physics(position,motion,dir,key):
	timer = 0
	target = position
	current = translation
	self.rotation_degrees.y = dir.y
	Xaxis.rotation_degrees.x = dir.x
	
	
