extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$department.add_item("csie")
	$department.add_item("im")

func _on_OK_pressed():
	var control = get_node("/root/login")
	if ($name.text!='' && ($nickname.text!='' && $department.selected!=-1)):
		control.register_to_server($name.text,$nickname.text,$department.text)
		visible = false


func _on_ExitButton_pressed():
	visible = false
