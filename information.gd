extends Sprite
#資訊欄
<<<<<<< HEAD
var subject_user ="1"
var number_user ="1"
var name_user ="1"
var nickname_user ="1"
var total_puzzle_user ="1"
var title_user ="1"
var team_user ="1"

=======
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
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()

func _set_up():
<<<<<<< HEAD
	$subject.text =subject_user
	$number.text = number_user
	$name.text = name_user
	$nickname.text = nickname_user
	$total_puzzle.text = total_puzzle_user
	$title.text = title_user
	$team.text = team_user
	


func _on_button_pressed():
	if $unfold_picture.visible==true:
		$background.visible=true
		$unfold_picture.visible=false
		$fold_picture.visible=true
		
		$subject.visible=true
		$subject_heading.visible=true
		$number.visible=true
		$number_heading.visible=true
		$nickname.visible=true
		$nickname_heading.visible=true
		$total_puzzle.visible=true
		$total_puzzle_heading.visible=true
		$team.visible=true
		$team_heading.visible=true
		$name.visible=true
		$name_heading.visible=true
		$title.visible=true
		$title_heading.visible=true
	else:
		$background.visible=false
		$unfold_picture.visible=true
		$fold_picture.visible=false
		
		$subject.visible=false
		$subject_heading.visible=false
		$number.visible=false
		$number_heading.visible=false
		$nickname.visible=false
		$nickname_heading.visible=false
		$total_puzzle.visible=false
		$total_puzzle_heading.visible=false
		$team.visible=false
		$team_heading.visible=false
		$name.visible=false
		$name_heading.visible=false
		$title.visible=false
		$title_heading.visible=false
		
	pass # Replace with function body.
=======
	$subject.text ="學系:"+subject_user
	$number.text = "學號:"+number_user
	$name.text = "姓名:"+name_user
	$nickname.text = "暱稱:"+nickname_user
	$total_puzzle.text = "拼圖:"+total_puzzle_user
	$title.text = "稱號:"+title_user
	$team.text = "隊名:"+team_user
	
	$unfinished_puzzle.text = "水坑:"+str(puddle)+"\n荒原:"+str(wilderness)+"\n沙漠:"+str(desert)+"\n淺海:"+str(sea)+"\n郊區:"+str(town)+"\n地熱口:"+str(volcano)
	
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
