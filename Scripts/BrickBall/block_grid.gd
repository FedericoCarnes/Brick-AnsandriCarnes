extends Node2D

@export var ladrillo_scene: PackedScene = preload("res://Escenas/BrickBall/brick.tscn")
@onready var container: Node = $"../ContenedorLadrillos"
@onready var ballSpawner = $"../BallSpawner"
var exploto = false
var filasTotales = 0
enum Especialidad {
	AGREGAR_PELOTA,
	ELIMINAR_COLUMNA,
	ELIMINAR_FILA,
	BORRAR_TODOS_LADRILLOS,
	AGREGAR_FILA,
	ELIMINAR_PELOTAS,
	NINGUNA
}
const DESCRIPCIONES_ESPECIALIDADES = {
	Especialidad.AGREGAR_PELOTA: "+⚽",
	Especialidad.ELIMINAR_COLUMNA: "-|",
	Especialidad.ELIMINAR_FILA: "-_",
	Especialidad.BORRAR_TODOS_LADRILLOS: "💥",
	Especialidad.AGREGAR_FILA: "+_",
	Especialidad.ELIMINAR_PELOTAS: "-⚽",
	Especialidad.NINGUNA: null
}
const PROBABILIDADES_ESPECIALIDADES = {
	Especialidad.AGREGAR_PELOTA: 20,
	Especialidad.ELIMINAR_COLUMNA: 5,
	Especialidad.ELIMINAR_FILA: 5,
	Especialidad.BORRAR_TODOS_LADRILLOS: 1,
	Especialidad.AGREGAR_FILA: 10,
	Especialidad.ELIMINAR_PELOTAS: 15,
	Especialidad.NINGUNA: 44
}

func obtener_especialidad_aleatoria() -> int:
	var total_peso = 0
	for peso in PROBABILIDADES_ESPECIALIDADES.values():
		total_peso += peso
	if total_peso == 0:
		return -1
	var valor_aleatorio = randi_range(1, total_peso)
	var peso_acumulado = 0
	for especialidad_id in PROBABILIDADES_ESPECIALIDADES.keys():
		peso_acumulado += PROBABILIDADES_ESPECIALIDADES[especialidad_id]
		if valor_aleatorio <= peso_acumulado:
			return especialidad_id
	return -1

func obtener_descripcion_especialidad(especialidad_id: int):
	return DESCRIPCIONES_ESPECIALIDADES.get(especialidad_id, null)

func activar_especialidad(especialidad_elegida: int, ladrillo: Brick):
	match especialidad_elegida:
		Especialidad.AGREGAR_PELOTA:
			ballSpawner.num_pelotas += randi_range(1, 10)
		Especialidad.ELIMINAR_COLUMNA:
			for i in range(container.get_child_count() - 1, -1, -1):
				var x = container.get_child(i)
				if x is Brick and ladrillo.position.x == x.position.x:
					x.fade_out()
		Especialidad.ELIMINAR_FILA:
			for i in range(container.get_child_count() - 1, -1, -1):
				var equis = container.get_child(i)
				if equis is Brick and ladrillo.position.y == equis.position.y:
					equis.fade_out()
		Especialidad.BORRAR_TODOS_LADRILLOS:
			for i in range(container.get_child_count() - 1, -1, -1):
				var x = container.get_child(i)
				if x is Brick:
					x.fade_out()
			exploto = true
		Especialidad.AGREGAR_FILA:
			on_round_terminada()
		Especialidad.ELIMINAR_PELOTAS:
			var max_eliminar = ballSpawner.num_pelotas - randi_range(1, 3)
			if max_eliminar <= 0:
				return
			ballSpawner.num_pelotas = randi_range(1, max_eliminar)

func _ready():
	agregar_nueva_fila()

func agregar_nueva_fila():
	filasTotales += 1
	var nueva_fila = [-2, -1, 0, 1]
	var ladrillos = 0
	for x in nueva_fila:
		if randi_range(0, 1) == 0:
			ladrillos += 1
			var ladrillo = ladrillo_scene.instantiate()
			container.add_child(ladrillo)
			var pos = Vector2(x * 64, -280)
			ladrillo.position = pos
			ladrillo.scale *= Vector2(0.5 / 0.4, 0.5 / 0.356)
			ladrillo.fila = 0
			ladrillo.especialidadID = obtener_especialidad_aleatoria()
			ladrillo.especialidad = obtener_descripcion_especialidad(ladrillo.especialidadID)
			var nivel_dificultad = calcular_valor_por_filas(filasTotales)
			ladrillo.setValor(nivel_dificultad)
	if ladrillos == 0:
		agregar_nueva_fila()

func calcular_valor_por_filas(filasTotales_param: int) -> int:
	if filasTotales_param < 1:
		filasTotales_param = 1
	var max_filas_esperadas: float = 100
	var max_valor_deseado: float = 500.0
	var offset_inicial: float = 1.0
	var log_num: float = log(float(filasTotales_param) + offset_inicial)
	var log_den: float = log(max_filas_esperadas + offset_inicial)
	var valor_calculado: float = (log_num / log_den) * max_valor_deseado/ 10
	return int(clamp(valor_calculado, 0.0, max_valor_deseado))
	
func bajar_filas():
	for ladrillo in container.get_children():
		if ladrillo is Brick:
			ladrillo.fila += 1
			ladrillo.bajar_fila_logica()

func on_round_terminada():
	if !exploto:
		bajar_filas()
	else: 
		exploto = false
	agregar_nueva_fila()
