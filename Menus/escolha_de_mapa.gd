extends Control

var selected_index: int = -1  # Variável para armazenar o índice selecionado

# Mapeia os índices para os arquivos de cena correspondentes
var map_files = [
	"res://mapas/flat/flat.tscn",
	"res://mapas/biplat/bi_plat.tscn",
	"res://mapas/triplat/tri_plat.tscn"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	selected_index = index  # Armazena o índice do item clicado
	print("Item selecionado: ", selected_index)  # Exibe o item selecionado no console (opcional)


func _on_map_selector_button_pressed() -> void:
	if selected_index >= 0 and selected_index < map_files.size():
		get_tree().change_scene_to_file(map_files[selected_index])
	else:
		print("Nenhum item foi selecionado ou o índice está fora do alcance.")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/tela_de_inicio.tscn")
