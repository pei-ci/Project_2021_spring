extends Sprite

#var 狀態的紀錄



# Called when the node enters the scene tree for the first time.
func _ready():
	#先把所有圖片都隱藏
	
	$puddle.visible = false
	$wilderness.visible = false
	$desert.visible = false
	$sea.visible = false
	$town.visible = false
	$volcano.visible = false
	
	#將所有選項列出
	$MenuButton.get_popup().add_item("puddle")
	$MenuButton.get_popup().add_item("wilderness")
	$MenuButton.get_popup().add_item("desert")
	$MenuButton.get_popup().add_item("sea")
	$MenuButton.get_popup().add_item("town")
	$MenuButton.get_popup().add_item("volcano")
	
	#接收按鈕
	$MenuButton.get_popup().connect("id_pressed",self,"_on_item_pressed")


func _set_up():
	#登入後狀態的設定
	pass


#關於計分方式我沒有研究，就麻煩2幫我寫在visible true後面了
#還有，圖片記得要換，不然會很鬧
#接收條件，up_grade是什麼你們都懂吧
func _on_item_pressed(id):
	var item_name= $MenuButton.get_popup().get_item_text(id)
	
	if item_name=="puddle":
		$puddle.visible = true
		#這段是清除之前的選項，強制升級
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("puddle_up_grade_1")
	if item_name == "puddle_up_grade_1":
		$puddle.visible =false
		$puddle2.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("puddle_up_grade_2")
	if item_name=="puddle_up_grade_2":
		$puddle2.visible =false
		$puddle3.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("finish")
			
	if item_name=="wilderness":
		$wilderness.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("wilderness_up_grade_1")
	if item_name == "wilderness_up_grade_1":
		$wilderness.visible =false
		$wilderness2.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("wilderness_up_grade_2")
	if item_name== "wilderness_up_grade_2":
		$wilderness2.visible =false
		$wilderness3.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("finish")
			
	if item_name=="desert":
		$desert.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("desert_up_grade_1")
	if item_name == "desert_up_grade_1":
		$desert.visible =false
		$desert2.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("desert_up_grade_2")
	if item_name == "desert_up_grade_2":
		$desert2.visible =false
		$desert3.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("finish")
		
			
	if item_name=="sea":
		$sea.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("sea_up_grade_1")
	if item_name == "sea_up_grade_1":
		$sea.visible =false
		$sea2.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("sea_up_grade_2")
	if item_name == "sea_up_grade_2":
		$sea2.visible =false
		$sea3.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("finish")
			
	if item_name=="town":
		$town.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("town_up_grade_1")
	if item_name == "town_up_grade_1":
		$town.visible =false
		$town2.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("town_up_grade_2")
	if item_name == "town_up_grade_2":
		$town2.visible =false
		$town3.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("finish")
			
	if item_name=="volcano":
		$volcano.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("volcano_up_grade_1")
	if item_name == "volcano_up_grade_1":
		$volcano.visible =false
		$volcano2.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("volcano_up_grade_2")
	if item_name == "volcano_up_grade_2":
		$volcano2.visible =false
		$volcano3.visible=true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("finish")


func _on_Timer_timeout():
	pass
	#一，這段是給你設定隨機事件的，時間我設定半天，想要修改就到timer那邊的右上角調整秒數
