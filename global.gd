extends Node
#位置對應的狀態

# by editing the debug choice, system will print network or other debug data.
# 0=No debug data,1=important debug data ,2=all receive debug data
var DEBUG_MODE = 2

#var BACKGROUND_WEB = 'https://herpg.cgu.edu.tw/cgu_games/login.php'
var BACKGROUND_WEB = 'http://localhost/cgu_games/login.php'

# It's Strongly Recommand to Open SSL cause the connection will be secure
# but if connect to localhost, it should be set to false
#var SSL_USE = true
var SSL_USE = false

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
				 "CC07":"00","CC08":"00","CC09":"00","CC10":"00","CC11":"00"}


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
					"10":0,"11":0,"12":0,"13":0,"14":0,"15":0,"16":0,"17":0,"18":0,"19":0,"20":0,"21":0,"22":0,"23":0,
					"24":0,"25":0,"26":0,"27":0,"28":0,"29":0,"30":0,"31":0}
					
var title_list={"0":"個人賽週冠軍","1":"個人賽週亞軍","2":"個人賽週季軍","3":"個人賽週排名前五十","4":"團體賽週冠軍","5":"團體賽週亞軍",
				"6":"團體賽週季軍","7":"團體賽週排名前十","8":"收藏界菜鳥","9":"收藏界老鳥",
				"10":"收藏界專家","11":"初級地形已經不能滿足我了，我要升級","12":"只升級一次怎麼夠，我當然還要更多",
				"13":"瘋狂升級中","14":"初級地主","15":"高級地主","16":"究級地主","17":"事件處理者…的學徒",
				"18":"事件處理者","19":"事件收割者","20":"神奇腦迴路","21":"好鄰居","22":"社交達人","23":"敦親睦鄰",
				"24":"個人賽總冠軍","25":"個人賽總亞軍","26":"個人賽總季軍","27":"個人賽總排名前五十","28":"團體賽總冠軍","29":"團體賽總亞軍",
				"30":"團體賽總季軍","31":"團體賽總排名前十"}#稱號 24-31，在遊戲結束後，由外部設定

func _set_title_status(title_num):
	if title_status[title_num]==0:
		var world = get_node("/root/world")		
		world.send_add_title_request(title_num)
		world.send_set_title_request(title_num)
		title_user=title_list[title_num]
		title_status[title_num]=1

var personal_rank = -1
var team_rank = -1
var team_point = -1
func _check_title_status():
	
	if personal_rank == 1:
		_set_title_status("0")
	if personal_rank == 2:
		_set_title_status("1")
	if personal_rank == 3:
		_set_title_status("2")
	if personal_rank <= 50 and personal_rank > 0:
		_set_title_status("3")
	if team_rank == 1:
		_set_title_status("4")
	if team_rank == 2:
		_set_title_status("5")
	if team_rank == 3:
		_set_title_status("6")
	if team_rank <= 10 and team_rank > 0:
		_set_title_status("7")
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
	debug_msg(2,"Check Puzzle"+str(special_puzzle_status))
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
	return special_puzzle_status.substr((puzzle_num-1)*2,2)
	
func _get_puzzle_type_with_biggest_number():
	var number_list=_get_number_list_of_finished_puzzle_each_type()
	var max_type=get_max_index(number_list)
	return max_type
		
func _get_number_list_of_finished_puzzle_each_type():
	var type_number=[0,0,0,0,0,0,0]
	var number
	for value in status_user.values():
		number=int(value[1])
		type_number[int(value[0])]+=number
	return type_number
	
func get_max_index(list):
	var maximum=0
	var index=0
	for i in range(len(list)):
		if list[i]>maximum:
			maximum=list[i]
			index=i
	return index
	
	
#活動資訊
var activity_list=[]
signal activity_window_open
func emit_activity_window_open():
	emit_signal("activity_window_open")

func get_activity_info_list():
	var info_list=[]
	for activity in activity_list:
		info_list.append(get_activity_name(activity["代號"]))
	return info_list
func get_activity_name(code_name):
	return activity_name[code_name]

