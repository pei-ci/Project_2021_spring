extends Sprite

onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
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
	$MenuButton.get_popup().connect("id_pressed",self,"_on_item_pressed")
	
	

func _status_set_up(): #狀態初始設定
	position_user=get_name() #位置和物件名稱相同
	status_user=Data.status_user[position_user]
	
	#選項設定
	if status_user=="00":
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("puddle")
		$MenuButton.get_popup().add_item("wilderness")
		$MenuButton.get_popup().add_item("desert")
		$MenuButton.get_popup().add_item("sea")
		$MenuButton.get_popup().add_item("town")
		$MenuButton.get_popup().add_item("volcano")
	else:
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item(button_status[status_user])
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
#還有，圖片記得要換，不然會很鬧
#接收條件，up_grade是什麼你們都懂吧
func _on_item_pressed(id):
	var item_name= $MenuButton.get_popup().get_item_text(id)
	if Data.puddle_user>0:
		if item_name=="puddle":
			status_user="11"
			Data.puddle_user -= 1
			Data.finished_puzzle_user +=1
			$puddle.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("puddle_up_grade_1")
		if item_name == "puddle_up_grade_1":
			status_user="12"
			Data.puddle_user -= 1
			Data.finished_puzzle_user +=1
			$puddle.visible =false
			$puddle2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("puddle_up_grade_2")
		if item_name=="puddle_up_grade_2":
			status_user="13"
			Data.puddle_user -= 1
			Data.finished_puzzle_user +=1
			$puddle2.visible =false
			$puddle3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if Data.wilderness_user>0:
		if item_name=="wilderness":
			status_user="21"
			Data.wilderness_user -= 1
			Data.finished_puzzle_user +=1
			$wilderness.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("wilderness_up_grade_1")
		if item_name == "wilderness_up_grade_1":
			status_user="22"
			Data.wilderness_user -= 1
			Data.finished_puzzle_user +=1
			$wilderness.visible =false
			$wilderness2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("wilderness_up_grade_2")
		if item_name== "wilderness_up_grade_2":
			status_user="23"
			Data.wilderness_user -= 1
			Data.finished_puzzle_user +=1
			$wilderness2.visible =false
			$wilderness3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if Data.desert_user>0:
		if item_name=="desert":
			status_user="31"
			Data.desert_user -= 1
			Data.finished_puzzle_user +=1
			$desert.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("desert_up_grade_1")
		if item_name == "desert_up_grade_1":
			status_user="32"
			Data.dessert_user -= 1
			Data.finished_puzzle_user +=1
			$desert.visible =false
			$desert2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("desert_up_grade_2")
		if item_name == "desert_up_grade_2":
			status_user="33"
			Data.dessert_user -= 1
			Data.finished_puzzle_user +=1
			$desert2.visible =false
			$desert3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
		
	if Data.sea_user >0:
		if item_name=="sea":
			status_user="41"
			Data.sea_user -= 1
			Data.finished_puzzle_user +=1
			$sea.visible =true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("sea_up_grade_1")
		if item_name == "sea_up_grade_1":
			status_user="42"
			Data.sea_user -= 1
			Data.finished_puzzle_user +=1
			$sea.visible =false
			$sea2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("sea_up_grade_2")
		if item_name == "sea_up_grade_2":
			status_user="43"
			Data.sea_user -= 1
			Data.finished_puzzle_user +=1
			$sea2.visible =false
			$sea3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if Data.town_user>0:		
		if item_name=="town":
			status_user="51"
			Data.town_user -= 1
			Data.finished_puzzle_user +=1
			$town.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("town_up_grade_1")
		if item_name == "town_up_grade_1":
			status_user="52"
			Data.town_user -= 1
			Data.finished_puzzle_user +=1
			$town.visible =false
			$town2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("town_up_grade_2")
		if item_name == "town_up_grade_2":
			status_user="53"
			Data.town_user -= 1
			Data.finished_puzzle_user +=1
			Data.finished_puzzle_user +=1
			$town2.visible =false
			$town3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if Data.volcano_user>0:
		if item_name=="volcano":
			status_user="61"
			Data.volcano_user -= 1
			Data.finished_puzzle_user +=1
			$volcano.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("volcano_up_grade_1")
		if item_name == "volcano_up_grade_1":
			status_user="62"
			Data.volcano_user -= 1
			Data.finished_puzzle_user +=1
			$volcano.visible =false
			$volcano2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("volcano_up_grade_2")
		if item_name == "volcano_up_grade_2":
			status_user="63"
			Data.volcano_user -= 1
			Data.finished_puzzle_user +=1
			$volcano2.visible =false
			$volcano3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	Data.status_user[position_user]=status_user
	Data.emit_refresh()
			
func get_status():
	return status_user
func get_position():
	return position_user

func _on_Timer_timeout():
	pass
