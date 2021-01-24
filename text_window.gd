extends Sprite
#視窗和文字訊息
#底下的lebel物件 目前使用字體 NotoSerifCJKtc-Black 可再更改
func _ready():
	$background.visible = false
	$close.visible = false
	$text.text="你好"  #此text為測試用
	pass # Replace with function body.


signal timer_continue #當視窗關閉會發出訊號 #此訊號會用在 emergency突發事件那邊
func _on_close_pressed(): 
	$background.visible = false
	$close.visible = false
	$text.visible = false
	$text_emergency.visible = false
	emit_signal("timer_continue")
	
