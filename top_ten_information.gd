extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var leader_board_status=true #true:個人，false:團體

func _ready():
	$background.visible=false
	$information_text.visible=false


func _on_TextureButton_mouse_entered():
	$background.visible=true
	_set_information()
	$information_text.visible=true


func _on_TextureButton_mouse_exited():
	$background.visible=false
	$information_text.visible=false
	

var block_name_to_num={"first_block":1,"second_block":2,"third_block":3,"four_block":4,"five_block":5,
						"six_block":6,"seven_block":7,"eight_block":8,"night_block":9,"ten_block":10}

func _set_information():
	var num=block_name_to_num[get_name()]
	var text=_get_information_text(num)
	$information_text.text=text

#獲取即時資料
func _get_information_text(num):
	var text=""
	if leader_board_status:
		text="暱稱:"+Data.top_ten_person[num-1]["nickname"]+"\n拼圖總數:"+Data.top_ten_person[num-1]["total_puzzle"]+"\n稱號:"+Data.top_ten_person[num-1]["title"]
	else:
		text="隊名:"+Data.top_ten_team[num-1]["teamname"]+"\n拼圖總數:"+Data.top_ten_team[num-1]["total_puzzle"]
	return text
