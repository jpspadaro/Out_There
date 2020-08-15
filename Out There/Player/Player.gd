extends KinematicBody

# Ripped a lot of this from here:
# https://github.com/codewithtom/godot-fps/blob/lesson-1/Player/Player.gd
# It's a starting point with the basics, and MIT license. *shrug*
# Going to look radically different in the not too distant future...

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0
var Mouselook = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Mouselook:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):

		Mouselook = !Mouselook
		if Mouselook:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if !Mouselook:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if Input.is_action_pressed("ui_up"):
		direction -= head_basis.z
	elif Input.is_action_pressed("ui_down"):
		direction += head_basis.z
	
	if Input.is_action_pressed("ui_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("ui_right"):
		direction += head_basis.x
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y += jump_power
	
	velocity = move_and_slide(velocity, Vector3.UP)
