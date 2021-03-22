extends Sprite
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton/PopupMenu.add_item("設定為稱號")
	$TextureButton/PopupMenu.rect_global_position = self.position+Vector2(-30,18)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	var title_num=self.get_name()
	#if Data.title_status[title_num]>0:#已獲得稱號的情況下才可點開
	$TextureButton/PopupMenu.visible=true
	yield(get_tree().create_timer(5), "timeout")
	$TextureButton/PopupMenu.visible=false


func _on_PopupMenu_id_pressed(id):
	var title_num=$TextureButton/PopupMenu.get_name()
	Data._set_title_information(title_num)
