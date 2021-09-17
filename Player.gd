extends KinematicBody

# stats
var curHp : int = 10
var maxHp : int = 10
var damage : int = 1

var gold : int = 0

var attackRate : float = 0.3
var lastAttackTime : int = 0

# physics
var moveSpeed : float = 7.5
var jumpForce : float = 10.0
var gravity : float = 15.0

var vel = Vector3()

onready var camera : Spatial = get_node("CameraOrbit")
onready var attackCast : RayCast = get_node("AttackRayCast")
onready var swordAnim = get_node("WeaponHolder/SwordAnimator")
onready var ui = get_node("/root/MainScene/CanvasLayer/UI")

func _ready():
	ui.update_health_bar(curHp, maxHp)
	ui.update_gold_text(gold)

func _physics_process(delta):
	
	vel.x = 0
	vel.z = 0
	
	var input = Vector3()
	
	#movement inputs
	if Input.is_action_pressed("move_forwards"):
		input.z += 1
	if Input.is_action_pressed("move_backwards"):
		input.z -= 1
	if Input.is_action_pressed("move_left"):
		input.x += 1
	if Input.is_action_pressed("move_right"):
		input.x -= 1
		
	input = input.normalized()	
	
	#relative direction
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	
	#apply direction to velocity
	vel.x = dir.x * moveSpeed
	vel.z = dir.z * moveSpeed
	
	#gravity
	vel.y -= gravity * delta
	
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		
	#move along the current velocity
	vel = move_and_slide(vel, Vector3.UP)
	
#when collect coin
func give_gold(amount):
	gold += amount
	
	ui.update_gold_text(gold)
	
func take_damage(dmgToTake):
	curHp -= dmgToTake
	ui.update_health_bar(curHp, maxHp)
	
	if curHp <= 0:
		die()
		
func die():
	queue_free()
	
	get_tree().reload_current_scene()
	
func _process(delta):
	
	if Input.is_action_just_pressed("attack"):
		try_attack()

#when pressed attack		
func try_attack():
	
	#if we are ready to attack - fire rate
	if OS.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return
	
	# set the last attack time to now
	lastAttackTime = OS.get_ticks_msec()
	
	#play the animation
	swordAnim.stop()
	swordAnim.play("attack")
	
	# is the ray cast colliding with an enemy?
	if attackCast.is_colliding():
		if attackCast.get_collider().has_method("take_damage"):
			attackCast.get_collider().take_damage(damage)
