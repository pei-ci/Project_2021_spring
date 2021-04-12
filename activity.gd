extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
#var act=[{"活動名稱":"突發事件","時間":"3/12"},{"活動名稱":"社團活動","時間":"5/10"},{"活動名稱":"","時間":""},{"活動名稱":"","時間":""},{"活動名稱":"","時間":""},{"活動名稱":"","時間":""},{"活動名稱":"","時間":""},{"活動名稱":"","時間":""},{"活動名稱":"","時間":""},{"活動名稱":"111","時間":"3/13"}]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var activity_list=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	$page_01.visible=false
	$page_02.visible=false
	$page_03.visible=false
	$page_04.visible=false
	
var page_map={"1":"page_01","2":"page_02","3":"page_03","4":"page_04"}
func _set_up(activity_info):
	$page_01.text="此頁無活動紀錄(第一頁)"
	$page_02.text="此頁無活動紀錄(第二頁)"
	$page_03.text="此頁無活動紀錄(第三頁)"
	$page_04.text="此頁無活動紀錄(第四頁)"
	if activity_info!=[]:
		$page_01.text=""
	var current_page=1
	for activity in activity_info:
		if get_node(page_map[str(current_page)]).get_visible_line_count()>=7:
			current_page= current_page +1
			get_node(page_map[str(current_page)]).text=""
			if current_page>4:
				break
		#有需要跳過的內容的話 可以更改底下這個條件來使用
		get_node(page_map[str(current_page)]).text+=activity+"\n"
		

func _on_last_page_button_pressed():
	if $page_01.visible==true:
		$page_01.visible=false
		$page_04.visible=true
	elif $page_02.visible==true:
		$page_02.visible=false
		$page_01.visible=true
	elif $page_03.visible==true:
		$page_03.visible=false
		$page_02.visible=true
	elif $page_04.visible==true:
		$page_04.visible=false
		$page_03.visible=true
	
	
	
func _on_next_page_button_pressed():
	if $page_01.visible==true:
		$page_01.visible=false
		$page_02.visible=true
	elif $page_02.visible==true:
		$page_02.visible=false
		$page_03.visible=true
	elif $page_03.visible==true:
		$page_03.visible=false
		$page_04.visible=true
	elif $page_04.visible==true:
		$page_04.visible=false
		$page_01.visible=true


func _on_close_pressed():
	var world = get_node("/root/world")
	world.set_buttons_visibility(true)
	self.visible=false


func _on_activity_button_pressed():
	var world = get_node("/root/world")
	world.set_buttons_visibility(false)
	Data.emit_activity_window_open()
