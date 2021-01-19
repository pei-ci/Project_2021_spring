extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	#先把所有圖片都隱藏
	
	$dio.visible = false
	$jojo.visible = false
	$haachama.visible = false
	$jojo.visible = false
	$kakyoin.visible = false
	$red.visible = false
	$turtle.visible = false
	
	#將所有選項列出
	$MenuButton.get_popup().add_item("function 1")
	$MenuButton.get_popup().add_item("function 2")
	$MenuButton.get_popup().add_item("function 3")
	$MenuButton.get_popup().add_item("function 4")
	$MenuButton.get_popup().add_item("function 5")
	$MenuButton.get_popup().add_item("function 6")
	
	#接收按鈕
	$MenuButton.get_popup().connect("id_pressed",self,"_on_item_pressed")

#關於計分方式我沒有研究，就麻煩2幫我寫在visible true後面了
#還有，圖片記得要換，不然會很鬧
#接收條件，up_grade是什麼你們都懂吧
func _on_item_pressed(id):
	var item_name= $MenuButton.get_popup().get_item_text(id)
	
	if item_name=="function 1":
		$dio.visible = true
		#這段是清除之前的選項，強制升級
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("up_grade1")
	if item_name == "up_grade1":
		$dio.visible =false
		$zawarudo.visible=true
			
	if item_name=="function 2":
		$jojo.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("up_grade2")
	if item_name == "up_grade2":
		$jojo.visible =false
		$starpla.visible=true
			
	if item_name=="function 3":
		$haachama.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("up_grade3")
	if item_name == "up_grade3":
		$haachama.visible =false
		$haachamachamaa.visible=true
			
	if item_name=="function 4":
		$kakyoin.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("up_grade4")
	if item_name == "up_grade4":
		$kakyoin.visible =false
		$green.visible=true
			
	if item_name=="function 5":
		$red.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("up_grade5")
	if item_name == "up_grade5":
		$red.visible =false
		$red1.visible=true
			
	if item_name=="function 6":
		$turtle.visible = true
		$MenuButton.get_popup().clear()
		$MenuButton.get_popup().add_item("up_grade6")
	if item_name == "up_grade6":
		$turtle.visible =false
		$silver.visible=true


func _on_Timer_timeout():
	pass
	#一，這段是給你設定隨機事件的，時間我設定半天，想要修改就到timer那邊的右上角調整秒數
