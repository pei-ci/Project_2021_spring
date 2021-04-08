extends Sprite

onready var Data = get_node("/root/Global")
onready var world = get_node("/root/world")

var headers = ["Content-Type: application/json"]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	$team_up.visible=false
	$information.visible=true


func _set_up(team_name,team_id,team_total_puzzle,member_data_list):
	_set_information(team_name,team_id,team_total_puzzle,member_data_list)
	_set_team_up()

func _set_information(team_name,team_id,team_total_puzzle,member_data_list):
	$information/team_name.text=team_name+"(拼圖總數:"+str(team_total_puzzle)+")"
	$information/team_id.text=str(team_id)
	$information/team_information.text=""
	for member in member_data_list:
		if member["學號"]==null:
			continue
		$information/team_information.text+= "學號: "+member["學號"]+"    姓名: "+member["姓名"]+"    拼圖數量:"+str(member["拼圖數量"])+"\n"

func _set_team_up():
	$team_up/background/generate_label.text=""
	$team_up/input.text=""

func send_team_member_request():	
	var member_body := {"type" : 'team_member',"teamid":Data.team_id}
	#print(member_body)
	$HTTPRequest2.request(Data.BACKGROUND_WEB,headers,Data.SSL_USE,HTTPClient.METHOD_POST,to_json(member_body))
	

func _on_close_pressed():
	self.visible=false

func _on_generate_Button_pressed():
	if _is_input_team_name() and $team_up/background/generate_label.text=="":#當已輸入名稱 且未產生組隊代碼
		var team_name = $team_up/input_team_name.text
		send_generate_team_request(team_name)
		$team_up/background/generate_label.text = "waiting..."

func send_generate_team_request(team_name):	
	var map_body := {"type" : 'create_team',"validation": Data.login_certification,"team_name":team_name}
	$HTTPRequest2.request(Data.BACKGROUND_WEB,headers,Data.SSL_USE,HTTPClient.METHOD_POST,to_json(map_body))
	
func _on_generate_team_finished(team_id):
	$team_up/background/generate_label.text = str(team_id)

func _on_input_Button_pressed():
	var team_id = $team_up/input.text
	var map_body := {"type" : 'join_team',"validation": Data.login_certification,"teamid":team_id}
	$HTTPRequest2.request(Data.BACKGROUND_WEB,headers,Data.SSL_USE,HTTPClient.METHOD_POST,to_json(map_body))
	

func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	var respond = body.get_string_from_utf8()
	var data_parse = JSON.parse(respond)
	if data_parse.error != OK:
		return
	var data = data_parse.result	
	
	if(Data.DEBUG_MODE == 1):
		Data.debug_msg(1,"{"+data['type']+" "+data['sucess']+"}")	
	elif(Data.DEBUG_MODE == 2):
		Data.debug_msg(2,respond)
	
	
	if(data['type'] == 'create_team'):
		var team = get_node("/root/team")
		if(data['sucess']=='true'):			
			_on_generate_team_finished(data['teamid'])
			world.have_team = true
			world.send_team_request()
		else:
			_on_generate_team_finished('Unable to generate team-id!')
			print("Unaccept emergency request!!!")
	elif(data['type'] == 'join_team'):
		if(data['sucess']=='true'):			
			$team_up/input.text = "Join sucessed!"
			world.have_team = true
			world.send_team_request()
		else:
			$team_up/input.text = "Join failed!"
			print("Unable join team!!!")
	elif(data['type'] == 'team_member'):
		if(data['sucess']=='true'):			
			for i in range(10):	
				if data['mem'+str(i+1)+'name'] != '-1':				
					Data.team_member_list[i]['姓名'] = data['mem'+str(i+1)+'name']
					Data.team_member_list[i]['學號'] = data['mem'+str(i+1)+'number']
					Data.team_member_list[i]['拼圖數量'] = int(data['mem'+str(i+1)+'used'])
				else:				
					Data.team_member_list[i]['姓名'] = '尚未組隊'
					Data.team_member_list[i]['學號'] = '尚未組隊'
					Data.team_member_list[i]['拼圖數量'] = 0
			Data._set_team_total_puzzle()
			_set_up(Data.team_user,Data.team_id,Data.team_tatal_puzzle,Data.team_member_list)
			world.refresh_team_scene_status()
		else:
			print("Unable fetch team element!!!")

func _is_input_team_name():
	if $team_up/input_team_name.text != "":
		return true
	else:
		return false
	


func _on_input_text_changed(new_text):
	$team_up/background/input_label.text=$team_up/input.text


func _on_input_team_name_text_changed(new_text):
	$team_up/background/input_team_name_label.text=$team_up/input_team_name.text
