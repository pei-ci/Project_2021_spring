extends Node
#位置對應的狀態

# by editing the debug choice, system will print network or other debug data.
# 0=No debug data,1=important debug data ,2=all receive debug data
var DEBUG_MODE = 1

var UNUSED_PUZZLE_POINT = 1
var USED_PUZZLE_POINT = 2

var EMERGENCY_AMOUNT = 30
var TITLE_AMOUNT = 32

func debug_msg(level,msg):
	if DEBUG_MODE-level >= 0:
		if level==0:
			print("ERROR : "+msg)
			get_tree().change_scene("res://Error.tscn")	
			get_tree().paused = true
		elif level==1:
			print("NORMAL : "+msg)
		elif level==2:
			print("DEBUG : "+msg)
		
var status_user={"AA01":"00","AB01":"00","AA02":"00","AB02":"00",
				"AA03":"00","AB03":"00","AA04":"00","AB04":"00",
				"AA05":"00","AB05":"00"}

var block_type={"puddle":"1","wilderness":"2","desert":"3","sea":"4"
				,"town":"5","volcano":"6"}

var slect_button_opened=false #遊戲內紀錄此拼圖的選單是否已開啟 用來讓拼圖升級時不會和其他片的按鈕衝突
var set_title_button_opened=false #遊戲內紀錄此設定稱號的選單是否已開啟 用來讓它不會和其他片的按鈕衝突

var login_certification = "0000000000000000000"
#puzzle拼圖(預設int)
var finished_puzzle_user=0  #已使用拼圖
func finished_puzzle_add(val):
	#	puzzle will automatic update during next map request
	#	,so it's no need to change here
	#finished_puzzle_user += val
	pass
	

#未拼上的拼圖(預設int) 6type
var puddle_user=0
var wilderness_user=0
var desert_user=0
var sea_user=0
var town_user=0
var volcano_user=0
#information column 資訊欄(預設str)
var subject_user ="loading"
var number_user="loading"
var name_user="loading"
var nickname_user="loading"
var total_puzzle_user="0"
var total_point=0
var title_user="loading" #稱號依照拼圖總數決定
var team_user="loading"


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
	
func _set_up_puzzle_amount_info():
	total_point = USED_PUZZLE_POINT*finished_puzzle_user + UNUSED_PUZZLE_POINT*_get_unfinished_puzzle()
	total_puzzle_user=str(finished_puzzle_user+_get_unfinished_puzzle())
	# here need to check if any show board need to update

#個人排行
var first_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}#暱稱，拼圖總數，目前稱號
var second_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var third_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var four_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var five_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var six_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var seven_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var eight_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var night_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var ten_person={"nickname":"尚無排名","total_puzzle":"尚無排名","title":"尚無排名","name":"尚無排名","number":"尚無排名","department":"尚無排名"}
var top_ten_person=[first_person,second_person,third_person,four_person,five_person,six_person,seven_person,eight_person,night_person,ten_person]

#團隊
var first_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}#隊名，拼圖總數
var second_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var third_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var four_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var five_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var six_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var seven_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var eight_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var night_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var ten_team={"teamname":"尚無排名","total_puzzle":"尚無排名"}
var top_ten_team=[first_team,second_team,third_team,four_team,five_team,six_team,seven_team,eight_team,night_team,ten_team]


#稱號的部分
var up_grade_time=0 #升級次數
var full_level_puzzle_num=0 #升至滿等拼圖數
var emergency_solve_time=0 #突發事件完成次數
var emergency_correct_time=0 #突發事件答對次數 

func _set_up_puzzle_upgrade_info():
	# add code to setup puzzle info by puzzle_list
	var upgrade_count = 0
	var full_upgrade_count = 0
	for value in status_user.values():
		if value[1]=='2':
			upgrade_count += 1
		elif value[1]=='3':
			upgrade_count += 2
			full_upgrade_count += 1
	up_grade_time = upgrade_count
	full_level_puzzle_num = full_upgrade_count

func _up_grade_time_add(val):
	up_grade_time+=val
func _full_level_puzzle_num_add(val):
	full_level_puzzle_num+=val
func _emergency_solve_time(val):
	#	emergency will automatic update during next emergency_info request
	#	,so it's no need to change here
	#emergency_solve_time+=val
	pass
func _emergency_correct_time(val):
	#	emergency will automatic update during next emergency_info request
	#	,so it's no need to change here
	#emergency_correct_time+=val
	pass

var have_type={"puddle":0,"wilderness":0,"desert":0,"sea":0,"town":0,"volcano":0} #紀錄是否已獲得各類型拼圖 對應_get_num_of_type()

var title_status={"0":0,"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,
					"10":0,"11":0,"12":0,"13":0,"14":0,"15":0,"16":0,"17":0,"18":0,"19":0,"20":0}
					
var title_list={"0":"個人賽總冠軍","1":"個人賽總亞軍","2":"個人賽總季軍","3":"個人賽總排名前三十","4":"團體賽總冠軍","5":"團體賽總亞軍",
				"6":"團體賽總季軍","7":"團體賽總排名前三十","8":"收藏界菜鳥","9":"收藏界老鳥",
				"10":"收藏界專家","11":"初級地形已經不能滿足我了，我要升級","12":"只升級一次怎麼夠，我當然還要更多",
				"13":"瘋狂升級中","14":"初級地主","15":"高級地主","16":"究級地主","17":"事件處理者…的學徒",
				"18":"事件處理者","19":"事件收割者","20":"神奇腦迴路"}

func _set_title_status(title_num):
	if title_status[title_num]==0:
		var world = get_node("/root/world")		
		world.send_add_title_request(title_num)
		world.send_set_title_request(title_num)
		title_user=title_list[title_num]
		title_status[title_num]=1

