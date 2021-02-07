extends Sprite
<<<<<<< HEAD
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
=======

>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
#突發事件的處理、流程(BTW emgency是emergency 我寫錯了)

var border_begin=30  #設定icon的border
var length=300 
var width=150

var emergency_probability
<<<<<<< HEAD
var finished_puzzle #這裡需要做資料的獲取

var event_data #隨機事件的資料

var reward=3 #選項獎勵拼圖數
var special_reward=3
=======
var finished_puzzle=0 #這裡需要做資料的獲取

var file_emergency_num #隨機事件的題號
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
# Called when the node enters the scene tree for the first time.
func _ready():
	
	emergency_probability=0
<<<<<<< HEAD
	finished_puzzle=30
=======
	finished_puzzle=0;
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
	$Button_emergency.visible=false
	
	#text_window 已在內部預設初始隱藏
	#按鈕隱藏
	$option/A.visible = false
	$option/B.visible = false
	$option/C.visible = false
	
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$text_window_emergency.connect("timer_continue",self,"_close_window")#當window做了close的動作 會發出訊號 這裡會執行關閉這個視窗的動作
	

func _on_Timer_timeout():#決定是否出現隨機事件
	#目前設定規則:每隔固定的時間會取亂數決定是否出現隨機事件 若沒有按掉隨機事件會在下一次timeout消失(除非又出現突發事件)
	#當視窗開啟計時停止，當視窗關閉才會再開始
	#根據emergency_probability的數量作為亂數total 取到1突發事件發生
	_set_emergency_probability(finished_puzzle)
	if _random(1,emergency_probability)==1:
		var x=_random(border_begin,length)  #icon出現位置隨機
		var y=_random(border_begin,width)
		var new_position=Vector2(x,y)
		$Button_emergency.set_position(new_position)
		$Button_emergency.visible=true
	else:
		$Button_emergency.visible=false
	 
	

func _on_Button_emergency_pressed(): #點開隨機事件
	#計時暫停
	$Timer.paused=true
	#跳出訊息畫面
<<<<<<< HEAD
	$text_window_emergency/emergency_background.visible = true
	$text_window_emergency/close.visible = true
	$text_window_emergency/close_picture.visible = true
	event_data = $text_window_emergency/text_emergency._set_event() #隨機選擇文檔 
=======
	$text_window_emergency/background.visible = true
	$text_window_emergency/close.visible = true
	file_emergency_num = $text_window_emergency/text_emergency._set_file() #隨機選擇文檔 #獲取題號
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
	$text_window_emergency/text_emergency.visible = true
	#option 出現
	$option/A.visible = true
	$option/B.visible = true
	$option/C.visible = true
<<<<<<< HEAD
	$option/A_picture.visible=true
	$option/B_picture.visible=true
	$option/C_picture.visible=true
=======
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
	#icon消失
	$Button_emergency.visible=false
	
	
	
#取亂數
var rand=RandomNumberGenerator.new()
func _random(begin,end):
	rand.randomize()
	var random_num=rand.randi_range(begin,end)
	return random_num

#機率的設定 (目前為假設 還會再變更)
func _set_emergency_probability(num):
	if num >= 0 and num<10:
		emergency_probability=15
	elif num>=10 and num<20:
		emergency_probability=10
	else:
<<<<<<< HEAD
		emergency_probability=1
=======
		emergency_probability=5
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022


func _timer_continue(): #Timer繼續開始數
	$Timer.paused=false

func _close_window(): #關閉視窗
	_close_button()
<<<<<<< HEAD
	$text_window_emergency/emergency_background.visible = false
	$text_window_emergency/close.visible = false
	$text_window_emergency/close_picture.visible = false
	$text_window_emergency/text_emergency.visible = false
	$text_window_emergency/text_after_answer.visible = false
=======
	$text_window_emergency/background.visible = false
	$text_window_emergency/close.visible = false
	$text_window_emergency/text.visible = false
	$text_window_emergency/text_emergency.visible = false
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
	_timer_continue()

func _close_button():
	$option/A.visible = false
	$option/B.visible = false
	$option/C.visible = false
<<<<<<< HEAD
	$option/A_picture.visible=false
	$option/B_picture.visible=false
	$option/C_picture.visible=false
=======
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022

#ABC選項
#2選項規則設定
func _on_A_pressed():
<<<<<<< HEAD
	if event_data["A"]!="":
		$text_window_emergency/text_emergency.visible=false
		$text_window_emergency/text_after_answer.text=event_data["A"]
		$text_window_emergency/text_after_answer.visible=true
		yield(get_tree().create_timer(2.5), "timeout")
	
	_close_window()
	#拼圖片數設定
	var puzzle_type
	for index in range(reward):
		puzzle_type=_random(1,6)
		_give_reward(puzzle_type)
	#答對問題的特殊獎勵
	if event_data["answer"]=="A":
		for index in range(special_reward):
			puzzle_type=_random(1,6)
			_give_reward(puzzle_type)
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容
	

func _on_B_pressed():
	if event_data["B"]!="":
		$text_window_emergency/text_emergency.visible=false
		$text_window_emergency/text_after_answer.text=event_data["B"]
		$text_window_emergency/text_after_answer.visible=true
		yield(get_tree().create_timer(2.5), "timeout")
	
	_close_window()
	#拼圖片數設定
	var puzzle_type
	for index in range(reward):
		puzzle_type=_random(1,6)
		_give_reward(puzzle_type)
	#答對問題的特殊獎勵
	if event_data["answer"]=="B":
		for index in range(special_reward):
			puzzle_type=_random(1,6)
			_give_reward(puzzle_type)
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容


func _on_C_pressed():
	if event_data["C"]!="":
		$text_window_emergency/text_emergency.visible=false
		$text_window_emergency/text_after_answer.text=event_data["C"]
		$text_window_emergency/text_after_answer.visible=true
		yield(get_tree().create_timer(2.5), "timeout")
	
	_close_window()
	#拼圖片數設定
	var puzzle_type
	for index in range(reward):
		puzzle_type=_random(1,6)
		_give_reward(puzzle_type)
	#答對問題的特殊獎勵
	if event_data["answer"]=="C":
		for index in range(special_reward):
			puzzle_type=_random(1,6)
			_give_reward(puzzle_type)
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容
	
func _give_reward(num):
	if num==1:
		Data.puddle_add(1)
	if num==2:
		Data.wilderness_add(1)
	if num==3:
		Data.desert_add(1)
	if num==4:
		Data.sea_add(1)
	if num==5:
		Data.town_add(1)
	if num==6:
		Data.volcano_add(1)

=======
	_close_window()
	#拼圖片數設定


func _on_B_pressed():
	_close_window()
	#拼圖片數設定


func _on_C_pressed():
	_close_window()
	#拼圖片數設定
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
