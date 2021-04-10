extends Sprite

onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var leader_board_status = true

func _ready():
	$team_text.visible=false
	self.visible=false

#關閉
func _on_close_pressed():
	var world = get_node("/root/world")
	world.set_click_function_button_status(true)
	self.visible=false
	_set_block_status("person")#頁面預設狀態是個人 因此要設定回個人true

#切換到團體
func _on_switch_to_team_pressed():
	$person_text.visible=false
	$team_text.visible=true
	_set_block_status("team")
	
#切換到個人
func _on_switch_to_person_pressed():
	print(101012222222)
	$team_text.visible=false
	$person_text.visible=true
	_set_block_status("person")


	
#leader_board_status紀錄目前是個人true還是團體頁面false
func _set_block_status(status):
	if status=="person":
		leader_board_status = true
		for i in range($block.get_child_count()):
			var child_obj = $block.get_child(i)
			child_obj.leader_board_status = true
			
	if status=="team":
		leader_board_status = false
		for i in range($block.get_child_count()):
			var child_obj = $block.get_child(i)
			child_obj.leader_board_status = false


func refresh_rank_data():
	for i in range($person_text.get_child_count()-1):
		var child_obj = $person_text.get_child(i)
		child_obj.text = Data.top_ten_person[i]["name"]
			
	for i in range($team_text.get_child_count()-1):
		var child_obj = $team_text.get_child(i)
		child_obj.text = Data.top_ten_team[i]["teamname"]
						
	for i in range($block.get_child_count()):
		var child_obj = $block.get_child(i)
		child_obj._set_information()
		






