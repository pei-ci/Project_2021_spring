extends Sprite

#突發事件的處理、流程(BTW emgency是emergency 我寫錯了)

var test_num=30 #測試用的數字
var border_begin=30  #設定icon的border
var length=300 
var width=150

var emergency_probability
var puzzle_on_map #=total puzzle-未拼上的總片數 #這裡需要做資料的獲取

var file_emergency_num #隨機事件的題號
# Called when the node enters the scene tree for the first time.
func _ready():
	
	emergency_probability=0
	puzzle_on_map=test_num;
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
	emergency_probability=_get_emergency_probability(puzzle_on_map)
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
	$text_window_emergency/background.visible = true
	$text_window_emergency/close.visible = true
	file_emergency_num = $text_window_emergency/text_emergency._set_file() #隨機選擇文檔 #獲取題號
	$text_window_emergency/text_emergency.visible = true
	#option 出現
	$option/A.visible = true
	$option/B.visible = true
	$option/C.visible = true
	#icon消失
	$Button_emergency.visible=false
	
	
	
#取亂數
var rand=RandomNumberGenerator.new()
func _random(begin,end):
	rand.randomize()
	var random_num=rand.randi_range(begin,end)
	return random_num

#機率的設定 (目前為假設 還會再變更)
func _get_emergency_probability(num):
	var probability
	if num>=0 and num<10:
		probability=15
	elif num>=10 and num<20:
		probability=10
	else:
		probability=5
	return probability


func _timer_continue(): #Timer繼續開始數
	$Timer.paused=false

func _close_window(): #關閉視窗
	_close_button()
	$text_window_emergency/background.visible = false
	$text_window_emergency/close.visible = false
	$text_window_emergency/text.visible = false
	$text_window_emergency/text_emergency.visible = false
	_timer_continue()

func _close_button():
	$option/A.visible = false
	$option/B.visible = false
	$option/C.visible = false

#ABC選項
#2選項規則設定
func _on_A_pressed():
	_close_window()
	#拼圖片數設定


func _on_B_pressed():
	_close_window()
	#拼圖片數設定


func _on_C_pressed():
	_close_window()
	#拼圖片數設定
