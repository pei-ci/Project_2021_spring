extends Sprite

func _ready():
	$background.visible = false
	$close.visible = false
	pass # Replace with function body.

func _on_close_pressed():
	$background.visible = false
	$close.visible = false


func _on_menu1_pressed():
	$background.visible = true
	$close.visible = true
	pass # Replace with function body.




func _on_menu2_pressed():
	$background.visible = true
	$close.visible = true
	pass # Replace with function body.
