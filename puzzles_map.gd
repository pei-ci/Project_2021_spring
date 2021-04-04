extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _refresh_map():
	for i in range($puzzles.get_child_count()-1):
		var child_obj = $puzzles.get_child(i)
		child_obj._status_set_up()


func _on_close_pressed():
	self.visible=false
