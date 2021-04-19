extends Node2D
#遊戲的main
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數


var have_team = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()	
	Data.connect("refresh",self,"refresh_information")
	Data.connect("activity_window_open",self,"_open_activity_window")
	
	#初始化
	send_info_request()
	send_map_request()
	send_activity_request()
	send_emergency_info_request()
	send_news_request()
		
func _set_up():#使用_set_up會把目前global的資料設定到 所有的顯示和需要的資料的地方 並檢查稱號
	# Because following data have not request to server
	#	the following command will set data to default value in Global
	# All data will update when each request sucess
	
	refresh_information_information()	
	refresh_unused_puzzle_information()	
	refresh_emergency_information()
	refresh_leaderboard_information()		
	refresh_activity_information()	
	refresh_team_information()
	#小徑
	$special_puzzle1.visible=false
	$special_puzzle2.visible=false
	$special_puzzle3.visible=false
	$special_hint.visible=false

func refresh_information():
	refresh_information_information()
	refresh_unused_puzzle_information()
	refresh_emergency_information()
	refresh_leaderboard_information()
	refresh_activity_information()
	refresh_team_information()
	refresh_icon()
	refresh_puzzle_store_information()
	refresh_special_puzzle()
	refresh_news()
	
	
func refresh_information_information():
	#資訊欄
	$information.subject_user = Data.subject_user
	$information.number_user = Data.number_user
	$information.name_user = Data.name_user
	$information.nickname_user =  Data.nickname_user
	$information.total_puzzle_user =  Data.total_puzzle_user
	$information.title_user =  Data.title_user
	$information.team_user =  Data.team_user
	$information.total_point_user = Data.total_point
	$information._set_up() #套入格式設定

func refresh_unused_puzzle_information():
	#未拼的拼圖
	$unfinished_puzzle.puddle=Data.puddle_user
	$unfinished_puzzle.wilderness=Data.wilderness_user
	$unfinished_puzzle.desert=Data.desert_user
	$unfinished_puzzle.sea=Data.sea_user
	$unfinished_puzzle.town=Data.town_user
	$unfinished_puzzle.volcano=Data.volcano_user	
	$unfinished_puzzle._set_up()

func refresh_emergency_information():
	#設定突發事件
	$emergency.finished_puzzle=Data.finished_puzzle_user	

func refresh_leaderboard_information():
	#設定排行榜
	$leader_board_group/leader_board/person_text/first.text=Data.top_ten_person[0]["nickname"]
	$leader_board_group/leader_board/person_text/second.text=Data.top_ten_person[1]["nickname"]
	$leader_board_group/leader_board/person_text/third.text=Data.top_ten_person[2]["nickname"]
	$leader_board_group/leader_board/person_text/four.text=Data.top_ten_person[3]["nickname"]
	$leader_board_group/leader_board/person_text/five.text=Data.top_ten_person[4]["nickname"]
	$leader_board_group/leader_board/person_text/six.text=Data.top_ten_person[5]["nickname"]
	$leader_board_group/leader_board/person_text/seven.text=Data.top_ten_person[6]["nickname"]
	$leader_board_group/leader_board/person_text/eight.text=Data.top_ten_person[7]["nickname"]
	$leader_board_group/leader_board/person_text/night.text=Data.top_ten_person[8]["nickname"]
	$leader_board_group/leader_board/person_text/ten.text=Data.top_ten_person[9]["nickname"]
	
	$leader_board_group/leader_board/team_text/first.text=Data.top_ten_team[0]["teamname"]
	$leader_board_group/leader_board/team_text/second.text=Data.top_ten_team[1]["teamname"]
	$leader_board_group/leader_board/team_text/third.text=Data.top_ten_team[2]["teamname"]
	$leader_board_group/leader_board/team_text/four.text=Data.top_ten_team[3]["teamname"]
	$leader_board_group/leader_board/team_text/five.text=Data.top_ten_team[4]["teamname"]
	$leader_board_group/leader_board/team_text/six.text=Data.top_ten_team[5]["teamname"]
	$leader_board_group/leader_board/team_text/seven.text=Data.top_ten_team[6]["teamname"]
	$leader_board_group/leader_board/team_text/eight.text=Data.top_ten_team[7]["teamname"]
	$leader_board_group/leader_board/team_text/night.text=Data.top_ten_team[8]["teamname"]
	$leader_board_group/leader_board/team_text/ten.text=Data.top_ten_team[9]["teamname"]
	
	

