extends Control


onready var healthBar = get_node("HealthBar")
onready var goldText = get_node("GoldText")

func update_health_bar (curHp, maxHp):
	healthBar.value = (100 / maxHp) * curHp
	
func update_gold_text (gold):
	goldText.text = "Gold: " + str(gold)
