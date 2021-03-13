extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var leader_board_status=true #true:個人，false:團體

func _ready():
	$background.visible=false
	$total_puzzle.visible=false
	$nickname.visible=false
	$title.visible=false


func _on_TextureButton_mouse_entered():
	$background.visible=true
	_set_information()
	$total_puzzle.visible=true
	$nickname.visible=true
	$title.visible=true


func _on_TextureButton_mouse_exited():
	$background.visible=false
	$total_puzzle.visible=false
	$nickname.visible=false
	$title.visible=false
	

var block_name_to_num={"first_block":1,"second_block":2,"third_block":3,"four_block":4,"five_block":5,
						"six_block":6,"seven_block":7,"eight_block":8,"night_block":9,"ten_block":10}

func _set_information():
	var num=block_name_to_num[get_name()]
	var text=_get_information_text(num)
	$nickname.text=text["暱稱"]
	$total_puzzle.text=text["拼圖總數"]
	$title.text=text["稱號"]

#獲取即時資料
func _get_information_text(num):
	var text={"暱稱":"","拼圖總數":"","稱號":"","隊名":""}
	if leader_board_status:
		text["暱稱:"]=Data.top_ten_person[num-1]["nickname"]
		text["拼圖總數:"]=Data.top_ten_person[num-1]["total_puzzle"]
		text["稱號"]=Data.top_ten_person[num-1]["title"]
	else:
		text["隊名:"]=Data.top_ten_team[num-1]["teamname"]
		text["拼圖總數:"]=Data.top_ten_team[num-1]["total_puzzle"]
	return text
