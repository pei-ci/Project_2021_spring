extends Sprite


func _ready():
	$background.visible=false
	$close.visible=false
	$close_picture.visible=false
	$switch.visible=false
	$switch_picture.visible=false
	$person_text.visible=false
	$team_text.visible=false




func _on_close_pressed():
	$background.visible=false
	$close.visible=false
	$close_picture.visible=false
	$switch_picture.visible=false
	$person_text.visible=false
	$team_text.visible=false
	
	pass # Replace with function body.


func _on_switch_pressed():
	if $person_text.visible==true:
		$person_text.visible=false
		$team_text.visible=true
	else:
		$team_text.visible=false
		$person_text.visible=true
