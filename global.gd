extends Node
#位置對應的狀態

# by editing the debug choice, system will print network or other debug data.
# 0=No debug data,1=important debug data ,2=all receive debug data
var DEBUG_MODE = 2

var BACKGROUND_WEB = 'http://herpg.cgu.edu.tw/cgu_games/login.php'
#var BACKGROUND_WEB = 'http://localhost/cgu_games/login.php'

var UNUSED_PUZZLE_POINT = 1
var USED_PUZZLE_POINT = 2

var EMERGENCY_AMOUNT = 30
var TITLE_AMOUNT = 32

var EMERGENCY_UP_TIME = 43200 # 12hr * 3600
var EMERGENCY_CD_TIME = 43200 # 12hr * 3600

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
		
var status_user={"AA01":"00","AA02":"00","AA03":"00","AA04":"00","AA05":"00","AA06":"00","AA07":"00","AA08":"00",#大拼圖
				 "AA09":"00","AA10":"00","AA11":"00","AA12":"00","AA13":"00","AA14":"00","AA15":"00","AA16":"00",
				 "AB01":"00","AB02":"00","AB03":"00","AB04":"00","AB05":"00","AB06":"00","AB07":"00","AB08":"00",
				 "AB09":"00","AB10":"00","AB11":"00","AB12":"00","AB13":"00","AB14":"00","AB15":"00","AB16":"00",
				 "AC01":"00","AC02":"00","AC03":"00","AC04":"00","AC05":"00","AC06":"00","AC07":"00","AC08":"00",
				 "AC09":"00","AC10":"00","AC11":"00","AC12":"00","AC13":"00","AC14":"00","AC15":"00","AC16":"00",
				 "AD01":"00","AD02":"00","AD03":"00","AD04":"00","AD05":"00","AD06":"00","AD07":"00","AD08":"00",
				 "AD09":"00","AD10":"00","AD11":"00","AD12":"00","AD13":"00","AD14":"00","AD15":"00","AD16":"00",
				 "AE01":"00","AE02":"00","AE03":"00","AE04":"00","AE05":"00","AE06":"00","AE07":"00","AE08":"00",
				 "AE09":"00","AE10":"00","AE11":"00","AE12":"00","AE13":"00","AE14":"00","AE15":"00","AE16":"00",
				 "AF01":"00","AF02":"00","AF03":"00","AF04":"00","AF05":"00","AF06":"00","AF07":"00","AF08":"00",
				 "AF09":"00","AF10":"00","AF11":"00","AF12":"00","AF13":"00","AF14":"00","AF15":"00","AF16":"00",
				 "AG01":"00","AG02":"00","AG03":"00","AG04":"00","AG05":"00","AG06":"00","AG07":"00","AG08":"00",
				 "AG09":"00","AG10":"00","AG11":"00","AG12":"00","AG13":"00","AG14":"00","AG15":"00","AG16":"00",
				 "AH01":"00","AH02":"00","AH03":"00","AH04":"00","AH05":"00","AH06":"00","AH07":"00","AH08":"00",
				 "AH09":"00","AH10":"00","AH11":"00","AH12":"00","AH13":"00","AH14":"00","AH15":"00","AH16":"00",
				 "AI01":"00","AI02":"00","AI03":"00","AI04":"00","AI05":"00","AI06":"00","AI07":"00","AI08":"00",
				 "AI09":"00","AI10":"00","AI11":"00","AI12":"00","AI13":"00","AI14":"00","AI15":"00","AI16":"00",
				 "AJ01":"00","AJ02":"00","AJ03":"00","AJ04":"00","AJ05":"00","AJ06":"00","AJ07":"00","AJ08":"00",
				 "AJ09":"00","AJ10":"00","AJ11":"00","AJ12":"00","AJ13":"00","AJ14":"00","AJ15":"00","AJ16":"00",
				 "CA01":"00","CA02":"00","CA03":"00","CA04":"00","CA05":"00","CA06":"00",#cgu拼圖
				 "CA07":"00","CA08":"00","CA09":"00","CA10":"00","CA11":"00",
				 "CB01":"00","CB02":"00","CB03":"00","CB04":"00","CB05":"00","CB06":"00","CB07":"00",
				 "CB08":"00","CB09":"00","CB10":"00","CB11":"00","CB12":"00",
				 "CC01":"00","CC02":"00","CC03":"00","CC04":"00","CC05":"00","CC06":"00",
				 "CC07":"00","CC08":"00","CC09":"00","CC10":"00","CC11":"00",
				 "EA01":"00","FA01":"00","GA01":"00"}


var block_type={"puddle":"1","wilderness":"2","desert":"3","sea":"4"
				,"town":"5","volcano":"6"}

var slect_button_opened=false #遊戲內紀錄此拼圖的選單是否已開啟 用來讓拼圖升級時不會和其他片的按鈕衝突
var set_title_button_opened=false #遊戲內紀錄此設定稱號的選單是否已開啟 用來讓它不會和其他片的按鈕衝突