func refresh_activity_information():
	#活動頁面
	$activity/activity._set_up(Data.get_activity_info_list())

func refresh_team_information():
	#組隊頁面(組隊+團隊資訊)
	$team._set_up(Data.team_user,Data.team_id,Data.team_tatal_puzzle,Data.team_member_list)
	#隊名,組隊代碼,隊伍拼圖總數,成員資料list

func refresh_puzzle_store_information():
	$puzzle_storehouse._refresh_info()

func refresh_icon():
	$icon0.visible=false
	$icon1.visible=false
	$icon2.visible=false
	$icon3.visible=false
	$icon4.visible=false
	$icon5.visible=false
	$icon6.visible=false
	var icon_type=Data._get_puzzle_type_with_biggest_number()
	if icon_type==0:
		$icon0.visible=true
	if icon_type==1:
		$icon1.visible=true
	if icon_type==2:
		$icon2.visible=true
	if icon_type==3:
		$icon3.visible=true
	if icon_type==4:
		$icon4.visible=true
	if icon_type==5:
		$icon6.visible=true
	if icon_type==6:
		$icon6.visible=true

func refresh_special_puzzle():
	Data._check_receive_special_puzzle()
	check_special_hint()

func _open_activity_window():
	$activity/activity.visible=true
	$activity/activity._set_up(Data.get_activity_info_list())#獲取目前global內的資料
	$activity/activity/page_01.visible=true
	$activity/activity/page_02.visible=false
	$activity/activity/page_03.visible=false
	$activity/activity/page_04.visible=false

func have_team():
	if have_team:#這邊要放入可判斷是否組隊的參數
		return true
	else:
		return false

func _on_team_button_pressed():
	if have_team():
		send_team_request()
	set_buttons_visibility(false)
	$team.visible=true
	refresh_team_scene_status()

func refresh_team_scene_status():
	$team._set_up(Data.team_user,Data.team_id,Data.team_tatal_puzzle,Data.team_member_list)#隊名,組隊代碼,隊伍拼圖總數,成員資料list
	if have_team(): #已組隊
		$team/information.visible=true
		$team/team_up.visible=false
	else:
		$team/information.visible=false
		$team/team_up.visible=true
#quit
func _on_Button_pressed():
	get_tree().quit()

func map_put(block_type,pos):
	var put_body := {"type" : 'map_oper',"validation": Data.login_certification
	,"oper" : 'put', "block_type" : block_type, "pos" : pos}
	send_server_request(put_body)
func map_upgrade1(block_type,pos):
	print('send upgrade request')
	var upgrade1_body := {"type" : 'map_oper',"validation": Data.login_certification
	,"oper" : 'upgrade1', "block_type" : block_type, "pos" : pos}
	send_server_request(upgrade1_body)
func map_upgrade2(block_type,pos):
	var upgrade2_body := {"type" : 'map_oper',"validation": Data.login_certification
	,"oper" : 'upgrade2', "block_type" : block_type, "pos" : pos}
	send_server_request(upgrade2_body)
func send_info_request():	
	#sending info request
	var info_body := {"type" : 'info',"validation": Data.login_certification}
	send_server_request(info_body)

func send_team_request():
	#sending team request
	var team_body := {"type" : 'team',"validation": Data.login_certification}
	send_server_request(team_body)

func send_create_team_request():
	#sending team request
	var create_team_body := {"type" : 'create_team',"validation": Data.login_certification,"team_name":"test"}
	send_server_request(create_team_body)
	
func send_map_request():
	#sending map request
	var map_body := {"type" : 'map',"validation": Data.login_certification}
	send_server_request(map_body)
	
