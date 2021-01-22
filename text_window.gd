extends Sprite
#目前使用字體 NotoSerifCJKtc-Black 可再更改
func _ready():
	$background.visible = false
	$close.visible = false
	var language = ["en" , "cmn_TW"]
	TranslationServer.set_locale("cmn_TW")
	$text.text="你好"
	pass # Replace with function body.


signal timer_continue
func _on_close_pressed():
	$background.visible = false
	$close.visible = false
	$text.visible = false
	emit_signal("timer_continue")
	
