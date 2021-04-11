extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PopupMenu.visible=false
	$PopupMenu/pressing_panel.visible=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	var title_num=self.get_name()
	if Data.title_status[title_num]>0:#已獲得稱號的情況下才可點開
		if $PopupMenu.visible==false and Data.set_title_button_opened==false:
			Data.set_title_button_opened=true
			$PopupMenu.visible=true
			yield(get_tree().create_timer(5), "timeout")#選單視窗開啟5秒後關閉
			Data.set_title_button_opened=false
			$PopupMenu.visible=false
		else:
			$PopupMenu.visible=false

func _on_set_title_button_pressed():
	var title_num=self.get_name()
	Data._set_title_information(title_num)
	Data.emit_refresh()


func _on_set_title_button_button_down():
	$PopupMenu/pressing_panel.visible=true
	


func _on_set_title_button_button_up():
	$PopupMenu/pressing_panel.visible=false
	$PopupMenu.visible=false
