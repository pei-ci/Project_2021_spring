extends Sprite

onready var world = get_node("/root/world")


func _ready():
	$leader_board.visible=false
	pass


func _on_leader_button_pressed():
	world.send_rank_request('person')
	world.send_rank_request('team')
	$leader_board.visible=true