var login_certification = "0000000000000000000"
var login_time = 0

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
	#total_point = USED_PUZZLE_POINT*finished_puzzle_user + UNUSED_PUZZLE_POINT*_get_unfinished_puzzle()
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
					"10":0,"11":0,"12":0,"13":0,"14":0,"15":0,"16":0,"17":0,"18":0,"19":0,"20":0,"21":0,"22":0,"23":0}
					
var title_list={"0":"個人賽總冠軍","1":"個人賽總亞軍","2":"個人賽總季軍","3":"個人賽總排名前三十","4":"團體賽總冠軍","5":"團體賽總亞軍",
				"6":"團體賽總季軍","7":"團體賽總排名前三十","8":"收藏界菜鳥","9":"收藏界老鳥",
				"10":"收藏界專家","11":"初級地形已經不能滿足我了，我要升級","12":"只升級一次怎麼夠，我當然還要更多",
				"13":"瘋狂升級中","14":"初級地主","15":"高級地主","16":"究級地主","17":"事件處理者…的學徒",
				"18":"事件處理者","19":"事件收割者","20":"神奇腦迴路","21":"好鄰居","22":"社交達人","23":"敦親睦鄰"}

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
	if _get_special_puzzle_status(1)=="10" or _get_special_puzzle_status(2)=="10":
		_set_title_status("21")
	if _get_special_puzzle_status(1)=="10" and _get_special_puzzle_status(2)=="10" :
		_set_title_status("22")
	if _get_special_puzzle_status(3)=="10":
		_set_title_status("23")

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
signal activity_window_open
func emit_activity_window_open():
	emit_signal("activity_window_open")
 
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
	#_set_up()
	pass
	
func _set_up_puzzle_and_title():
	#取得拼圖總數
	total_puzzle_user=str(finished_puzzle_user+_get_unfinished_puzzle())
	#這邊是稱號的設定
	_check_title_status()
	_check_receive_special_puzzle()
		
func _refresh_data():
	_set_up_puzzle_and_title()
	
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
	EMERGENCY_CD_TIME = (12*60) - (finished_puzzle_user*10)
	#each of the puzzle used reduce CD for 10 min

var department_list = ['醫學系','中醫系','護理系','生醫系','呼治系','物治系',
'職治系','醫放系','醫技系','電機系','電子系','機械系','資工系','化材系',
'人工智慧學士學位學程','工商系','工設系','資管系','醫管系','國際健康管理學士學位學程']

var department_list_en = ['md','cm','nurse','is','rc','pt','dot','mirs','mip',
'ee','elec','me','csie','ce','ai','ibm','id','im','hcm','him']

var cgu_puzzles_position = ["CA01","CA02","CA03","CA04","CA05","CA06","CA07","CA08","CA09","CA10",
							"CA11","CB01","CB02","CB03","CB04","CB05","CB06","CB07","CB08","CB09",
							"CB10","CB11","CB12","CC01","CC02","CC03","CC04","CC05","CC06","CC07","CC08","CC09","CC10","CC11"]
func is_cgu_puzzles_map_complete():
	var empty_puzzle_num=0
	for position in cgu_puzzles_position:
		if status_user[position]=="00":
			empty_puzzle_num+=1
	if empty_puzzle_num==0:
		return true
	else:
		return false

var button_click_time=0
func add_button_click_time(val):
	debug_msg(2,"Place Button Click!")
	var world = get_node("/root/world")
	world.send_place_click_request()
	# data will add automaticly when server return sucess
	

var special_puzzle_status = "000000"

func _check_receive_special_puzzle():
	var puzzle1_status=_get_special_puzzle_status(1)
	var puzzle2_status=_get_special_puzzle_status(2)
	var puzzle3_status=_get_special_puzzle_status(3)
	#特殊拼圖1條件
	if login_time>=14 and puzzle1_status=="00":
		_set_special_puzzle_in_status_user(1,"01",0)
	#特殊拼圖2條件
	if is_cgu_puzzles_map_complete() and puzzle2_status=="00":
		_set_special_puzzle_in_status_user(2,"01",0)
	#特殊拼圖3條件
	#已獲的1、2拼圖且未獲得3的情況
	if button_click_time>=50 and (puzzle1_status!="00" and puzzle2_status!="00" and puzzle3_status=="00"):
		_set_special_puzzle_in_status_user(3,"01",0)
	
func _set_special_puzzle_in_status_user(puzzle_num,status_value,set): #status_value:00:未獲得特殊拼圖，01:已獲得特殊拼圖，10:已獲得且已拼上特殊拼圖
	var world = get_node("/root/world")
	world.send_special_request(special_puzzle_status.substr(0,2*(puzzle_num-1))+status_value+special_puzzle_status.substr(puzzle_num*2),set)
	# data will save automaticly when server return sucess
	
func _get_special_puzzle_status(puzzle_num):
	debug_msg(2,"Special Puzzle"+str(special_puzzle_status))
	return special_puzzle_status.substr((puzzle_num-1)*2,2)
	
