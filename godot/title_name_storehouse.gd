extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數



# Called when the node enters the scene tree for the first time.
func _ready():
	$title_name.text=Data.title_list[get_name()]
	Data.connect("refresh",self,"_set_up")


func _set_up():
	if Data.title_status[get_name()]:
		$bright_picture.visible=true
		$gray_picture.visible=false
	else:
		$bright_picture.visible=false
		$gray_picture.visible=true
#func _process(delta):
#	pass

