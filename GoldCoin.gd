extends Area


export var goldToGive : int = 10
var rotateSpeed : float = 5.0

# called every frame
func _process (delta):
	# rotate along the Y axis
	rotate_y(rotateSpeed * delta)


func _on_GoldCoin_body_entered(body):
	if body.name == "Player":
		body.give_gold(goldToGive)
		queue_free()
