extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$department.add_item("csie")
	$department.add_item("im")
	reset_text()

func reset_text():
	$DepartmentLabel.text = 'Press to choose department'
	$NameLabel.text = ''
	$NicknameLabel.text = ''	

func _on_OK_pressed():
	var control = get_node("/root/login")	
	if((len($name)>=2 && len($name)<20)&& ($nickname.text!='' && $department.selected!=-1)):
		control.register_to_server($name.text,$nickname.text,$department.text)
		visible = false


func _on_ExitButton_pressed():	
	visible = false
	reset_text()

func _on_name_text_changed(new_text):
	$NameLabel.text = new_text

func _on_nickname_text_changed(new_text):
	$NicknameLabel.text = new_text

func _on_department_item_selected(index):
	$DepartmentLabel.text = str(index)
