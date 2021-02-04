extends Label
#突發事件專用 文字label

var FILE_NUM = 2 #突發事件的數量
var file = 'res://default.txt'
#隨機事件的檔案
var file_default = file
var file1 = 'res://emergency_01.txt'
var file2 = 'res://emergency_02.txt'
# Called when the node enters the scene tree for the first time.

func _ready():
	text =_load_file(file)

#讀取檔案
func _load_file(file_output): 
	var f = File.new()
	f.open(file_output,File.READ)
	var line=""
	while not f.eof_reached():
		line = line + "\n" + f.get_line()
	f.close()
	return line
	
#隨機選擇突發事件並讀取對應題目
func _set_file():
	var num=_random(1,FILE_NUM)
	if num==1:
		file=file1
	elif num==2:
		file=file2
	else:
		file=file_default
	text = _load_file(file)
	return num     #告知此題是哪題 用在選項選擇的判斷上

#取亂數
var rand=RandomNumberGenerator.new()
func _random(begin,end):
	rand.randomize()
	var random_num=rand.randi_range(begin,end)
	return random_num
