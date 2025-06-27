extends Control


func _on_brick_breacker_pressed() -> void:
	Nivelesdef.nivelActual = 1
	get_tree().change_scene_to_file("res://Escenas/BrickBreaker/BrickBreaker.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_brick_ball_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/BrickBall/BrickBall.tscn")
