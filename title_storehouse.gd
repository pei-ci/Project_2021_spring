extends Sprite
onready var Data = get_node("/root/Global")
onready var world = get_node("/root/world")
func _ready():
	self.visible=false
	$page_01.visible=true
	$page_02.visible=false

func _on_close_pressed():
	self.visible=false
	world.set_click_function_button_status(true)

func _on_title_storehouse_pressed():
	self.visible=true
	world.set_buttons_visibility(false)
	Data.emit_refresh()


func _on_next_page_pressed():
	if $page_01.visible==true:
		$page_01.visible=false
		$page_02.visible=true
	else:
		$page_01.visible=true
		$page_02.visible=false


func _on_last_page_pressed():
	if $page_02.visible==true:
		$page_02.visible=false
		$page_01.visible=true
	else:
		$page_02.visible=true
		$page_01.visible=false
	
