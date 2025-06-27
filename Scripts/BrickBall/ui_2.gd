extends CanvasLayer

func mostrarUI():
	$juegoPerdidoConteiner.visible = true

func _on_boton_perdiste_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_boton_perdiste_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")
