extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var leader_board_status=true #true:個人，false:團體

func _ready():
	$person.visible=false
	$team.visible=false


func _on_TextureButton_mouse_entered():
	_set_information()
	if leader_board_status:
		$person.visible=true
	else:
		$team.visible=true


func _on_TextureButton_mouse_exited():
	$person.visible=false
	$team.visible=false
	

var block_name_to_num={"first_block":1,"second_block":2,"third_block":3,"four_block":4,"five_block":5,
						"six_block":6,"seven_block":7,"eight_block":8,"night_block":9,"ten_block":10}

func _set_information():
	var num=block_name_to_num[get_name()]
	var info=_get_information_text(num)
	if leader_board_status:
		$person/nickname.text=info["nickname"]
		$person/total_puzzle.text=info["total_puzzle"]
		$person/title.text=info["title"]
	else:
		$team/nickname.text=info["teamname"]
		$team/total_puzzle.text=info["total_puzzle"]

#獲取即時資料
func _get_information_text(num):
	var info={"nickname":"","total_puzzle":"","title":"","teamname":""}
	if leader_board_status: #personal
		info["nickname"]=Data.top_ten_person[num-1]["nickname"]
		info["total_puzzle"]=Data.top_ten_person[num-1]["total_puzzle"]
		if(Data.top_ten_person[num-1]["title"]!='-1'&&Data.top_ten_person[num-1]["title"]!='尚無排名'):
			info["title"]=Data.title_list[Data.top_ten_person[num-1]["title"]]
		else:
			info["title"]='尚無稱號'
		Data.debug_msg(2,"Puzzle"+str(Data.top_ten_person[num-1]["total_puzzle"]))
	else: #team
		info["teamname"]=Data.top_ten_team[num-1]["teamname"]
		info["total_puzzle"]=Data.top_ten_team[num-1]["total_puzzle"]
	return info
