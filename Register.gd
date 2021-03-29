extends Sprite

onready var Data = get_node("/root/Global")
# Called when the node enters the scene tree for the first time.
func _ready():
	reset_text()
	_setup_department()

func reset_text():
	$DepartmentLabel.text = 'Press to choose department'
	$NameLabel.text = ''
	$NicknameLabel.text = ''	

func _on_OK_pressed():
	var control = get_node("/root/login")	
	if((len($name.text)>=2 && len($name.text)<20)&& ($nickname.text!='' && $department.selected!=-1)):
		control.register_to_server($name.text,$nickname.text,$department.text)
		# there is an error which return only 0, need to fix
		visible = false


func _on_ExitButton_pressed():	
	visible = false
	reset_text()

func _on_name_text_changed(new_text):
	$NameLabel.text = new_text

func _on_nickname_text_changed(new_text):
	$NicknameLabel.text = new_text

func _on_department_item_selected(index):
	$DepartmentLabel.text = Data.department_list[index]
	
func _setup_department():
	for item in Data.department_list:
		$department.add_item(item)	
	
