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
	pass

func _on_LineEdit_text_entered(text):
	#player_account.append(new_text)
	#場景在輸入完id之後就會改變，這邊是1的工作，還麻煩你自行修改
	pass
	
func _on_user_changed(text):
	username = text

func _on_password_changed(text):
	password = text
	
func _on_LineEdit2_text_entered(text):	
	login_to_server()


func login_to_server():
	#var query= "email="+ username + "&password="+ password
	var body := {"type" : 'login',"number": username, "password": password}
	#print(body)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(body))

func register_to_server():
	#var query= "email="+ username + "&password="+ password
	var body := {"type" : 'register',"number": username, "password": password
	,"department" : '1',"name": 'test'}
	#print(body)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost/cgu_games/login.php",headers,false,HTTPClient.METHOD_POST,to_json(body))

func _on_HTTPRequest_request_completed(result, response_code, headers, body):	
	var respond = body.get_string_from_utf8()
	print(respond);
	var data_parse = JSON.parse(respond)
	if data_parse.error != OK:
		return
	var data = data_parse.result
	if(data['type']=='login'):
		if(data['sucess'] == 'true'):
			Data.login_certification = data["validation"]
			#print(Data.login_certification)
			print("Login Success!")
			get_tree().change_scene("res://world.tscn")	
		else:
			print("Login Error : Unknown!");
	elif(data['type'] == 'register'):
		if(data['sucess']=='true'):
			login_to_server()
		else:
			if(data['error'] == 'user_exist'):
				print("Register Error : User Exist!")
			else:
				print("Register Error : Unknown!")	

func _on_Login_pressed():
	login_to_server()


func _on_Register_pressed():
	register_to_server()
