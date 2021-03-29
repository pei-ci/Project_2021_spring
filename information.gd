extends Sprite

onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數
#資訊欄
var subject_user ="1"
var number_user ="1"
var name_user ="1"
var nickname_user ="1"
var total_puzzle_user ="1"
var title_user ="1"
var team_user ="1"


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()

func _set_up():
	$subject.text = Data.department_list[subject_user]
	$number.text = number_user
	$name.text = name_user
	$nickname.text = nickname_user
	$total_puzzle.text = total_puzzle_user
	$title.text = title_user
	$team.text = team_user
	_set_title_line()#如果資訊欄稱號超過八個字要換行

	
	
func _set_title_line(): #如果資訊欄稱號超過八個字要換行
	if len($title.text)>8:
		var titleStr=""
		for index in range(len($title.text)):
			titleStr+=$title.text[index]
			if index==8:
				titleStr+="\n"
		$title.text=titleStr
		print($title.text)
	

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

