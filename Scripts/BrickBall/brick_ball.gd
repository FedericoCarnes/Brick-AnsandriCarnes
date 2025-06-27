extends Node2D

func perder():
	$UI.mostrarUI()
	get_tree().paused = true


func _on_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()


func _on_volver_al_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")
