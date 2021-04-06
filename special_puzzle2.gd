extends Sprite

onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數

var PUZZLE_NUM=2

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	_set_up()


func _set_up():
	if Data._get_special_puzzle_status(PUZZLE_NUM)=="10":
		$special_puzzle.visible=true
	else:
		$special_puzzle.visible=false

func put_on_special_puzzle():
	Data._set_special_puzzle_in_status_user(PUZZLE_NUM,"10",1)
	Data.emit_refresh()

func _on_path1_pressed():
	self.visible=true


func _on_close_pressed():
	self.visible=false
	


func _on_TextureButton_pressed():
	if Data._get_special_puzzle_status(PUZZLE_NUM)=="01":
		Data._set_special_puzzle_in_status_user(PUZZLE_NUM,"10",1)
		$special_puzzle.visible=true
		$Label.text=""
		yield(get_tree().create_timer(7), "timeout")
		Data.emit_refresh()


func _on_TextureButton_mouse_entered():
	if Data._get_special_puzzle_status(PUZZLE_NUM)=="01":
		$Label.text="點此拼上特殊拼圖"
	if Data._get_special_puzzle_status(PUZZLE_NUM)=="00":
		$Label.text="未獲得此特殊拼圖"
	if Data._get_special_puzzle_status(PUZZLE_NUM)=="10":
		$Label.text=""


func _on_TextureButton_mouse_exited():
	$Label.text=""
