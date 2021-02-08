extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
#突發事件的處理、流程(BTW emgency是emergency 我寫錯了)

var border_begin=30  #設定icon的border
var length=300 
var width=150

var emergency_probability
var finished_puzzle #這裡需要做資料的獲取

var event_data #隨機事件的資料

var reward=3 #選項獎勵拼圖數
var special_reward=3
# Called when the node enters the scene tree for the first time.
func _ready():
	
	emergency_probability=0
	finished_puzzle=30
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
	$text_window_emergency/emergency_background.visible = true
	$text_window_emergency/close.visible = true
	$text_window_emergency/close_picture.visible = true
	event_data = $text_window_emergency/text_emergency._set_event() #隨機選擇文檔 
	$text_window_emergency/text_emergency.visible = true
	#option 出現
	$option/A.visible = true
	$option/B.visible = true
	$option/C.visible = true
	$option/A_picture.visible=true
	$option/B_picture.visible=true
	$option/C_picture.visible=true
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
		emergency_probability=1


func _timer_continue(): #Timer繼續開始數
	$Timer.paused=false

func _close_window(): #關閉視窗
	_close_button()
	$text_window_emergency/emergency_background.visible = false
	$text_window_emergency/close.visible = false
	$text_window_emergency/close_picture.visible = false
	$text_window_emergency/text_emergency.visible = false
	$text_window_emergency/text_after_answer.visible = false
	_timer_continue()

func _close_button():
	$option/A.visible = false
	$option/B.visible = false
	$option/C.visible = false
	$option/A_picture.visible=false
	$option/B_picture.visible=false
	$option/C_picture.visible=false

#ABC選項
#2選項規則設定
func _on_A_pressed():
	var is_reply = _answer_reply("A")#某些題目選到特定選項會出現
	if is_reply:                     #暫停畫面
		yield(get_tree().create_timer(2.5), "timeout")
	_close_window()
	#拼圖片數設定
	_give_reward("A")
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容
	

func _on_B_pressed():
	var is_reply = _answer_reply("B")#某些題目選到特定選項會出現
	if is_reply:
		yield(get_tree().create_timer(2.5), "timeout")
	
	_close_window()
	#拼圖片數設定
	_give_reward("B")
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容


func _on_C_pressed():
	var is_reply = _answer_reply("C")#某些題目選到特定選項會出現
	if is_reply:
		yield(get_tree().create_timer(2.5), "timeout")
	
	_close_window()
	#拼圖片數設定
	_give_reward("C")
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容

func _answer_reply(option):
	if event_data[option]!="":
		$text_window_emergency/text_emergency.visible=false
		$text_window_emergency/text_after_answer.text=event_data[option]
		$text_window_emergency/text_after_answer.visible=true
		return true
	else:
		return false

func _give_reward(option):
	var puzzle_type
	for index in range(reward):
		puzzle_type=_random(1,6)
		_give_puzzle(puzzle_type)
	#答對問題的特殊獎勵
	if event_data["answer"]==option:
		for index in range(special_reward):
			puzzle_type=_random(1,6)
			_give_puzzle(puzzle_type)

func _give_puzzle(num):
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
