extends Spatial


# look stats
var lookSensitivity : float = 15.0
var joyStickLookSensitivity : float = 10.0
var minLookAngle : float = -20.0
var maxLookAngle : float = 75.0

var mouseDelta = Vector2()

onready var player = get_parent()


func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		

func _process(delta):
	
	#get the rotation
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta

	#camera vertical rotation
	rotation_degrees.x += rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	
	#player horizontal rotation
	player.rotation_degrees.y -= rot.y
	
	# clear the mouse movement vector
	mouseDelta = Vector2()
	
	#joystick look around
	#rotate_x(Input.get_action_strength("look_up") * joyStickLookSensitivity * delta)
	#rotate_x(Input.get_action_strength("look_down") * joyStickLookSensitivity * delta * -1)
	#rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	player.rotate_y(Input.get_action_strength("look_left") * joyStickLookSensitivity * delta)
	player.rotate_y(Input.get_action_strength("look_right") * joyStickLookSensitivity * delta * -1)

#capture mouse
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