var activity_name={
	'AA01':'板橋動物之家服務學習',
	'AA02':'中小學樂器教學服務(1)',
	'AA03':'中小學樂器教學服務(2)',
	'AA04':'中小學樂器教學服務(3)',
	'AA05':'中小學樂器教學服務(4)',
	'AA06':'中小學樂器教學服務(5)',
	'AA07':'中小學樂器教學服務(6)',
	'AA08':'養生村服務',
	'AA09':'風中奇緣—秧風工作坊x長庚中醫服務學習(1)',
	'AA10':'風中奇緣—秧風工作坊x長庚中醫服務學習(2)',
	'AA11':'第六屆夢翔營服務活動',
	'AA12':'桃特運動會陪伴關懷',
	'AA13':'幸福友愛家園機構健康關懷',
	'AA14':'祥育教養院健康關懷',
	'AA15':'桃特住宿生陪伴關懷(1)',
	'AA16':'桃特住宿生陪伴關懷(2)',
	'AA17':'回收站環保協助(1)',
	'AA18':'回收站環保協助(2)',
	'AA19':'新芽課輔(1)',
	'AA20':'新芽課輔(2)',
	'AA21':'春暉天使營',
	'AA22':'期中上山服務(1)',
	'AA23':'期中上山服務(2)',
	'AA24':'愈健養護中心服務學習',
	'AA25':'兒童讀經班(1)',
	'AA26':'兒童讀經班(2)',
	'AA27':'兒童讀經班(3)',
	'AA28':'兒童讀經班(4)',
	'AA29':'兒童讀經班(5)',
	'AA30':'兒童讀經班(6)',
	'AA31':'兒童讀經班(7)',
	'AA32':'兒童讀經班(8)',
	'AA33':'兒童讀經班(9)',
	'AA34':'兒童讀經班(10)',
	'AA35':'兒童讀經班(11)',
	'AA36':'兒童讀經班(12)',
	'AA37':'兒童讀經班(13)',
	'AA38':'環保服務隊',
	'AA39':'陽明養護中心服務學習',
	'AA40':'三角泛團(1)',
	'AA41':'三角泛團(2)',
	'AA42':'三角泛團(3)',
	'AA43':'小小兵烘焙團(1)',
	'AA44':'小小兵烘焙團(2)',
	'AA45':'小小兵烘焙團(3)',
	'AA46':'小小兵烘焙團(4)',
	'AA47':'飛天豬手作團(1)',
	'AA48':'飛天豬手作團(2)',
	'AA49':'飛天豬手作團(3)',
	'AA50':'飛天豬手作團(4)',
	'AA51':'資工大淨灘1',
	'AA52':'資工大淨灘2',
	'AA53':'2021排球自由盃',
	'AA54':'武術聯合展演',
	'AA55':'109學年度第二學期藝文活動(1)',
	'AA56':'109學年度第二學期藝文活動(2)',
	'AA57':'109學年度第二學期藝文活動(3)',
	'AA58':'109學年度第二學期藝文活動(4)',
	'AA59':'南友期中營',
	'AA60':'三社聯合淨灘',
	'AA61':'桃特住宿生陪伴關懷(3)',
	'AA62':'109學年度第二學期桃園貓舍志工服務隊(1)',
	'AA63':'109學年度第二學期桃園貓舍志工服務隊(2)',
	'AA64':'109學年度第二學期桃園貓舍志工服務隊(3)',
	'AA65':'109學年度第二學期桃園貓舍志工服務隊(4)',
	'AA66':'109學年度第二學期桃園貓舍志工服務隊(5)',
	'AA67':'109學年度第二學期桃園貓舍志工服務隊(6)',
	'AA68':'109學年度第二學期桃園貓舍志工服務隊(7)',
	'AA69':'109學年度第二學期桃園貓舍志工服務隊(8)',
	'AA70':'109學年度第二學期桃園貓舍志工服務隊(9)',
	'AA71':'109學年度第二學期桃園貓舍志工服務隊(10)',
	'AA72':'110學年度大學入學個人申請考生服務隊',
	'AA73':'109學年度第2學期資源教室-人際成長團體(1)',
	'AA74':'109學年度第2學期資源教室-人際成長團體(2)',
	'AA75':'109學年度第2學期資源教室-人際成長團體(3)',
	'AA76':'黑熊醫院',
	'AA77':'電機系淨灘活動',
	'AA78':'電子系淨灘',
	'AA79':'110年春暉淨灘隊',
	'BB01':'肆肆貳赫茲 442 hertz',
	'BB02':'「關鍵熱搜 : 大笑時代」說唱藝術',
	'BB03':'無限電人聲樂團',
	'BB04':'「三個諸葛亮」舞台劇',
	'BB05':'「竹籬笆青春物語」說唱藝術',
	'BB06':'【日影花月II】2021學院音樂派對',
	'BB07':'春日藝術節之《身體敘事》肢體工作坊',
	'BB08':'春日藝術節之舞蹈演出',
	'BC01':'一時大疫︰人文視野下的COVID-19防治、汙名與人權議題',
	'BC02':'聽!一位牙醫的生命樂章',
	'BC03':'斜槓人生是好是壞? 談談大眾看不到的好處與風險',
	'BC04':'社會新鮮人求職必修課-履歷自傳撰寫技巧',
	'BC05':'社會新鮮人求職必修課-面試技巧',
	'BC06':'社會新鮮人求職必修課-勞動權益',
	'BC07':'心理師教你說：你的溝通必須有點心機',
	'BC08':'拖延症＆完美主義－阻礙行動的兩大認知陷阱工作坊',
	'BC09':'障礙者自立生活，生活不PASS',
	'BC10':'屬於自己的小書創作─生命旅程',
	'BC11':'生命植人-木棉科園丁的希望故事',
	'BC12':'第77場次文化講座「拜登政府的對華政策與美中台關係」',
	'BC13':'第78場次文化講座「水—人與環境的平衡」',
	'BC14':'你的櫃子不是你的櫃子-談多元性別的出櫃困境與協助困境',
	'BC15':'客製泰雅刀鑰匙圈',
	'BC16':'泰雅鉛筆袋畫',
	'BC17':'SDGs狀遊故事分享',
	'BC18':'大學避修課',
	'BC19':'藝術講座「可見與不可見–從能量轉換的角度看藝術」',
	'BC20':'防疫悠活',
	'BC21':'新媒體浪潮：媒體素養增能',
	'BD01':'社團靜態成果發表觀眾',
	'BD02':'性平講座',
	'BD03':'生命教育工作坊',
	'CE01':'109學年度畢業典禮(活動組)',
	'CE02':'109學年度學生社團評鑑',
	'CE03':'109學年度大專足球聯賽複賽',
	'CE04':'110學年度呼治系大學甄選入學個人申請第二階段考試',
	'CE05':'109學年度呼治系畢業茶會',
	'CE06':'110學年度物治系大學部個人申請考試',
	'CE07':'109學年度物治系畢業茶會',
	'CE08':'109學年度畢業典禮傑出校友專訪及表揚',
	'CE09':'英語微電影比賽',
	'CE10':'生醫系學士論文競賽(1)',
	'CE11':'生醫系學士論文競賽(2)',
	'CE12':'110學年度生醫系大學甄試',
	'CE13':'109學年度生醫系畢業茶會',
	'CE14':'109學年度第二學期宿舍整潔比賽',
	'CE15':'2021好漢坡登階競賽活動',
	'CE16':'109學年第2學期宿舍生活講座(1)',
	'CE17':'109學年第2學期宿舍生活講座(2)',
	'CE18':'109學年第2學期宿舍生活講座(3)',
	'CE19':'109學年第2學期宿舍生活講座(4)',
	'CE20':'109學年第2學期宿舍生活講座(5)',
	'CE21':'109學年第2學期宿舍生活講座(6)',
	'CE22':'社會新鮮人求職必修課-履歷自傳撰寫技巧',
	'CE23':'社會新鮮人求職必修課-面試技巧',
	'CE24':'社會新鮮人求職必修課-勞動權益',
	'CE25':'生命植人-木棉科園丁的希望故事',
	'CE26':'障礙者自立生活，生活不PASS',
	'CE27':'110年追思大會場佈志工',
	'CE28':'110年追思大會現場場務志工',
	'CE29':'110年追思感恩傳情擺攤志工',
	'CE30':'心理師教你說：你的溝通必須有點心機',
	'CE31':'110學年度醫學系繁星推薦入學口試',
	'CE32':'110學年度醫學系個人申請入學口試(1)',
	'CE33':'110學年度醫學系個人申請入學口試(2)',
	'CE34':'110學年度醫學系個人申請入學口試(3)',
	'CE35':'110學年度醫學系個人申請入學口試(4)',
	'CE36':'110學年度醫學系個人申請入學口試(5)',
	'CE37':'110學年度醫學系個人申請入學口試(6)',
	'CE38':'110學年度醫學系個人申請入學口試(7)',
	'CE39':'110學年度醫學系個人申請入學口試(8)',
	'CE40':'醫學系白袍加身典禮-家長座談會',
	'CE41':'109學年度醫學系畢業茶會',
	'CE42':'110學年度電子系考生家長座談會及考生申請入學口試(1)',
	'CE43':'110學年度電子系考生家長座談會及考生申請入學口試(2)',
	'CE44':'2021長庚大學畢業季—全部都是長庚人',
	'CE45':'畢業季活動志工',
	'CE46':'長庚室內樂集2021校內公演',
	'CE47':'文化講座-77場次',
	'CE48':'文化講座-78場次',
	'CE49':'藝術講座「可見與不可見–從能量轉換的角度看藝術」',
	'CE50':'109學年度資工系畢業茶會',
	'CE51':'生輔組109學年度畢業典禮',
	'CE52':'你的櫃子不是你的櫃子-談多園性別的出櫃困境與協助因應',
	'CE53':'110年追思大會典禮組',
	'CE54':'109學年度第二學期藝文活動',
	'CE55':'110年追思大會',
	'CE56':'109學年度畢業典禮接待組',
	'CE57':'110學年度電機系大學部申請入學面試(1)',
	'CE58':'110學年度電機系大學部申請入學面試(2)',
	'CE59':'109學年度電機系畢業茶會',
	'CE60':'生物科技產業碩士學位學程系所自我評鑑',
	'CE61':'生醫系評鑑訪視活動',
	'CE62':'春日藝術節',
	'CE63':'長庚大學校系博覽會',
	'CE64':'深耕樂活-校園健走活動',
	'CD01':'師生心聯繫',
	'CD02':'參與社團活動籌畫',
	'CD03':'好漢坡競賽',
	'CD04':'社團成發表演者',
	'CD05':'校外活動競賽參賽',
	'CD06':'社團協調會',
	'CD07':'班代大會',
	'CD08':'宿舍樓層協調會',
	'CD09':'師生座談會',
	'CD10':'參與學校公共性會議',
	'CD11':'參與系上辦理活動',
	'DF01':'繳交深耕學園課程期中報告',
	'DF02':'繳交深耕學園課程期末報告',
	'DD01':'校內社團評鑑',
	'DD02':'校外社團評鑑',
	'DD03':'服務學習成果發表會',
	'DD04':'志工特殊訓練課程',
	'DD05':'宿舍生活講座(1)',
	'DD06':'宿舍生活講座(2)',
	'DD07':'宿舍生活講座(3)',
	'DD08':'宿舍生活講座(4)',
	'DD09':'宿舍生活講座(5)',
	'DD10':'宿舍生活講座(6)',
	'ED01':'宿舍整潔比賽及格',
	'ED02':'機車安全講習',
	'ED03':'參與春暉講座或法治教育活動',
	'FD01':'院月會',
	'FD02':'擔任社團活動負責人',
	'FD03':'校內活動競賽得名',
	'FD04':'校外活動競賽得名',
	'FD05':'參與學務處辦理的相關活動',
	'GG01':'參與一般計分活動',
	'GG02':'參與額外計分活動',
	'HH01':'4/20完成全人素養軟實力RPG遊戲註冊',
	'HH02':'生命教育徵稿活動',
	'HH03':'公益心‧閱讀趣：主題書展閱讀分享',
	'HH04':'愛‧傳承：二手書籍交換',
	'HH05':'愛‧延續：愛心捐血',
	'HH06':'深耕樂活-校園健走活動',
	'HH07':'第六屆長庚環校路跑接力賽',
	'HH08':'彩虹天空-自由的平權翅膀',
	'HH09':'2021年工業設計學系教學創意成果展',
	'HH10':'數位科技於醫療及健康照護之應用',
	'HH11':'愛‧傳遞：借書贈花',
	'HH12':'同儕輔導-同理心訓練工作坊',
	'HH13':'僑生國際文化週',
	'HH14':'國際小食_琅琅上口「夾」東「夾」西樂不停',
}

#顯示資訊
var news_list=[]
