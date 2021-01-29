extends Control
#這裡目前有6個物件，分別是login/world/puzzle/text_window/HUD/emgency/information請從左下角的欄位中先找到tscn檔並打開，新增新物件時請更新本行
#2麻煩妳先跟1討論，並設定好3個帳號，以利接下來你要設置各種畫面時的有效性
var player_account = []

func _ready():
	pass # Replace with function body.



func _on_LineEdit_text_entered(new_text):
	player_account.append(new_text)
	#場景在輸入完id之後就會改變，這邊是1的工作，還麻煩你自行修改
	get_tree().change_scene("res://world.tscn")

