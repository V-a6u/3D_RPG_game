extends KinematicBody


# stats
var curHp : int = 3
var maxHp : int = 3

# attacking
var damage : int = 1
var attackDist : float = 1.5
var attackRate : float = 1.0

# physics
var moveSpeed : float = 5.0

# vectors
var vel : Vector3 = Vector3()

#components
onready var timer = get_node("Timer")
onready var player = get_node("/root/MainScene/Player")

func _ready():
	timer.wait_time = attackRate
	timer.start()


func _on_Timer_timeout():
	
	#if within attacking distance - attack the player
	if translation.distance_to(player.translation) <= attackDist:
		player.take_damage(damage)


func _physics_process(delta):
	
	#distance from player
	var dist = translation.distance_to(player.translation)
	
	#if we are outside attack distance, chase the player
	if dist > attackDist:
		#direction to player
		var dir = (player.translation - translation).normalized()
		
		vel.x = dir.x
		vel.y = 0
		vel.z = dir.z
		
		# move towards the player
		vel = move_and_slide(vel, Vector3.UP)
		
func take_damage(damageToTake):
	
	curHp -= damageToTake
	
	if curHp <= 0:
		die()
		
func die():
	queue_free()
