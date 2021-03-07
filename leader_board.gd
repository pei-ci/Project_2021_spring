extends Sprite

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
	if $person_text.visible==true:
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
		$block/first_block.leader_board_status=true
		$block/second_block.leader_board_status=true
		$block/third_block.leader_board_status=true
		$block/four_block.leader_board_status=true
		$block/five_block.leader_board_status=true
		$block/six_block.leader_board_status=true
		$block/seven_block.leader_board_status=true
		$block/eight_block.leader_board_status=true
		$block/night_block.leader_board_status=true
		$block/ten_block.leader_board_status=true
	if status=="team":
		$block/first_block.leader_board_status=false
		$block/second_block.leader_board_status=false
		$block/third_block.leader_board_status=false
		$block/four_block.leader_board_status=false
		$block/five_block.leader_board_status=false
		$block/six_block.leader_board_status=false
		$block/seven_block.leader_board_status=false
		$block/eight_block.leader_board_status=false
		$block/night_block.leader_board_status=false
		$block/ten_block.leader_board_status=false
