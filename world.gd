extends Node2D
#遊戲的main
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數

var headers = ["Content-Type: application/json"]
var request_queue = []

var have_team = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()
	Data.connect("refresh",self,"_refresh_information")
	Data.connect("slect_window_open",self,"_open_slect_window")
	#製作初始化對列系統
	send_info_request()
	send_map_request()
	send_activity_request()
		
func _set_up():#使用_set_up會把目前global的資料設定到 所有的顯示和需要的資料的地方 並檢查稱號
	#Data._check_title_status()#檢查和設定稱號
	
	#資訊欄
	$information.subject_user = Data.subject_user
	$information.number_user = Data.number_user
	$information.name_user = Data.name_user
	$information.nickname_user =  Data.nickname_user
	$information.total_puzzle_user =  Data.total_puzzle_user
	$information.title_user =  Data.title_user
	$information.team_user =  Data.team_user
	#未拼的拼圖
	$unfinished_puzzle.puddle=Data.puddle_user
	$unfinished_puzzle.wilderness=Data.wilderness_user
	$unfinished_puzzle.desert=Data.desert_user
	$unfinished_puzzle.sea=Data.sea_user
	$unfinished_puzzle.town=Data.town_user
	$unfinished_puzzle.volcano=Data.volcano_user
	
	
	$information._set_up() #套入格式設定
	$unfinished_puzzle._set_up()
	#設定突發事件
	$emergency.finished_puzzle=Data.finished_puzzle_user
	
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
	
	#活動頁面
	$activity._set_up(Data.activity_list)
	
	#組隊頁面(組隊+團隊資訊)
	$team._set_up(Data.team_user,Data.team_id,Data.team_tatal_puzzle,Data.team_member_list)#隊名,組隊代碼,隊伍拼圖總數,成員資料list
			

func _refresh_information(): #使用此函式可以設定好所有狀態 可用Data.emit_refresh()發出訊號來呼叫
	Data._refresh_data() #更新global內需要設定的資料
	_set_up()
	_refresh_map()


func _refresh_map():
	$AA01._status_set_up()
	$AA02._status_set_up()
	$AA03._status_set_up()
	$AA04._status_set_up()
	$AA05._status_set_up()
	$AB01._status_set_up()
	$AB02._status_set_up()
	$AB03._status_set_up()
	$AB04._status_set_up()
	$AB05._status_set_up()

func _open_slect_window():
	$activity.visible=true
	$activity._set_up(Data.activity_list)#獲取目前global內的資料
	$activity/page_01.visible=true
	$activity/page_02.visible=false
	$activity/page_03.visible=false
	$activity/page_04.visible=false

func have_team():
	if have_team:#這邊要放入可判斷是否組隊的參數
		return true
	else:
		return false

func _on_team_button_pressed():
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
	
func send_add_title_request(number):
	#sending map request
	var add_title_body := {"type":'title_oper',"oper":"add","number":number,"validation":Data.login_certification}
	print("add title"+str(number))
	send_server_request(add_title_body)
	
func send_set_title_request(number):
	#sending title select request
	var title_oper_body := {"type" : 'title_oper',"validation": Data.login_certification,"number":number}
	send_server_request(title_oper_body)
	
func send_activity_request():
	#sending map request
	var activity_body := {"type" : 'activity',"validation": Data.login_certification}
	send_server_request(activity_body)
	
func send_emergency_request(map_type,amount,correct):
	#sending emergency request
	var emergency_body := {"type" : 'emergency',"validation": Data.login_certification,"map_type":map_type,"amount":amount,"correct":correct}
	send_server_request(emergency_body)
	
#the following function 
#              maintain request queue system
func send_server_request(body):
	request_queue.append([body,0])
	#requesst queue status 0:queue 1:waiting result
	if(len(request_queue)>0 && request_queue[0][1] == 0): #first element in queue status
		#send requesst
		$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(request_queue[0][0]))
		request_queue[0][1] = 1

func check_request_queue():
	if(len(request_queue)>0 && request_queue[0][1] == 0): #first element in queue status
		#send requesst
		$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(request_queue[0][0]))
		request_queue[0][1] = 1

func finish_request_queue(type):
	#print(request_queue)
	if(len(request_queue)>0 && (request_queue[0][0]['type'] == type && request_queue[0][1] == 1)):
		request_queue.remove(0)
		check_request_queue()

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var respond = body.get_string_from_utf8()
	#print(respond)
	var data_parse = JSON.parse(respond)
	if data_parse.error != OK:
		return
	var data = data_parse.result	
	print("{"+data['type']+" "+data['sucess']+"}")
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
			#send_map_request() #send team request
			if(data['teamid'] == '-1'):
				Data.team_user = '未設定'
			else:
				have_team = true 
				send_team_request()
		else:
			print("Error fetch info data!!!")
					
	elif(data['type'] == 'team'):
		if(data['sucess'] == 'true'):
			Data.team_user = data['name']
			Data.team_id = data['teamid']
			for i in range(10):
				Data.team_member_list[i]['學號'] = data['mem'+str(i+1)]
		else:
			print("Error fetch team data!!!")
		Data._check_title_status()
		$team.send_team_member_request()		
		
	elif(data['type'] == 'map'):
		if(data['sucess'] == 'true'):
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
		else:
			print("Error fetch map data!!!")
		#send_activity_request()
			
	elif(data['type'] == 'activity'):
		if(data['sucess']=='true'):
			for i in range(int(data['count'])):
				var insert_act = {'活動名稱':data['title'+str(i)],'時間':data['time'+str(i)]
				,'代號':data['number'+str(i)],'獎勵':data['point'+str(i)]}
				Data.activity_list.append(insert_act)
		else:
			print("Error fetch activity data!!!")
		#print(Data.activity_list)
		#if(have_team):
		#	send_team_request()
			
	elif(data['type'] == 'create_team'):
		if(data['sucess']=='true'):
			send_team_request()
		else:
			print("Unaccept create team request!!!")
						
	elif(data['type'] == 'map_oper'):
		if(data['sucess']=='true'):
			pass
		else:
			print("Unaccept map operation request!!!")
			
	elif(data['type'] == 'emergency'):
		if(data['sucess']=='true'):
			send_map_request()
		else:
			print("Unaccept emergency request!!!")
			
	elif(data['type'] == 'title_oper'):
		if(data['sucess']=='true'):
			send_info_request()
		else:
			if(data['error']=='already_have'):
				pass
			else:
				print("Unaccept title request!!!")
	finish_request_queue(data['type'])
	Data._check_title_status()
	Data.emit_refresh()
	#_refresh_information()

