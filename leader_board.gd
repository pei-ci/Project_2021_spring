extends Sprite

onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var leader_board_status = true

func _ready():
	$background.visible=false
	$close.visible=false
	$close_picture.visible=false
	$switch.visible=false
	$switch_picture.visible=false
	$person_text.visible=false
	$team_text.visible=false
	$block.visible=false

#關閉
func _on_close_pressed():
	$background.visible=false
	$close.visible=false
	$close_picture.visible=false
	$switch_picture.visible=false
	$person_text.visible=false
	$team_text.visible=false
	$block.visible=false
	_set_block_status("person")#頁面預設狀態是個人 因此要設定回個人true
	
#切換個人或團體
func _on_switch_pressed():
	if leader_board_status:
		$person_text.visible=false
		$team_text.visible=true
		_set_block_status("team")
	else:
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
		child_obj.text = '666666666' #wtf is this no respond?
			
	for i in range($team_text.get_child_count()-1):
		var child_obj = $team_text.get_child(i)
		child_obj.text = Data.top_ten_team[i]["teamname"]
						
	for i in range($block.get_child_count()):
		var child_obj = $block.get_child(i)
		child_obj._set_information()
		
