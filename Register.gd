extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$department.add_item("csie")
	$department.add_item("im")

func _on_OK_Button_pressed():
	if ($name.text!='' && ($nickname.text!='' && $department.selected!=-1)):
		var control = get_node("/root/login")
		control.register_to_server($name.text,$nickname.text,$department.text)
	$Register.visible = false
