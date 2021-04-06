extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
#突發事件的處理、流程(BTW emgency是emergency 我寫錯了)

var border_begin=30  #設定icon的border
var length=480
var width=270

var emergency_probability
var finished_puzzle #這裡需要做資料的獲取

var event_data #隨機事件的資料

var reward=3 #選項獎勵拼圖數
var special_reward=1 #答對會額外給的拼圖數

var world

# Called when the node enters the scene tree for the first time.
func _ready():
	
	emergency_probability=0
	finished_puzzle=0
	$Button_emergency.visible=false
	
	#按鈕隱藏
	$option.visible = false
	
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$text_window_emergency.connect("timer_continue",self,"_close_window")#當window做了close的動作 會發出訊號 這裡會執行關閉這個視窗的動作
	

func _on_Timer_timeout():#決定是否出現突發事件
	#目前設定規則:每秒檢查是否在突發事件會觸發的時間內
	if $text_window_emergency/emergency_background.visible==true:
		return
	if Data._is_emergency_time():#到了突發事件會觸發的時間
		$Button_emergency.visible=true
	else:
		$Button_emergency.visible=false
		
	

func _on_Button_emergency_pressed(): #點開隨機事件
	world = get_node("/root/world")
	#計時暫停
	#$Timer.paused=true
	#跳出訊息畫面
	$text_window_emergency/emergency_background.visible = true
	$text_window_emergency/close.visible = true
	$text_window_emergency/close_picture.visible = true
	event_data = $text_window_emergency/text_emergency._set_event() #隨機選擇文檔 
	$text_window_emergency/text_emergency.visible = true
	#option 出現
	$option.visible = true
	
	#icon消失
	$Button_emergency.visible=false
	
	
	
#取亂數
var rand=RandomNumberGenerator.new()
func _random(begin,end):
	rand.randomize()
	var random_num=rand.randi_range(begin,end)
	return random_num



func _close_window(): #關閉視窗
	_close_button()
	$text_window_emergency/emergency_background.visible = false
	$text_window_emergency/close.visible = false
	$text_window_emergency/close_picture.visible = false
	$text_window_emergency/text_emergency.visible = false
	$text_window_emergency/text_after_answer.visible = false
	#_timer_continue()

func _close_button():
	$option.visible = false

#ABC選項
#2選項規則設定
func _on_A_pressed():
	#Data._get_event_status(event_data["number"]) 回答次數判斷
	var is_reply = _answer_reply("A")#某些題目選到特定選項會出現
	if is_reply:                     #暫停畫面
		yield(get_tree().create_timer(2.5), "timeout")
	_close_window()
	#拼圖片數設定
	_give_reward("A")
	Data._set_event_status_list(event_data["number"],1)
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容
	

func _on_B_pressed():
	var is_reply = _answer_reply("B")#某些題目選到特定選項會出現
	if is_reply:
		yield(get_tree().create_timer(2.5), "timeout")
	
	_close_window()
	#拼圖片數設定
	_give_reward("B")
	Data._set_event_status_list(event_data["number"],1)
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容


func _on_C_pressed():
	var is_reply = _answer_reply("C")#某些題目選到特定選項會出現
	if is_reply:
		yield(get_tree().create_timer(2.5), "timeout")
	
	_close_window()
	#拼圖片數設定
	_give_reward("C")
	Data._set_event_status_list(event_data["number"],1)
	Data.emit_refresh()#發出訊號 world那邊會接收並更新內容

func _answer_reply(option):
	if event_data[option]!="":
		$text_window_emergency/text_after_answer.text=event_data[option]
	else:
		if option==event_data["answer"]:
			$text_window_emergency/text_after_answer.text="恭喜答對！"
		else:
			$text_window_emergency/text_after_answer.text="再接再厲！"
	
	$text_window_emergency/text_emergency.visible=false
	$text_window_emergency/text_after_answer.visible=true
	return true

func _give_reward(option):
	Data._emergency_solve_time(1) #突發事件完成數+1
	var puzzle_type
	#選擇任何選項都匯給的基本獎勵
	for piece in range(reward):  #reward是基本的拼圖獎勵片數 每次loop會random一次決定這一片是哪一種拼圖 並給予拼圖
		puzzle_type=_random(1,6)
		world.send_emergency_request(puzzle_type,1,0,$text_window_emergency.get_event_id())
	
	#以下是答對問題的特殊獎勵
	#這邊是如果選項又選到對的答案 又會再額外給予拼圖
	if event_data["answer"]==option: #選的答案和答案相符
		Data._emergency_correct_time(1) #突發事件答對數+1
		
		for piece in range(special_reward):  #special_reward是答對的拼圖獎勵片數 每次loop會random決定這一片是哪一種拼圖 並給予拼圖
			puzzle_type=_random(1,6)
			world.send_emergency_request(puzzle_type,1,0,$text_window_emergency.get_event_id())
			world.send_emergency_record_request(1,$text_window_emergency.get_event_id())
	else:
		world.send_emergency_request(puzzle_type,2,1,$text_window_emergency.get_event_id())
		world.send_emergency_record_request(0,$text_window_emergency.get_event_id())