func send_place_click_request():
	#sending place_click request
	var place_click_body := {"type" : 'place_click',"validation": Data.login_certification}
	send_server_request(place_click_body)

func send_special_request(value,set):
	#sending place_click request
	var special_body := {"type" : 'special',"validation": Data.login_certification,"value":value,"set":set}
	send_server_request(special_body)

func send_add_title_request(number):
	#sending map request
	var add_title_body := {"type":'title_oper',"oper":"add","number":number,"validation":Data.login_certification}
	print("add title"+str(number))
	send_server_request(add_title_body)
	
func send_set_title_request(number):
	#sending title select request
	var title_oper_body := {"type" : 'title_oper',"oper":"use","validation": Data.login_certification,"number":number}
	send_server_request(title_oper_body)
	
func send_activity_request():
	#sending map request
	var activity_body := {"type" : 'activity',"validation": Data.login_certification}
	send_server_request(activity_body)
	
func send_emergency_request(map_type,amount,correct,event_id,point):
	#sending emergency request
	var emergency_body := {"type" : 'emergency',"validation": Data.login_certification,"map_type":map_type,"amount":amount,"correct":correct,"event_id":event_id,"command_type":"add_map",'point':point}
	send_server_request(emergency_body)

func send_emergency_record_request(correct,event_id,point): #use for sending record to server
	var emergency_body := {"type" : 'emergency',"validation": Data.login_certification,"map_type":-1,"amount":-1,"correct":correct,"event_id":event_id,"command_type":"record",'point':point}
	send_server_request(emergency_body)
	var solve_event_time = str(2)+str(Data.emergency_time)
	var emergency_time_body := {"type" : 'emergency_time','command_type':'set','time':solve_event_time,"validation": Data.login_certification}
	send_server_request(emergency_time_body)
	Data.emergency_status = 2 #set immediately to prevent another task show up at the same time
	
func send_emergency_info_request():
	#sending emergency_info request
	var emergency_info_body := {"type" : 'emergency_info',"validation": Data.login_certification}
	send_server_request(emergency_info_body)
	
func send_emergency_time_request(time):
	#sending emergency_info request
	var emergency_time_body := {"type" : 'emergency_time','command_type':'set','time':time,"validation": Data.login_certification}
	send_server_request(emergency_time_body)
	
func send_rank_request(rank_type):
	#sending rank request
	var rank_body := {"type" : 'rank',"rank_type":rank_type}
	send_server_request(rank_body)

func send_news_request():
	#sending rank request
	var news_body := {"type" : 'news'}
	send_server_request(news_body)

#the following function 
#              maintain request queue system
#---------------------------------------------------------------------------
var request_queue = []
var headers = ["Content-Type: application/json"]

func send_server_request(body):	
	request_queue.append([body,0])
	#requesst queue status 0:queue 1:waiting result
	if(len(request_queue)>0 && request_queue[0][1] == 0): #first element in queue status
		#send requesst
		$HTTPRequest.request(Data.BACKGROUND_WEB,headers,Data.SSL_USE,HTTPClient.METHOD_POST,to_json(request_queue[0][0]))
		Data.debug_msg(2,'sending : '+str(request_queue[0]))
		request_queue[0][1] = 1

func check_request_queue():
	if(len(request_queue)>0 && request_queue[0][1] == 0): #first element in queue status
		#send requesst
		$HTTPRequest.request(Data.BACKGROUND_WEB,headers,Data.SSL_USE,HTTPClient.METHOD_POST,to_json(request_queue[0][0]))
		Data.debug_msg(2,'sending : '+str(request_queue[0]))
		request_queue[0][1] = 1

func finish_request_queue(type):
	#print(request_queue)
	if(len(request_queue)>0):
		for i in range(len(request_queue)):
			if(request_queue[i][0]['type'] == type && request_queue[i][1] == 1):
				request_queue.remove(i)
				check_request_queue()
				break;
