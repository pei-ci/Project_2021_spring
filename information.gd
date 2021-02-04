extends Sprite
#資訊欄
var subject_user =""
var number_user =""
var name_user =""
var nickname_user =""
var total_puzzle_user =""
var title_user =""
var team_user =""

#未拼拼圖片數
#還不確定放哪 位置和背景還會再修改
var puddle
var wilderness
var desert
var sea
var town
var volcano

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()

func _set_up():
	$subject.text ="學系:"+subject_user
	$number.text = "學號:"+number_user
	$name.text = "姓名:"+name_user
	$nickname.text = "暱稱:"+nickname_user
	$total_puzzle.text = "拼圖:"+total_puzzle_user
	$title.text = "稱號:"+title_user
	$team.text = "隊名:"+team_user
	
	$unfinished_puzzle.text = "水坑:"+str(puddle)+"\n荒原:"+str(wilderness)+"\n沙漠:"+str(desert)+"\n淺海:"+str(sea)+"\n郊區:"+str(town)+"\n地熱口:"+str(volcano)
	
