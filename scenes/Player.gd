extends KinematicBody2D

var local_player = true
var speed = 150
var direction = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

remote func _set_position(pos):
	global_transform.origin = pos
	
func _physics_process(delta):
	direction = Vector2()
	
	if(Input.is_action_pressed('move_left')):
		direction += Vector2(-1, 0)
	if(Input.is_action_pressed('move_right')):
		direction += Vector2(1, 0)
	if(Input.is_action_pressed('move_up')):
		direction += Vector2(0, -1)
	if(Input.is_action_pressed('move_down')):
		direction += Vector2(0, 1)
	
	if direction != Vector2():
		if local_player || is_network_master():
			move_and_slide(direction * speed, Vector2.UP)
		if !local_player:
			rpc_unreliable('_set_position', global_transform.origin)
