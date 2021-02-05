extends Node2D
#遊戲的main
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var headers = ["Content-Type: application/json"]
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()
	Data.connect("refresh",self,"_refresh_information")
	send_info_request()
	
func _set_up():
	#資訊欄
	$information.subject_user = Data.subject_user
	$information.number_user = Data.number_user
	$information.name_user = Data.name_user
	$information.nickname_user =  Data.nickname_user
	$information.total_puzzle_user =  Data.total_puzzle_user
	$information.title_user =  Data.title_user
	$information.team_user =  Data.team_user
	#資訊_未拼的拼圖
	$information.puddle=Data.puddle_user
	$information.wilderness=Data.wilderness_user
	$information.desert=Data.desert_user
	$information.sea=Data.sea_user
	$information.town=Data.town_user
	$information.volcano=Data.volcano_user
	
	$information._set_up() #套入格式設定
	#設定突發事件
	$emergency.finished_puzzle=Data.finished_puzzle_user
	
func _refresh_information():
	_set_up()
	_refresh_map()
	pass	

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
	
#quit
func _on_Button_pressed():
	get_tree().quit()

func map_put(block_type,pos):
	var put_body := {"type" : 'map_oper',"validation": Data.login_certification
	,"oper" : 'put', "block_type" : block_type, "pos" : pos}
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(put_body))

func map_upgrade1(block_type,pos):
	var upgrade1_body := {"type" : 'map_oper',"validation": Data.login_certification
	,"oper" : 'upgrade1', "block_type" : block_type, "pos" : pos}
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(upgrade1_body))
	
func map_upgrade2(block_type,pos):
	var upgrade2_body := {"type" : 'map_oper',"validation": Data.login_certification
	,"oper" : 'upgrade2', "block_type" : block_type, "pos" : pos}
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(upgrade2_body))

func send_info_request():	
	#sending info request
	var info_body := {"type" : 'info',"validation": Data.login_certification}
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(info_body))
func send_team_request():
	#sending team request
	var team_body := {"type" : 'team',"validation": Data.login_certification}
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(team_body))
func send_map_request():
	#sending map request
	var map_body := {"type" : 'map',"validation": Data.login_certification}
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(map_body))

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var respond = body.get_string_from_utf8()
	print(respond)
	var data_parse = JSON.parse(respond)
	if data_parse.error != OK:
		return
	var data = data_parse.result
	if(data['type'] == 'info'):
		if(data['sucess'] == 'true'):
			Data.number_user = data['number']
			Data.name_user = data['name']
			Data.nickname_user = data['nickname']
			if(Data.nickname_user == ''):
				Data.nickname_user = '未設定'
			Data.subject_user = data['department']
			if(data['teamid'] == '-1'):
				Data.team_user = '未設定'
			else:
				send_team_request() #after info,send team request
		else:
			print("Error fetch info data!!!")		
	elif(data['type'] == 'team'):
		if(data['sucess'] == 'true'):
			Data.team_user = data['name']
		else:
			print("Error fetch team data!!!")
		send_map_request() #after info,send team request
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
	elif(data['type'] == 'map'):
		pass
	Data.emit_refresh()
	#_refresh_information()

func test():
	print("test")
