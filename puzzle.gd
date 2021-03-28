
extends Sprite

onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
onready var MenuButton = get_node("slect_window/MenuButton/PopupMenu")
#puzzle拼圖
#未拼上的拼圖(預設int)
#遊戲中的狀態紀錄
var position_user
var status_user

#狀態對應選單名稱 在_set_up()內使用到
var button_status={ "11":"puddle_up_grade_1","12":"puddle_up_grade_2","13":"finish",
					"21":"wilderness_up_grade_1","22":"wilderness_up_grade_2","23":"finish",
					"31":"desert_up_grade_1","32":"desert_up_grade_2","33":"finish",
					"41":"sea_up_grade_1","42":"sea_up_grade_2","43":"finish",
					"51":"town_up_grade_1","52":"town_up_grade_2","53":"finish",
					"61":"volcano_up_grade_1","62":"volcano_up_grade_2","63":"finish",
					"00":"default"}
var button_status_cn={"11":"   窪地   ","12":"   沼澤地   ","13":"   已完成   ",
					"21":"   曠原   ","22":"   草原   ","23":"   已完成   ",
					"31":"   綠洲   ","32":"  海市蜃樓  ","33":"   已完成   ",
					"41":"   深海   ","42":"  海底世界  ","43":"   已完成   ",
					"51":"   郊區   ","52":"   都市   ","53":"   已完成   ",
					"61":"   火山錐   ","62":"   火山   ","63":"   已完成   ",
					"00":"  預設  "}
# Called when the node enters the scene tree for the first time.
func _ready():
	#先把所有圖片都隱藏
	$puddle.visible = false
	$wilderness.visible = false
	$desert.visible = false
	$sea.visible = false
	$town.visible = false
	$volcano.visible = false
	_status_set_up()	
	#接收按鈕
	MenuButton.connect("id_pressed",self,"_on_item_pressed")
	#MenuButton.get_popup().connect("id_pressed",self,"_on_item_pressed")
	#選單視窗
	$slect_window.visible=false
	#設定拼圖選單位置
	$slect_window/MenuButton/PopupMenu.rect_global_position = self.position+Vector2(60,-15)
	

func _status_set_up(): #狀態初始設定
	position_user=get_name() #位置和物件名稱相同
	status_user=Data.status_user[position_user]
	
	#選項設定
	if status_user=="00":
		MenuButton.clear()
		MenuButton.add_item("   水坑   ")
		MenuButton.add_item("   荒原   ")
		MenuButton.add_item("   沙漠   ")
		MenuButton.add_item("   淺海   ")
		MenuButton.add_item("   鄉村   ")
		MenuButton.add_item("  地熱口  ")
	else:
		MenuButton.clear()		
		#button_status must edit to match the _on_item_pressed choie
		MenuButton.add_item(button_status_cn[status_user])
	#拼圖圖樣初始化
	if status_user=="11":
		$puddle.visible=true
	if status_user=="12":
		$puddle2.visible=true
	if status_user=="13":
		$puddle3.visible=true
	if status_user=="21":
		$wilderness.visible=true
	if status_user=="22":
		$wilderness2.visible=true
	if status_user=="23":
		$wilderness3.visible=true
	if status_user=="31":
		$desert.visible=true
	if status_user=="32":
		$desert2.visible=true
	if status_user=="33":
		$desert3.visible=true
	if status_user=="41":
		$sea.visible=true
	if status_user=="42":
		$sea2.visible=true
	if status_user=="43":
		$sea3.visible=true
	if status_user=="51":
		$town.visible=true
	if status_user=="52":
		$town2.visible=true
	if status_user=="53":
		$town3.visible=true
	if status_user=="61":
		$volcano.visible=true
	if status_user=="62":
		$volcano2.visible=true
	if status_user=="63":
		$volcano3.visible=true
	

#關於計分方式我沒有研究，就麻煩2幫我寫在visible true後面了
#接收條件，up_grade是什麼你們都懂吧