#----------------------------------------------------------------------------
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var respond = body.get_string_from_utf8()
	if(Data.DEBUG_MODE == 2):
		Data.debug_msg(2,respond)
	var data_parse = JSON.parse(respond)
	if data_parse.error != OK:
		return
	var data = data_parse.result
	
	if(Data.DEBUG_MODE == 1):
		Data.debug_msg(1,"{"+data['type']+" "+data['sucess']+"}")
	
	if(data['type'] == 'info'):
		if(data['sucess'] == 'true'):
			Data.number_user = data['number']
			Data.name_user = data['name']
			Data.nickname_user = data['nickname']
			if(Data.nickname_user == ''):
				Data.nickname_user = '未設定'
			for i in range(len(data['title'])):
				Data.title_status[str(i)] = int(data['title'][i]);
			if(data['title_use']!="-1"):
				Data.title_user = Data.title_list[data['title_use']]
			else:
				Data.title_user = '未設定'
			Data.subject_user = data['department']
			Data.personal_rank = int(data['rank'])
			
			#send_map_request() #send team request
			if(data['teamid'] == null):
				Data.team_user = '未設定'
			else:
				have_team = true 
				send_team_request()
			refresh_information_information()
				
		else:
			Data.debug_msg(0,"Error fetch info data!!!")
					
	elif(data['type'] == 'team'):
		if(data['sucess'] == 'true'):
			Data.team_user = data['name']
			Data.team_id = data['teamid']
			Data.team_point = int(data['point'])
			Data.team_rank = int(data['rank'])
			
			#for i in range(10):
			#	Data.team_member_list[i]['學號'] = data['mem'+str(i+1)]
		else:
			Data.debug_msg(0,"Error fetch team data!!!")
		Data._check_title_status()
		refresh_information_information()
		$team.send_team_member_request()	
		
	elif(data['type'] == 'map'):
		if(data['sucess'] == 'true'):
			# folloing update puzzle info
			Data.puddle_user = int(data['unused1'])
			Data.wilderness_user = int(data['unused2'])
			Data.desert_user = int(data['unused3'])
			Data.sea_user = int(data['unused4'])
			Data.town_user = int(data['unused5'])
			Data.volcano_user = int(data['unused6'])
			var count = data['pos'].length()/4
			for i in range(count):
				#print(data['pos'].substr(i*4,4)+" "+data['val'].substr(i*2,2))
				Data.status_user[data['pos'].substr(i*4,4)] = data['val'].substr(i*2,2)
			Data.finished_puzzle_user = int(data['used'])
			Data.total_point = int(data['point'])
			Data.special_puzzle_status = data['special']
			Data.button_click_time = int(data['place_click'])
			_refresh_map_information()
			refresh_unused_puzzle_information()
			refresh_emergency_information()
		else:
			Data.debug_msg(0,"Error fetch map data!!!")
					
	elif(data['type'] == 'activity'):
		if(data['sucess']=='true'):
			for i in range(int(data['count'])):
				var insert_act = {'代號':data['number'+str(i)],'獎勵':data['point'+str(i)]}
				Data.activity_list.append(insert_act)
			refresh_activity_information()
		else:
			Data.debug_msg(0,"Error fetch activity data!!!")
					
	elif(data['type'] == 'create_team'):
		if(data['sucess']=='true'):
			send_team_request()
		else:
			Data.debug_msg(0,"Unaccept create team request!!!")
						
	elif(data['type'] == 'map_oper'):
		if(data['sucess']=='true'):
			#data['block_type']
			#var count = data['pos'].length()/4
			#for i in range(count):
				#print(data['pos'].substr(i*4,4)+" "+data['val'].substr(i*2,2))
			#	Data.status_user[data['pos'].substr(i*4,4)] = data['val'].substr(i*2,2)
			#_refresh_map_information()
			# if move puzzle amount funtion here , there stil need other function
			# reference to 'map' request
			send_map_request()
		else:
			Data.debug_msg(0,"Unaccept map operation request!!!")
			
	elif(data['type'] == 'emergency'):
		if(data['sucess']=='true'):
			if(data['command_type']=='record'):
				send_map_request()
		else:
			Data.debug_msg(0,"Unaccept emergency request!!!")
	
	elif(data['type'] == 'emergency_info'):
		if(data['sucess']=='true'):
			var emergency_history = data['emergency_list']
			for i in range(len(emergency_history)):
				Data.event_status_list[i] = int(emergency_history[i])
			
			Data.emergency_status = int(data['emergency_time'][0])
			Data.emergency_time = int(data['emergency_time'].substr(1))
			Data._set_emergency_cd_time()
			check_emergency_time_valid()
			
			Data.emergency_correct_time = int(data['emergency_best'])
			Data.emergency_solve_time = int(data['emergency_finish'])
			Data.debug_msg(2,"Emergency Finish : "+str(Data.emergency_solve_time))
		else:
			Data.debug_msg(0,"Unable fatch emergency info data!!!")
			
	elif(data['type'] == 'emergency_time'):
		if(data['sucess']=='true'):
			Data.emergency_status = int(data['time'][0])
			Data.emergency_time = int(data['time'].substr(1))
		else:
			Data.debug_msg(0,"Error Setting Emergency Time!")
			
	elif(data['type'] == 'title_oper'):
		if(data['sucess']=='true'):
			send_info_request()
		else:
			if(data['error']=='already_have'):
				pass
			else:
				Data.debug_msg(0,"Unaccept title request!!!")
	
	elif(data['type'] == 'rank'):
		if(data['sucess']=='true'):
			for i in range(10):
				if(data['rank_type']=='person'):
					if(data['rank'+str(i+1)+'name'] != '-1'):
						Data.top_ten_person[i]['nickname'] = data['rank'+str(i+1)+'nickname']
						Data.top_ten_person[i]['name'] = data['rank'+str(i+1)+'name']
						Data.top_ten_person[i]['number'] = data['rank'+str(i+1)+'number']
						Data.top_ten_person[i]['department'] = data['rank'+str(i+1)+'department']
						Data.top_ten_person[i]['title'] = data['rank'+str(i+1)+'title_use']
						Data.top_ten_person[i]['total_puzzle'] = data['rank'+str(i+1)+'point']
						#print('used'+Data.top_ten_person[i]['total_puzzle'] )
					else: # no data for this rank
						pass # default text is '尚無排名'
				else: #team
					if(data['rank'+str(i+1)+'name'] != '-1'):
						Data.top_ten_team[i]['teamname'] = data['rank'+str(i+1)+'name']
						Data.top_ten_team[i]['total_puzzle'] = data['rank'+str(i+1)+'point']
					else: # no data for this rank
						pass
			refresh_leaderboard_information()
			$leader_board_group/leader_board.refresh_rank_data()
		else:
			Data.debug_msg(0,"Fetch Rank Error!")
	
	elif(data['type'] == 'news'):
		if(data['sucess'] == 'true'):
			var count = int(data['count'])
			for i in range(count):
				Data.news_list.append(data['news'+str(i)+'title'])
		else:
			Data.debug_msg(0,"Unable fetch news data!")			
	
	elif(data['type'] == 'special'):
		if(data['sucess'] == 'true'):
			Data.special_puzzle_status = data['value']
			send_map_request()
		else:
			Data.debug_msg(0,"Unable set special puzzle!")

	elif(data['type'] == 'place_click'):
		if(data['sucess'] == 'true'):
			Data.button_click_time += 1
		else:
			Data.debug_msg(0,"Unable set place click!")

	elif(data['type'] == 'logout'):
		if(data['sucess'] == 'false'):
			Data.debug_msg(0,"Authentication Error : Timeout!")
			get_tree().change_scene("res://Control.tscn")	

	finish_request_queue(data['type'])
	#Data._check_title_status()
	_refresh_all_data()

