extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var total_puzzle_list=[0,0,0,0,0,0]
var finished_puzzle_list=[0,0,0,0,0,0]
var unfinished_puzzle_list=[0,0,0,0,0,0]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	_refresh_all_list()
	

func _refresh_info():
	_refresh_all_list()
	$total_puzzle_type.text=("已獲得拼圖:\n"+"水坑:"+str(total_puzzle_list[0])+"\n荒原:"+str(total_puzzle_list[1])
								+"\n沙漠:"+str(total_puzzle_list[2])+"\n淺海:"+str(total_puzzle_list[3])+"\n鄉村:"
								+str(total_puzzle_list[4])+"\n地熱口:"+str(total_puzzle_list[5]))
	$unfinished_puzzle_type.text=("未拼上拼圖:\n"+"水坑:"+str(unfinished_puzzle_list[0])+"\n荒原:"+str(unfinished_puzzle_list[1])
								+"\n沙漠:"+str(unfinished_puzzle_list[2])+"\n淺海:"+str(unfinished_puzzle_list[3])+"\n鄉村:"
								+str(unfinished_puzzle_list[4])+"\n地熱口:"+str(unfinished_puzzle_list[5]))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _refresh_finished_puzzle_list():
	finished_puzzle_list=Data._get_number_list_of_finished_puzzle_each_type()
	

func _refresh_unfinished_puzzle_list():
	unfinished_puzzle_list[0]=Data.puddle_user
	unfinished_puzzle_list[1]=Data.wilderness_user
	unfinished_puzzle_list[2]=Data.desert_user
	unfinished_puzzle_list[3]=Data.sea_user
	unfinished_puzzle_list[4]=Data.town_user
	unfinished_puzzle_list[5]=Data.volcano_user
	
func _refresh_total_puzzle_list():
	for i in range(len(total_puzzle_list)):
		total_puzzle_list[i]=unfinished_puzzle_list[i]+finished_puzzle_list[i]

func _refresh_all_list():
	_refresh_finished_puzzle_list()
	_refresh_unfinished_puzzle_list()
	_refresh_total_puzzle_list()