func _on_item_pressed(id):
	var world = get_node("/root/world")
	var item_name= MenuButton.get_item_text(id)
	if Data.puddle_user>0:
		if item_name=="   水坑   ":	
			world.map_put(Data.block_type["puddle"],get_name())	
			status_user="11"
			Data.puddle_minus(1)
			Data.finished_puzzle_add(1)
			$puddle.visible = true
			MenuButton.clear()
			MenuButton.add_item("   窪地   ")
		if item_name == "   窪地   ":
			world.map_upgrade1(Data.block_type["puddle"],get_name())
			status_user="12"
			Data.puddle_minus(1)
			Data.finished_puzzle_add(1)
			$puddle.visible =false
			$puddle2.visible=true
			MenuButton.clear()
			MenuButton.add_item("   沼澤地   ")
			Data._up_grade_time_add(1) #升級次數+1
		if item_name=="   沼澤地   ":
			world.map_upgrade2(Data.block_type["puddle"],get_name())
			status_user="13"
			Data.puddle_minus(1)
			Data.finished_puzzle_add(1)
			$puddle2.visible =false
			$puddle3.visible=true
			MenuButton.clear()
			MenuButton.add_item("   已完成   ")
			Data._up_grade_time_add(1) #升級次數+1
			Data._full_level_puzzle_num_add(1)
	if Data.wilderness_user>0:
		if item_name=="   荒原   ":
			world.map_put(Data.block_type["wilderness"],get_name())
			status_user="21"
			Data.wilderness_minus(1)
			Data.finished_puzzle_add(1)
			$wilderness.visible = true
			MenuButton.clear()
			MenuButton.add_item("   曠原   ")
		if item_name == "   曠原   ":
			world.map_upgrade1(Data.block_type["wilderness"],get_name())
			status_user="22"
			Data.wilderness_minus(1)
			Data.finished_puzzle_add(1)
			$wilderness.visible =false
			$wilderness2.visible=true
			MenuButton.clear()
			MenuButton.add_item("   草原   ")
			Data._up_grade_time_add(1) #升級次數+1
		if item_name== "   草原   ":
			world.map_upgrade2(Data.block_type["wilderness"],get_name())
			status_user="23"
			Data.wilderness_minus(1)
			Data.finished_puzzle_add(1)
			$wilderness2.visible =false
			$wilderness3.visible=true
			MenuButton.clear()
			MenuButton.add_item("   已完成   ")
			Data._up_grade_time_add(1) #升級次數+1
			Data._full_level_puzzle_num_add(1)
	if Data.desert_user>0:
		if item_name=="   沙漠   ":
			world.map_put(Data.block_type["desert"],get_name())
			status_user="31"
			Data.desert_minus(1)
			Data.finished_puzzle_add(1)
			$desert.visible = true
			MenuButton.clear()
			MenuButton.add_item("   綠洲   ")
		if item_name == "   綠洲   ":
			world.map_upgrade1(Data.block_type["desert"],get_name())
			status_user="32"
			Data.desert_minus(1)
			Data.finished_puzzle_add(1)
			$desert.visible =false
			$desert2.visible=true
			MenuButton.clear()
			MenuButton.add_item("  海市蜃樓  ")
			Data._up_grade_time_add(1) #升級次數+1
		if item_name == "  海市蜃樓  ":
			world.map_upgrade2(Data.block_type["desert"],get_name())
			status_user="33"
			Data.desert_minus(1)
			Data.finished_puzzle_add(1)
			$desert2.visible =false
			$desert3.visible=true
			MenuButton.clear()
			MenuButton.add_item("   已完成   ")
			Data._up_grade_time_add(1) #升級次數+1
			Data._full_level_puzzle_num_add(1)
		
	if Data.sea_user >0:
		if item_name=="   淺海   ":
			world.map_put(Data.block_type["sea"],get_name())
			status_user="41"
			Data.sea_minus(1)
			Data.finished_puzzle_add(1)
			$sea.visible =true
			MenuButton.clear()
			MenuButton.add_item("   深海   ")
		if item_name == "   深海   ":
			world.map_upgrade1(Data.block_type["sea"],get_name())
			status_user="42"
			Data.sea_minus(1)
			Data.finished_puzzle_add(1)
			$sea.visible =false
			$sea2.visible=true
			MenuButton.clear()
			MenuButton.add_item("  海底世界  ")
			Data._up_grade_time_add(1) #升級次數+1
		if item_name == "  海底世界  ":
			world.map_upgrade2(Data.block_type["sea"],get_name())
			status_user="43"
			Data.sea_minus(1)
			Data.finished_puzzle_add(1)
			$sea2.visible =false
			$sea3.visible=true
			MenuButton.clear()
			MenuButton.add_item("   已完成  ")
			Data._up_grade_time_add(1) #升級次數+1
			Data._full_level_puzzle_num_add(1)
	if Data.town_user>0:		
		if item_name=="   鄉村   ":
			world.map_put(Data.block_type["town"],get_name())
			status_user="51"
			Data.town_minus(1)
			Data.finished_puzzle_add(1)
			$town.visible = true
			MenuButton.clear()
			MenuButton.add_item("   郊區   ")
		if item_name == "   郊區   ":
			world.map_upgrade1(Data.block_type["town"],get_name())
			status_user="52"
			Data.town_minus(1)
			Data.finished_puzzle_add(1)
			$town.visible =false
			$town2.visible=true
			MenuButton.clear()
			MenuButton.add_item("   都市   ")
			Data._up_grade_time_add(1) #升級次數+1
		if item_name == "   都市   ":
			world.map_upgrade2(Data.block_type["town"],get_name())
			status_user="53"
			Data.town_minus(1)
			Data.finished_puzzle_add(1)
			$town2.visible =false
			$town3.visible=true
			MenuButton.clear()
			MenuButton.add_item("   已完成   ")
			Data._up_grade_time_add(1) #升級次數+1
			Data._full_level_puzzle_num_add(1)
	if Data.volcano_user>0:
		if item_name=="  地熱口  ":
			world.map_put(Data.block_type["volcano"],get_name())
			status_user="61"
			Data.volcano_minus(1)
			Data.finished_puzzle_add(1)
			$volcano.visible = true
			MenuButton.clear()
			MenuButton.add_item("   火山錐   ")
		if item_name == "   火山錐   ":
			world.map_upgrade1(Data.block_type["volcano"],get_name())
			status_user="62"
			Data.volcano_minus(1)
			Data.finished_puzzle_add(1)
			$volcano.visible =false
			$volcano2.visible=true
			MenuButton.clear()
			MenuButton.add_item("   火山   ")
			Data._up_grade_time_add(1) #升級次數+1
		if item_name == "   火山   ":
			world.map_upgrade2(Data.block_type["volcano"],get_name())
			status_user="63"
			Data.volcano_minus(1)
			Data.finished_puzzle_add(1)
			$volcano2.visible =false
			$volcano3.visible=true
			MenuButton.clear()
			MenuButton.add_item("   已完成   ")
			Data._up_grade_time_add(1) #升級次數+1
			Data._full_level_puzzle_num_add(1)
	Data.status_user[position_user]=status_user
	Data.emit_refresh()
func get_status():
	return status_user
func get_position():
	return position_user

func _on_Timer_timeout():
	pass



func _on_slect_window_button_pressed():
	Data.slect_button_opened=true
	if $slect_window.visible==false:
		$slect_window.visible=true
		yield(get_tree().create_timer(7), "timeout")#選單視窗開啟5秒後關閉
		Data.slect_button_opened=false
		$slect_window.visible=false
		$slect_window/MenuButton/PopupMenu.visible=false
	else:
		$slect_window.visible=false


func _on_slect_window_button_mouse_entered():
	
	if Data.slect_button_opened==true and $slect_window.visible==false:
		$slect_window_button.visible=false
		yield(get_tree().create_timer(5), "timeout")#選單視窗開啟5秒後關閉
		$slect_window_button.visible=true
		
	pass # Replace with function body.


func _on_activity_button_pressed():
	Data.emit_slect_window_open()





func _on_MenuButton_pressed():
	$slect_window/MenuButton/PopupMenu.visible=true
	yield(get_tree().create_timer(7), "timeout")
	$slect_window/MenuButton/PopupMenu.visible=false


func _on_PopupMenu_id_pressed(id):
	$slect_window.visible=false