func _check_title_status():
	"""
	if is_first_person() == true:
		_set_title_status("0")
	if is_second_person() == true:
		_set_title_status("1")
	if is_third_person() == true:
		_set_title_status("2")
	if is_top_thirty_person() == true:
		_set_title_status("3")
	if is_first_team() == true:
		_set_title_status("4")
	if is_second_team() == true:
		_set_title_status("5")
	if is_third_team == true:
		_set_title_status("6")
	if is_top_thirty == true:
		_set_title_status("7")
	"""
	if _get_num_of_type()>=1:
		_set_title_status("8")
	if _get_num_of_type()>=3:
		_set_title_status("9")
	if _get_num_of_type()>=6:
		_set_title_status("10")
	
	if up_grade_time>=1:
		_set_title_status("11")
	if up_grade_time>=5:
		_set_title_status("12")
	if up_grade_time>=10:
		_set_title_status("13")
	
	if full_level_puzzle_num>=1:
		_set_title_status("14")
	if full_level_puzzle_num>=3:
		_set_title_status("15")
	if full_level_puzzle_num>=10:
		_set_title_status("16")
	
	if emergency_solve_time>=1:
		_set_title_status("17")		
	if emergency_solve_time>=5:
		_set_title_status("18")
	if emergency_solve_time>=10:
		_set_title_status("19")	
	
	if emergency_correct_time>=5:
		_set_title_status("20")

func _set_title_information(title_num):#設定顯示在資訊欄上的稱號
	var world = get_node("/root/world")		
	#world.send_add_title_request(title_num)
	if title_status[title_num]>0:#已獲得此稱號 才可以設定顯示在資訊欄上的稱號
		world.send_set_title_request(title_num)
		title_user=title_list[title_num]

func _get_num_of_type():
	if puddle_user>0:
		have_type["puddle"]=1
	if wilderness_user>0:
		have_type["wilderness"]=1
	if desert_user>0:
		have_type["desert"]=1
	if sea_user>0:
		have_type["sea"]=1
	if town_user>0:
		have_type["town"]=1
	if volcano_user>0:
		have_type["volcano"]=1
	return have_type["puddle"]+have_type["wilderness"]+have_type["desert"]+have_type["sea"]+have_type["town"]+have_type["volcano"]

#活動資訊
var activity_list=[]
signal slect_window_open
func emit_slect_window_open():
	emit_signal("slect_window_open")
 
var team_id="0000" #組隊序號
var team_member_list=[{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."},{"姓名":"loading..","學號":"loading..","拼圖數量":"loading.."}]
var team_tatal_puzzle=0
func _set_team_total_puzzle():#使用在global的set_up裡面  在global的ready內、world的_refresh_information()會呼叫到
	team_tatal_puzzle=0
	for member in team_member_list:
		if member["姓名"]=="":
			continue
		team_tatal_puzzle+=member["拼圖數量"]


func _ready():
	_set_up()
	
func _set_up():
	#取得拼圖總數
	total_puzzle_user=str(finished_puzzle_user+_get_unfinished_puzzle())
	#這邊是稱號的設定
	_check_title_status()
		
func _refresh_data():
	_set_up()
	
func _get_unfinished_puzzle():
	return (puddle_user+wilderness_user+desert_user+sea_user+town_user+volcano_user)
	
signal refresh
func emit_refresh(): #當數值改變時會使用此函式 來刷新頁面上的資料
	emit_signal("refresh")

#以下為3/12-3/13新增內容 此行註解可以刪 以下程式碼可以移到適合的位置
#隨機事件解題紀錄

var event_status_list=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

func _set_event_status_list(num,value):
	event_status_list[num-1]+=value
	
func _get_event_status(num):
	return event_status_list[num-1]

func _get_event_list():#要獲得狀態非零的題目用
	var event_list=[]
	for index in range (len(event_status_list)):
		if event_status_list[index]==0:
			event_list.append(index+1)
	if len(event_list)==0:#第二遍的情況
		for index in range (len(event_status_list)):
			if event_status_list[index]==1:
				event_list.append(index+1)
	return event_list

#紀錄時間
var EMERGENCY_UP_TIME = 43200 # 12hr * 3600
var EMERGENCY_CD_TIME = 43200 # 12hr * 3600

var emergency_status = 0
#1=up(waiting to answer) 2=solve(waiting to go to CD) 0=down(during CD)
var emergency_time = 0 #unix time
var last_emergency = 1

#var current_time=60
#var last_emergency_time=40

#var period_time=10 #(以最小單位記)

func _is_emergency_time():
	if(emergency_status==1): 
		#consider emergency=0 but over limit time		
		if((emergency_time-OS.get_unix_time())>0): #time not excess limit
			_check_emergency_change(1)
			return true
	_check_emergency_change(0)
	return false
	#if (current_time-last_emergency_time) > period_time:#此行邏輯還會依規則做修正
	#	return true
	#else:
	#	return false
	
func _check_emergency_change(status): 
	#because  Emergency check every tick,
	#	this function used to prvent debug message overflow 
	if (status!=last_emergency):
		last_emergency = status
		if(status):
			debug_msg(2,"EmergencyEnable!")
		else:
			debug_msg(2,"EmergencyDisable!")
			
func _set_emergency_cd_time():
	#add code to set up emergency CD
	pass

var department_list = ['醫學系','中醫系','護理系','生醫系','呼治系','物治系',
'職治系','醫放系','醫技系','電機系','電子系','機械系','資工系','化材系',
'人工智慧學士學位學程','工商系','工設系','資管系','醫管系','國際健康管理學士學位學程']

var department_list_en = ['md','cm','nurse','is','rc','pt','dot','mirs','mip',
'ee','elec','me','csie','ce','ai','ibm','id','im','hcm','him']
