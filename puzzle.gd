extends Sprite

#load狀態(預設str)
var position_load="AA00"
var status_load="00"
#puzzle拼圖
#未拼上的拼圖(預設int)
#遊戲中的狀態紀錄
var position_user
var status_user
#未拼上的拼圖
var puddle_user
var wilderness_user
var desert_user
var sea_user
var town_user
var volcano_user

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
	
	

func _status_set_up():
	position_user=position_load
	status_user=status_load
	
	#選項設定
	if status_load=="00":
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("puddle")
		$MenuButton.get_popup().add_item("wilderness")
		$MenuButton.get_popup().add_item("desert")
		$MenuButton.get_popup().add_item("sea")
		$MenuButton.get_popup().add_item("town")
		$MenuButton.get_popup().add_item("volcano")
	else:
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item(button_status[status_load])
	#拼圖圖樣初始化
	if status_load=="11":
		$puddle.visible=true
	if status_load=="12":
		$puddle2.visible=true
	if status_load=="13":
		$puddle3.visible=true
	if status_load=="21":
		$wilderness.visible=true
	if status_load=="22":
		$wilderness2.visible=true
	if status_load=="23":
		$wilderness3.visible=true
	if status_load=="31":
		$desert.visible=true
	if status_load=="32":
		$desert2.visible=true
	if status_load=="33":
		$desert3.visible=true
	if status_load=="41":
		$sea.visible=true
	if status_load=="42":
		$sea2.visible=true
	if status_load=="43":
		$sea3.visible=true
	if status_load=="51":
		$town.visible=true
	if status_load=="52":
		$town2.visible=true
	if status_load=="53":
		$town3.visible=true
	if status_load=="61":
		$volcano.visible=true
	if status_load=="62":
		$volcano2.visible=true
	if status_load=="63":
		$volcano3.visible=true
	
func get_unfinished_puzzle_current():
	puddle_user=1#get_tree().get_root().get_node("world").get_unfinished_puzzle("puddle")
	wilderness_user=1
	desert_user=1
	sea_user=1
	town_user=1
	volcano_user=1


#關於計分方式我沒有研究，就麻煩2幫我寫在visible true後面了
#還有，圖片記得要換，不然會很鬧
#接收條件，up_grade是什麼你們都懂吧
signal reflash(position_user)
func _on_item_pressed(id):
	var item_name= $MenuButton.get_popup().get_item_text(id)
	get_unfinished_puzzle_current()
	if puddle_user>0:
		if item_name=="puddle":
			status_user="11"
			#get_parent().decrease_unfinished_puzzle("puddle")
			$puddle.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("puddle_up_grade_1")
		if item_name == "puddle_up_grade_1":
			status_user="12"
			#get_parent().decrease_unfinished_puzzle("puddle")
			$puddle.visible =false
			$puddle2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("puddle_up_grade_2")
		if item_name=="puddle_up_grade_2":
			status_user="13"
			#get_parent().decrease_unfinished_puzzle("puddle")
			$puddle2.visible =false
			$puddle3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if wilderness_user>0:
		if item_name=="wilderness":
			status_user="21"
			#get_parent().decrease_unfinished_puzzle("wilderness")
			$wilderness.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("wilderness_up_grade_1")
		if item_name == "wilderness_up_grade_1":
			status_user="22"
			#get_parent().decrease_unfinished_puzzle("wilderness")
			$wilderness.visible =false
			$wilderness2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("wilderness_up_grade_2")
		if item_name== "wilderness_up_grade_2":
			status_user="23"
			#get_parent().decrease_unfinished_puzzle("wilderness")
			$wilderness2.visible =false
			$wilderness3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if desert_user>0:
		if item_name=="desert":
			status_user="31"
			#get_parent().decrease_unfinished_puzzle("desert")
			$desert.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("desert_up_grade_1")
		if item_name == "desert_up_grade_1":
			status_user="32"
			#get_parent().decrease_unfinished_puzzle("desert")
			$desert.visible =false
			$desert2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("desert_up_grade_2")
		if item_name == "desert_up_grade_2":
			status_user="33"
			#get_parent().decrease_unfinished_puzzle("desert")
			$desert2.visible =false
			$desert3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
		
	if sea_user >0:
		if item_name=="sea":
			status_user="41"
			#get_parent().decrease_unfinished_puzzle("sea")
			$sea.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("sea_up_grade_1")
		if item_name == "sea_up_grade_1":
			status_user="42"
			#get_parent().decrease_unfinished_puzzle("sea")
			$sea.visible =false
			$sea2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("sea_up_grade_2")
		if item_name == "sea_up_grade_2":
			status_user="43"
			#get_parent().decrease_unfinished_puzzle("sea")
			$sea2.visible =false
			$sea3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if town_user>0:		
		if item_name=="town":
			status_user="51"
			#get_parent().decrease_unfinished_puzzle("town")
			$town.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("town_up_grade_1")
		if item_name == "town_up_grade_1":
			status_user="52"
			#get_parent().decrease_unfinished_puzzle("town")
			$town.visible =false
			$town2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("town_up_grade_2")
		if item_name == "town_up_grade_2":
			status_user="53"
			#get_parent().decrease_unfinished_puzzle("town")
			$town2.visible =false
			$town3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	if volcano_user>0:
		if item_name=="volcano":
			status_user="61"
			#get_parent().decrease_unfinished_puzzle("volcano")
			$volcano.visible = true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("volcano_up_grade_1")
		if item_name == "volcano_up_grade_1":
			status_user="62"
			#get_parent().decrease_unfinished_puzzle("volcano")
			$volcano.visible =false
			$volcano2.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("volcano_up_grade_2")
		if item_name == "volcano_up_grade_2":
			status_user="63"
			#get_parent().decrease_unfinished_puzzle("volcano")
			$volcano2.visible =false
			$volcano3.visible=true
			$MenuButton.get_popup().clear()
			$MenuButton.get_popup().add_item("finish")
	emit_signal("reflash")
			
func get_status():
	return status_user
func get_position():
	return position_user

func _on_Timer_timeout():
	pass