func check_emergency_time_valid():
	var time_excess = OS.get_unix_time()-Data.emergency_time
	var next_emergency_status = Data.emergency_status
	if(time_excess<0):
		return
	while(time_excess>0):
		if(next_emergency_status==1 || next_emergency_status==2):
			time_excess -= Data.EMERGENCY_CD_TIME
			next_emergency_status = 0
		elif(next_emergency_status==0):
			time_excess -= Data.EMERGENCY_UP_TIME
			next_emergency_status = 1
	var next_emergency_time = OS.get_unix_time()-time_excess
	send_emergency_time_request(str(next_emergency_status)+str(next_emergency_time))
		
func _refresh_all_data():
	Data._set_up_puzzle_amount_info()
	Data._set_up_puzzle_upgrade_info()
	#_refresh_information()
	Data.emit_refresh()
	
func _refresh_map_information(): #使用此函式可以設定好所有狀態 可用Data.emit_refresh()發出訊號來呼叫
	Data._refresh_data() #更新global內需要設定的資料
	#_set_up()
	$puzzles_map._refresh_map()
	$cgu_puzzles_map._refresh_map()
	$special_puzzle1._set_up()
	$special_puzzle2._set_up()
	$special_puzzle3._set_up()

func _on_puzzle_map_button_pressed():
	set_buttons_visibility(false)
	$puzzles_map.visible=true


