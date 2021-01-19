extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().quit()


func _on_menu1_pressed():
	$text_window.visible = true
	pass # Replace with function body.


func _on_menu2_pressed():
	$text_window2.visible = true
	pass # Replace with function body.
