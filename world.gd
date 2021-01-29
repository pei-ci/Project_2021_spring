extends Node2D
#遊戲的main
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()
	Data.connect("refresh",self,"_refresh_information")
	
func _set_up():
	#資訊欄
	$information.subject_user = Data.subject_user
	$information.number_user = Data.number_user
	$information.name_user = Data.name_user
	$information.nickname_user =  Data.nickname_user
	$information.total_puzzle_user =  Data.total_puzzle_user
	$information.title_user =  Data.title_user
	$information.team_user =  Data.team_user
	#資訊_未拼的拼圖
	$information.puddle=Data.puddle_user
	$information.wilderness=Data.wilderness_user
	$information.desert=Data.desert_user
	$information.sea=Data.sea_user
	$information.town=Data.town_user
	$information.volcano=Data.volcano_user
	
	$information._set_up() #套入格式設定
	#設定突發事件
	$emergency.finished_puzzle=Data.finished_puzzle_user
	
func _refresh_information():
	_set_up()
	pass	
	
	
	
#quit
func _on_Button_pressed():
	get_tree().quit()
