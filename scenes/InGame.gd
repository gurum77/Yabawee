extends Node2D


var cup = preload("res://scenes/Cup.tscn")

func start():
	$MixingTimer.start()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	init_cup_positions()
	
	# 컵 생성
	make_cups()
	
	
func make_cups():
	var idx = 0
	for pos in StaticData.cup_positions:
		if pos is Vector2:
			var new_cup = cup.instance()
			$Cups.add_child(new_cup)
			new_cup.move(idx)
			idx += 1
			
			
	
func init_cup_positions():
	# 컵 위치 보관
	var positions = $CupPositions.get_children()
	for pos in positions:
		if pos is Node2D:
			StaticData.cup_positions.append(pos.global_position)
			
# 시간 마다 컵을 섞는다.	
func _on_MixingTimer_timeout():
	# 컵의 새로운 위치
	var new_position = get_new_position()
	var cups = $Cups.get_children()
	cups[0].move(new_position.x)
	cups[1].move(new_position.y)
	cups[2].move(new_position.z)
	
func is_up_in_random()->bool:
	randomize()
	var num = randi() % 2
	if num == 0:
		return false
	return true
	
func get_new_position()->Vector3:
	randomize()
	var pos1 = randi() % 3
	var pos2 = 1
	if is_up_in_random():
		pos2 = pos1 + 1
	else:
		pos2 = pos1 - 1
		
	if pos2 < 0:
		pos2 = 2
	if pos2 > 2:
		pos2 = 0

	var pos3 = 2
	if pos1 != 0 && pos2 != 0:
		pos3 = 0
	elif pos1 != 1 && pos2 != 1:
		pos3 = 1
	else:
		pos3 = 2
	return Vector3(pos1, pos2, pos3)
