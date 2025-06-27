extends Node

class_name SpawnerLadrillos

const Columnas = 5
const filas = 6
@onready var pelota = $"../Pelota" as Pelota
@onready var ui = $"../UI" as UI
@export var escenaLadrillo: PackedScene
@export var margen: Vector2 = Vector2(4,6)
@export var principioSpawn: Marker2D
@onready var contenedorPelotas: Node = $"../ContenedorDePelotas"
@export var escenaPelota: PackedScene
var pelotas_extras: Array[Pelota] = []
enum Especialidad {
	ELIMINAR_COLUMNA,
	ELIMINAR_FILA,
	BORRAR_TODOS_LADRILLOS,
	NINGUNA
}
const DESCRIPCIONES_ESPECIALIDADES = {
	Especialidad.ELIMINAR_COLUMNA: "-|",
	Especialidad.ELIMINAR_FILA: "-_",
	Especialidad.BORRAR_TODOS_LADRILLOS: "💥",
	Especialidad.NINGUNA: null
}
const PROBABILIDADES_ESPECIALIDADES = {
	Especialidad.ELIMINAR_COLUMNA: 10,
	Especialidad.ELIMINAR_FILA: 10,
	Especialidad.BORRAR_TODOS_LADRILLOS: 1,
	Especialidad.NINGUNA: 79
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

func activar_especialidad(especialidad_elegida: int, ladrillo: Ladrillo):
	match especialidad_elegida:
		Especialidad.ELIMINAR_COLUMNA:
			for i in range(get_child_count() - 1, -1, -1):
				var x = get_child(i)
				if x is Ladrillo and ladrillo.position.x == x.position.x:
					x.fade_out()
		Especialidad.ELIMINAR_FILA:
			for i in range(get_child_count() - 1, -1, -1):
				var x = get_child(i)
				if x is Ladrillo and ladrillo.position.y == x.position.y:
					x.fade_out()
		Especialidad.BORRAR_TODOS_LADRILLOS:
			for i in range(get_child_count() - 1, -1, -1):
				var x = get_child(i)
				if x is Ladrillo:
					x.fade_out()

func _ready():
	spawnDesdeNivelesAnimado(Nivelesdef.getNivelActual())

func _physics_process(delta: float) -> void:
	if get_child_count() == 0:
		pelota.ResetPelota()
		ui.ganar()


func spawnDesdeNivelesAnimado(nivelData):
	var test = escenaLadrillo.instantiate() as Ladrillo
	add_child(test)
	var tamañoLadrillo = test.getTamaño()
	test.queue_free()

	var filas = nivelData.size()
	var columnas = nivelData[0].size()

	var anchoFila = tamañoLadrillo.x * columnas + margen.x * (columnas - 1)
	var spawnPosicionx = ( - anchoFila + tamañoLadrillo.x + margen.x) / 2
	var spawnPosiciony = principioSpawn.position.y

	for i in filas:
		for j in columnas:
			if nivelData[i][j] == 0:
				continue
			await get_tree().create_timer(0.015).timeout  # velocidad rápida
			var ladrillo = escenaLadrillo.instantiate() as Ladrillo
			add_child(ladrillo)
			ladrillo.setNivel(nivelData[i][j])
			ladrillo.especialidadID = obtener_especialidad_aleatoria()
			ladrillo.especialidad = obtener_descripcion_especialidad(ladrillo.especialidadID)
			var x = spawnPosicionx + j * (margen.x + ladrillo.getTamaño().x)
			var y = spawnPosiciony + i * (margen.y + ladrillo.getTamaño().y)
			ladrillo.set_position(Vector2(x,y))
