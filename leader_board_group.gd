extends Sprite

onready var world = get_node("/root/world")


func _ready():
	pass


func _on_leader_button_pressed():
	world.send_rank_request('person')
	world.send_rank_request('team')
	$leader_board/background.visible=true
	$leader_board/close.visible=true
	$leader_board/close_picture.visible=true
	$leader_board/switch.visible=true
	$leader_board/switch_picture.visible=true
	$leader_board/person_text.visible=true #預設開啟個人排行
	#$leader_board/
	$leader_board/block.visible=true
