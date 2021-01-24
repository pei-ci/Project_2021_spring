extends Sprite
#目前使用字體 NotoSerifCJKtc-Black 可再更改
func _ready():
	$background.visible = false
	$close.visible = false
	$text.text="你好"  #此text為測試用
	pass # Replace with function body.


signal timer_continue
func _on_close_pressed():
	$background.visible = false
	$close.visible = false
	$text.visible = false
	$text_emergency.visible = false
	emit_signal("timer_continue")
	
