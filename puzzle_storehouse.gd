extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
var total_puzzle_list=[0,0,0,0,0,0]
var finished_puzzle_list=[0,0,0,0,0,0]
var unfinished_puzzle_list=[0,0,0,0,0,0]
var special_puzzle_list=[0,0,0]

var special_puzzle_name=["特殊拼圖1","特殊拼圖2","特殊拼圖3"]


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	_refresh_all_list()
	_refresh_info()
	

func _refresh_info():
	_refresh_all_list()
	$total_puzzle_type.text=("累積獲得拼圖:\n"+"水坑:"+str(total_puzzle_list[0])+"\n荒原:"+str(total_puzzle_list[1])
								+"\n沙漠:"+str(total_puzzle_list[2])+"\n淺海:"+str(total_puzzle_list[3])+"\n鄉村:"
								+str(total_puzzle_list[4])+"\n地熱口:"+str(total_puzzle_list[5]))
	$unfinished_puzzle_type.text=("未拼上拼圖:\n"+"水坑:"+str(unfinished_puzzle_list[0])+"\n荒原:"+str(unfinished_puzzle_list[1])
								+"\n沙漠:"+str(unfinished_puzzle_list[2])+"\n淺海:"+str(unfinished_puzzle_list[3])+"\n鄉村:"
								+str(unfinished_puzzle_list[4])+"\n地熱口:"+str(unfinished_puzzle_list[5]))
	$special_puzzle.text="特殊拼圖:\n"
	for i in range(len(special_puzzle_list)):
		$special_puzzle.text+=special_puzzle_name[i]+":"
		if special_puzzle_list[i]==1:
			$special_puzzle.text+="已獲得\n"
		else:
			$special_puzzle.text+="尚未獲得\n"
	
	
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
		total_puzzle_list[i]=unfinished_puzzle_list[i]+finished_puzzle_list[i+1]

func _refresh_all_list():
	_refresh_finished_puzzle_list()
	_refresh_unfinished_puzzle_list()
	_refresh_total_puzzle_list()
	_refresh_special_puzzle_list()

func _refresh_special_puzzle_list():
	var status
	for i in range(len(special_puzzle_list)):
		status=Data._get_special_puzzle_status(i+1)
		if status!="00":
			special_puzzle_list[i]=1
		else:
			special_puzzle_list[i]=0
	
	


func _on_close2_pressed():
	self.visible=false
	var world = get_node("/root/world")
	world.set_buttons_visibility(true)


func _on_puzzle_storehouse_button_pressed():
	var world = get_node("/root/world")
	world.set_buttons_visibility(false)
	self.visible=true
