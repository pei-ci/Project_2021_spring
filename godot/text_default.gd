extends Label

onready var file = 'res://emergency_01.txt'
# Called when the node enters the scene tree for the first time.
func _ready():
	file = 'res://default.txt'
	text =_load_file(file)


func _load_file(file):
	var f = File.new()
	f.open(file,File.READ)
	var line=""
	var index = 1
	while not f.eof_reached():
		line = line + "\n" + f.get_line()
		index += 1
	f.close()
	return line

