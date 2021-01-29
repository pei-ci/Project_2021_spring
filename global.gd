extends Node
#位置對應的狀態
var status_user={"AA01":"12","AB01":"00","AA02":"00","AB02":"61",
				"AA03":"00","AB03":"00","AA04":"00","AB04":"00",
				"AA05":"00","AB05":"00"}
#puzzle拼圖(預設int)
var finished_puzzle_user=2  #已使用拼圖
#未拼上的拼圖(預設int) 6type
var puddle_user=1
var wilderness_user=1
var desert_user=1
var sea_user=1
var town_user=1
var volcano_user=1
#information column 資訊欄(預設str)
var subject_user ="1"
var number_user="1"
var name_user="1"
var nickname_user="1"
var total_puzzle_user=str(finished_puzzle_user+_get_unfinished_puzzle())
var title_user="1" #稱號依照拼圖總數決定
var team_user="1"

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()
	
func _set_up():
	#load資料進來 
	#subject_user=...
	#number_user=...
	#...
	#取得拼圖總數
	total_puzzle_user=str(finished_puzzle_user+_get_unfinished_puzzle())
	#這邊是稱號的設定 目前為假設 #稱號依照拼圖總數決定
	if int(total_puzzle_user)/10<1: 
		title_user="S"
	else:
		title_user="L"
	pass
	
	
signal refresh
func emit_refresh(): #當數值改變時會使用此函式 來刷新頁面上的資料
	emit_signal("refresh")

func _get_unfinished_puzzle():
	return (puddle_user+wilderness_user+desert_user+sea_user+town_user+volcano_user)
