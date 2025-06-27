extends CanvasLayer

class_name UI
@onready var vidasLabel = %VidasLabel
@onready var JuegoPerdidoConteiner = $juegoPerdidoConteiner
@onready var JuegoGanadorConteiner = $JuegoGanadorConteiner
@onready var botonNextNivel = $JuegoGanadorConteiner/Panel/VBoxContainer/botonNextNivel

func setVidas(vidas: int):
	if vidasLabel:
		vidasLabel.text = "Vidas: %d" % vidas
	else:
		print("Error: vidasLabel no está inicializado")

func perder():
	JuegoPerdidoConteiner.show()

func _on_boton_perdiste_pressed() -> void:
	get_tree().reload_current_scene()

func ganar():
	if Nivelesdef.nivelActual >= Nivelesdef.niveles.size():
		botonNextNivel.text = "Reiniciar"
		$JuegoGanadorConteiner/Panel/VBoxContainer/NivelAleatorio.visible = true
		if Nivelesdef.nivelActual > 4:
			$JuegoGanadorConteiner/Panel/VBoxContainer/NivelAleatorio.text = "Siguiente nivel autogenerado"
	else:
		botonNextNivel.text = "Siguiente Nivel"
		$JuegoGanadorConteiner/Panel/VBoxContainer/NivelAleatorio.visible = false
		
	JuegoGanadorConteiner.show()

func _on_boton_next_nivel_pressed() -> void:
	if Nivelesdef.nivelActual >= Nivelesdef.niveles.size():
		Nivelesdef.nivelActual = 1
	else:
		Nivelesdef.nivelActual += 1

	get_tree().reload_current_scene()

func _on_boton_next_nivel_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")

func _on_nivel_aleatorio_pressed() -> void:
	Nivelesdef.nivelActual += 1
	get_tree().reload_current_scene()
