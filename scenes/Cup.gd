extends Node2D
var _pos_index = -1

func open():
	$Close.hide()
	$Open.show()
	
func close():
	$Close.show()
	$Open.hide()
	
func get_my_position()->Vector2:
	if _pos_index < 0:
		return Vector2(0, 0)
	return StaticData.cup_positions[_pos_index]
	
func move(new_pos_index):
	_pos_index = new_pos_index
	if $Tween.is_active():
		$Tween.stop(self)
	$Tween.interpolate_property(self, 'global_position', global_position, get_my_position(), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()
	

