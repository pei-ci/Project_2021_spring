extends Node2D
#遊戲進行的main
#1、2(?)讀取、寫入
#1、2這裡需要從資料庫load資料進來這裡


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#quit
func _on_Button_pressed():
	get_tree().quit()
