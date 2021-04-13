extends Control
#這裡目前有3個物件，分別是login/world/puzzle請從左下角的欄位中先找到tscn檔並打開，新增新物件時請更新本行
#2麻煩妳先跟1討論，並設定好3個帳號，以利接下來你要設置各種畫面時的有效性
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數

var username = ""
var password = ""

#signal request_completed

func _ready():
	#$HTTPRequest.connect("request_completed", self,"_on_HTTPRequest_request_completed")
	#connect_to_sever()
	$Register.visible = false

func _on_LineEdit_text_entered(text):
	#player_account.append(new_text)
	#場景在輸入完id之後就會改變，這邊是1的工作，還麻煩你自行修改
	pass
	
func _on_user_changed(text):
	$UsernameLabel.text = text
	username = text

func _on_password_changed(text):
	$PasswordLabel.text = text
	password = text
	
func _on_LineEdit2_text_entered(text):	
	if (check_input()):
		login_to_server()


func login_to_server():
	var body := {"type" : 'login',"number": username, "password": password}
	send_server_request(body)

func register_to_server(name,nickname,department):
	var body := {"type" : 'register',"number": username, "password": password
	,"department" : department ,"name": name,"nickname":nickname}
	send_server_request(body)

func log_login_to_server():
	# here need to turn unix time into date formate 
	#	to check if last login is in last date, which will increase login_count
	var change_day = 0
	if(OS.get_datetime_from_unix_time(Data.login_time)['day']!=OS.get_datetime_from_unix_time(OS.get_unix_time())['day']):
		change_day = 1
	var body := {"type" : 'log',"validation": Data.login_certification,'log_type':'login','value':change_day}
	send_server_request(body)
	
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
	print(result)
	var respond = body.get_string_from_utf8()
	var data_parse = JSON.parse(respond)
	if data_parse.error != OK:
		return
	var data = data_parse.result
	
	if(Data.DEBUG_MODE == 1):
		Data.debug_msg(1,"{"+data['type']+" "+data['sucess']+"}")	
	elif(Data.DEBUG_MODE == 2):
		Data.debug_msg(2,respond)


	if(data['type']=='login'):
		if(data['sucess'] == 'true'):
			Data.login_certification = data["validation"]
			Data.login_time = int(data['login_time'])
			#print(Data.login_certification)
			log_login_to_server()
		else:
			Data.debug_msg(0,"Login Error : Unknown!")
	elif(data['type'] == 'register'):
		if(data['sucess']=='true'):
			login_to_server()
		else:
			if(data['error'] == 'user_exist'):
				Data.debug_msg(0,"Register Error : User Exist!")
			else:
				Data.debug_msg(0,"Register Error : Unknown!")
	elif(data['type'] == 'log'):
		if(data['sucess']=='true'):
			Data.debug_msg(1,"Login and Log Success!")
			get_tree().change_scene("res://world.tscn")			
		else:
			Data.debug_msg(0,"Log Login Error : Unknown!")
	finish_request_queue(data['type'])
func check_input():
	if ((len(username)>=8 && len(username)<=9) && password!=""):
		return true
	return false


func _on_NewLoginButton_pressed():
	if (check_input()):
		login_to_server()	

func _on_NewRegisterButton_pressed():
	if (check_input()):
		$Register.visible = true
		#register_to_server()
