extends Node
#位置對應的狀態

var status_user={"AA01":"00","AB01":"00","AA02":"00","AB02":"00",
				"AA03":"00","AB03":"00","AA04":"00","AB04":"00",
				"AA05":"00","AB05":"00"}

var block_type={"puddle":"1","wilderness":"2","desert":"3","sea":"4"
				,"town":"5","volcano":"6"}

var login_certification = "0000000000000000000"
#puzzle拼圖(預設int)
var finished_puzzle_user=0  #已使用拼圖
func finished_puzzle_add(val):
	finished_puzzle_user += val
#未拼上的拼圖(預設int) 6type
var puddle_user=1
var wilderness_user=1
var desert_user=1
var sea_user=1
var town_user=1
var volcano_user=1
#information column 資訊欄(預設str)
var subject_user ="loading"
var number_user="loading"
var name_user="loading"
var nickname_user="loading"
var total_puzzle_user=str(finished_puzzle_user+_get_unfinished_puzzle())
var title_user="loading"
var team_user="loading"


func puddle_add(val):
	puddle_user += val
func wilderness_add(val):
	wilderness_user += val
func desert_add(val):
	desert_user += val
func sea_add(val):
	sea_user += val
func town_add(val):
	town_user += val
func volcano_add(val):
	volcano_user += val

func puddle_minus(val):
	puddle_user -= val
func wilderness_minus(val):
	wilderness_user -= val
func desert_minus(val):
	desert_user -= val
func sea_minus(val):
	sea_user -= val
func town_minus(val):
	town_user -= val
func volcano_minus(val):
	volcano_user -= val


func _ready():
	_set_up()
	
func _set_up():
	#取得拼圖總數
	total_puzzle_user=str(finished_puzzle_user+_get_unfinished_puzzle())
	#這邊是稱號的設定 目前為假設 #稱號依照拼圖總數決定
	if int(total_puzzle_user)<10:
		title_user="S"
	else:
		title_user="L"
		
func _refresh_data():
	_set_up()
	
func _get_unfinished_puzzle():
	return (puddle_user+wilderness_user+desert_user+sea_user+town_user+volcano_user)
	

signal refresh
func emit_refresh(): #當數值改變時會使用此函式 來刷新頁面上的資料
	emit_signal("refresh")

