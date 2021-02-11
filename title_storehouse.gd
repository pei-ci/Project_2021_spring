extends Sprite
onready var Data = get_node("/root/Global")
func _ready():
	$background.visible=false
	$close.visible=false
	$close_picture.visible=false
	$page_01.visible=false
	$page_02.visible=false
	$next_page.visible=false
	$last_page.visible=false

func _on_close_pressed():
	$background.visible=false
	$close.visible=false
	$close_picture.visible=false
	$page_01.visible=false
	$page_02.visible=false
	$next_page.visible=false
	$last_page.visible=false

func _on_title_storehouse_pressed():
	$background.visible=true
	$close.visible=true
	$close_picture.visible=true
	$page_01.visible=true
	$next_page.visible=true
	$last_page.visible=true
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
	
