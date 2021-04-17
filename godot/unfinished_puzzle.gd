extends Sprite

var puddle
var wilderness
var desert
var sea
var town
var volcano

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_up()

func _set_up():
	$puddle.text=str(puddle)
	$wilderness.text=str(wilderness)
	$desert.text=str(desert)
	$sea.text=str(sea)
	$town.text=str(town)
	$volcano.text=str(volcano)