func _on_cug_puzzles_map_button_pressed():
	set_buttons_visibility(false)
	$cgu_puzzles_map.visible=true
	Data.add_button_click_time(1)


func _on_leader_board_button_pressed():
	set_buttons_visibility(false)
	send_rank_request('person')
	send_rank_request('team')
	$leader_board_group/leader_board.visible=true
	




func set_buttons_visibility(bool_value):
	$puzzle_map_button.visible=bool_value
	$cug_puzzles_map_button.visible=bool_value
	$cug_puzzles_map_button2.visible=bool_value
	$leader_board_group/leader_board_button.visible=bool_value
	$title_storehouse/title_storehouse2.visible=bool_value
	$title_storehouse/title_storehouse3.visible=bool_value
	$activity/activity_button.visible=bool_value
	$puzzle_storehouse_button.visible=bool_value
	$team_button.visible=bool_value
	$path1/path1.visible=bool_value
	$path2/path2.visible=bool_value
	$path3/path3.visible=bool_value
	
	
func check_special_hint():
	if Data._get_special_puzzle_status(1)=="10" and Data._get_special_puzzle_status(2)=="10" and Data._get_special_puzzle_status(3)=="00":
		$special_hint.visible=true
	else:
		$special_hint.visible=false

func set_signpost_text(text):
	$signpost.text=text


func _on_puzzle_storehouse_button_mouse_entered():
	set_signpost_text("拼圖倉庫")


func _on_activity_button_mouse_entered():
	set_signpost_text("活動資訊")


func _on_team_button_mouse_entered():
	set_signpost_text("組隊/組隊資訊")


func _on_title_storehouse2_mouse_entered():
	set_signpost_text("稱號倉庫")


func _on_leader_board_button_mouse_entered():
	set_signpost_text("排行榜")


func _on_puzzle_map_button_mouse_entered():
	set_signpost_text("大拼圖")


func _on_cug_puzzles_map_button_mouse_entered():
	set_signpost_text("CGU拼圖")
	
func _on_path_mouse_entered():
	set_signpost_text("小徑")

func _on_TextureButton_mouse_entered():
	set_signpost_text("未拼上拼圖數")


	
func clear_signpost_text():
	set_signpost_text("")

var lines_limit_num=6
var line_char_num=15
func refresh_news():
	var news_list=Data.get_news_list()
	var append_string=""
	var text_line_num=0
	$news/news.text=""
	for news in news_list:
		append_string=change_line(news,line_char_num)
		text_line_num+=line_num
		if text_line_num>lines_limit_num: 
			break
		$news/news.text+=append_string+"\n"
		
var line_num
func change_line(string,num):
	var result=""
	line_num=1
	for i in range(len(string)):
		if i%num==0 and i!=0:
			result+="\n"
			line_num+=1
		result+=string[i]
	return result
	
		


