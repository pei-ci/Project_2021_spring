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
	
	#following info for testing purpose only
	$Username.text = 'B0829024'
	username = 'B0829024'
	$UsernameLabel.text = 'B0829024'
	$Password.text = 'B0829024'
	password = 'B0829024'
	$PasswordLabel.text = 'B0829024'

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
	#var query= "email="+ username + "&password="+ password
	var body := {"type" : 'login',"number": username, "password": password}
	#print(body)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(body))

func register_to_server(name,nickname,department):
	#var query= "email="+ username + "&password="+ password
	var body := {"type" : 'register',"number": username, "password": password
	,"department" : department ,"name": name,"nickname":nickname}
	print(body)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(body))

func log_login_to_server():
	#var query= "email="+ username + "&password="+ password
	var body := {"type" : 'log',"validation": Data.login_certification,'log_type':'login','value':'1'}
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(body))


func _on_HTTPRequest_request_completed(result, response_code, headers, body):	
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
			#print(Data.login_certification)
			log_login_to_server()
		else:
			print("Login Error : Unknown!");
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
