extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	$team_up.visible=false
	$information.visible=false


func _set_up(team_name,team_id,team_total_puzzle,member_data_list):
	_set_information(team_name,team_id,team_total_puzzle,member_data_list)
	_set_team_up()

func _set_information(team_name,team_id,team_total_puzzle,member_data_list):
	$information/team_information.text="隊名:"+team_name+"(組對代碼:"+str(team_id)+")\n拼圖總數:"+str(team_total_puzzle)+"\n成員名單:"
	for member in member_data_list:
		if member["姓名"]=="":
			continue
		$information/team_information.text+= "\n學號: "+member["學號"]+"    姓名: "+member["姓名"]

func _set_team_up():
	$team_up/generate.text=""
	$team_up/input.text=""



func _on_close_pressed():
	self.visible=false
	


func _on_generate_Button_pressed():
	$team_up/generate.text="00000000"


func _on_input_Button_pressed():
	#print($team_up/input.text)
	pass 
