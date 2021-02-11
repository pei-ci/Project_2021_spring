extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_leader_button_pressed():
	$leader_board/background.visible=true
	$leader_board/close.visible=true
	$leader_board/close_picture.visible=true
	$leader_board/switch.visible=true
	$leader_board/switch_picture.visible=true
	$leader_board/person_text.visible=true #預設開啟個人排行
	$leader_board/
	$leader_board/block.visible=true
