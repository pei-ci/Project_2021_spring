extends Node2D
#遊戲進行的main

#information column 資訊欄(預設str)
var subject_load ="1"
var number_load="1"
var name_load="1"
var nickname_load="1"
var total_puzzle_load="1" #=未拼+已拼
var title_load="1"
var team_load="1"

#puzzle拼圖(預設int)
var finished_puzzle_load=10  #已使用拼圖
#未拼上的拼圖(預設int)
var puddle_load=1
var wilderness_load=2
var desert_load=7
var sea_load=8
var town_load=100
var volcano_load=0

var puddle_user=1
var wilderness_user=2
var desert_user=7
var sea_user=8
var town_user=100
var volcano_user=0

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()
	
func _set_up():
	#資訊欄
	$information.subject_user = subject_load
	$information.number_user = number_load
	$information.name_user = name_load
	$information.nickname_user = nickname_load
	$information.total_puzzle_user = total_puzzle_load
	$information.title_user = title_load
	$information.team_user = team_load
	#資訊_未拼的拼圖
	$information.puddle=puddle_load
	$information.wilderness=wilderness_load
	$information.desert=desert_load
	$information.sea=sea_load
	$information.town=town_load
	$information.volcano=volcano_load
	
	$information._set_up() #套入格式設定
	#設定突發事件
	$emergency.finished_puzzle=finished_puzzle_load
	
	
	
	
#quit
func _on_Button_pressed():
	get_tree().quit()


func get_unfinished_puzzle(type):
	var unfinished_puzzle={"puddle":puddle_user,"wilderness":wilderness_user,"desert":desert_user,
						"sea":sea_user,"town":town_user,"volcano":volcano_user}
	return unfinished_puzzle[type]
	
func decrease_unfinished_puzzle(type):
	var unfinished_puzzle={"puddle":puddle_user,"wilderness":wilderness_user,"desert":desert_user,
						"sea":sea_user,"town":town_user,"volcano":volcano_user}
	unfinished_puzzle[type] -= 1
	
