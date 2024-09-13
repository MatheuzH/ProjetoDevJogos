extends Button
var lista:ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	lista = get_parent().get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if toggled:
		print(lista.is_anything_selected())
	pass
