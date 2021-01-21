extends Sprite

func _ready():
	$background.visible = false
	$close.visible = false
	pass # Replace with function body.


signal timer_continue
func _on_close_pressed():
	$background.visible = false
	$close.visible = false
	emit_signal("timer_continue")
	


func _on_Button_pressed():
	$background.visible = true
	$close.visible = true
	pass # Replace with function body.


func _on_Button2_pressed():
	$background.visible = true
	$close.visible = true
	pass # Replace with function body.



func _on_Button_emergency_pressed():
	$background.visible = true
	$close.visible = true

