extends Sprite

var test_num=70 #測試用的數字
var border_begin=30  #設定icon的border
var length=300 
var width=150

var emergency_probability
var random_probability
var puzzle_on_map #=total puzzle-未拼上的總片數 
#這裡需要做資料的獲取

# Called when the node enters the scene tree for the first time.
func _ready():
	emergency_probability=0
	puzzle_on_map=test_num;
	$Button_emergency.visible=false
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$text_window_emergency.connect("timer_continue",self,"_timer_continue")
	
	

func _on_Timer_timeout():
	#根據emergency_probability的數量作為亂數total 取到1隨機事件發生
	emergency_probability=_get_emergency_probability(puzzle_on_map)
	if _random(1,emergency_probability)==1:
		var x=_random(border_begin,length)
		var y=_random(border_begin,width)
		var new_position=Vector2(x,y)
		$Button_emergency.set_position(new_position)
		$Button_emergency.visible=true
	 
	
#取亂數
var rand=RandomNumberGenerator.new()
func _random(begin,end):
	rand.randomize()
	var random_num=rand.randi_range(begin,end)
	return random_num

func _on_Button_emergency_pressed():
	$Timer.paused=true
	#點開驚嘆號
	$Button_emergency.visible=false
	#跳出訊息畫面
	
	pass # Replace with function body.


#機率的設定
func _get_emergency_probability(num):
	var probability
	if num>=0 and num<10:
		probability=15
	elif num>=10 and num<20:
		probability=10
	else:
		probability=5
	return probability

func _timer_continue():
	$Timer.paused=false
