extends Control
#這裡目前有3個物件，分別是login/world/puzzle請從左下角的欄位中先找到tscn檔並打開，新增新物件時請更新本行
#2麻煩妳先跟1討論，並設定好3個帳號，以利接下來你要設置各種畫面時的有效性
var player_account = []
#signal request_completed

func _ready():
	#$HTTPRequest.connect("request_completed", self,"_on_HTTPRequest_request_completed")
	#connect_to_sever()
	pass

func _on_LineEdit_text_entered(new_text):
	player_account.append(new_text)
	#場景在輸入完id之後就會改變，這邊是1的工作，還麻煩你自行修改
	connect_to_sever()
	

func connect_to_sever():
	var headers = ["Content-Type: application/json"]
	var url = "http://www.mocky.io/v2/5185415ba171ea3a00704eed"
	var err = $HTTPRequest.request(url)
	if(err!=OK):
		print("Error Happened!")
	

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	get_tree().change_scene("res://world.tscn")

