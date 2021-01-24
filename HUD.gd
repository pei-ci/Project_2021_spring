extends Node2D
#menu的介面
#2底圖和text的內容都還需再設定
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Button_pressed(): #點開視窗1
	$text_window/background.visible=true
	$text_window/close.visible=true
	$text_window/text.visible=true
	pass # Replace with function body.


func _on_Button2_pressed():#點開視窗2
	$text_window2/background.visible=true
	$text_window2/close.visible=true
	$text_window2/text.visible=true
	pass # Replace with function body.
