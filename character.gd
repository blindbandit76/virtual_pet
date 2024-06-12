extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer

var pet_state : int = STATE.IDLE

#signals to send when entering and leaving states
signal walking
signal finished_walking

enum STATE{
	IDLE,
	LOOKAROUND,
	WALK,
	SLEEP,
}

func _ready():
	pet_state = STATE.LOOKAROUND
	sprite.play("look_around")
	timer.start()

func _on_timer_timeout():
	if pet_state == STATE.WALK:
		finished_walking.emit()
	
	await change_state()
	#Timer can change according to state and is random
	match pet_state:
		STATE.IDLE :
			timer.set_wait_time(randi_range(10, 200))
			sprite.play("idle")
		STATE.LOOKAROUND :
			timer.set_wait_time(randi_range(10, 200))
			sprite.play("look_around")
		STATE.WALK :
			timer.set_wait_time(randi_range(5, 60))
			sprite.play("walk")
		STATE.SLEEP :
			timer.set_wait_time(randi_range(300, 1000))
			sprite.play("sleep")
	timer.start()

func change_state():
	pet_state = randi_range(0,3)
	if pet_state == STATE.WALK:
		walking.emit()
