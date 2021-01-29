extends Sprite
#資訊欄
var subject_user =" "
var number_user =""
var name_user =""
var nickname_user =""
var total_puzzle_user =""
var title_user =""
var team_user =""

#未拼拼圖片數
#還不確定放哪 位置和背景還會再修改
var puddle =1 
var wilderness =2
var desert =3
var sea =4
var town =5
var volcano =6

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()

func _set_up():
	$subject.text += subject_user
	$number.text += number_user
	$name.text += name_user
	$nickname.text += nickname_user
	$total_puzzle.text += total_puzzle_user
	$title.text += title_user
	$team.text += team_user
	
	$unfinished_puzzle.text = "水坑:"+str(puddle)+"\n荒原:"+str(wilderness)+"\n沙漠:"+str(desert)+"\n淺海:"+str(sea)+"\n郊區:"+str(town)+"\n地熱口"+str(volcano)
	
