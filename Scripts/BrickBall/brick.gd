extends RigidBody2D

class_name Brick

signal destruido

var nivel = 1
var valor = 0
@onready var ballSpawner = $"../../BallSpawner"
@onready var blockGrid = $"../../BlockGrid"
@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D
var fila: int = 0
var especialidad = null
var especialidadID = null
var valorInicial = 0
var sprites: Array[Texture2D] = [
	preload("res://Assets/Lvioleta.png"),
	preload("res://Assets/Lazul.png"), 
	preload("res://Assets/Lverde.png"),
	preload("res://Assets/Lamarillo.png"),
	preload("res://Assets/Lnaranja.png"),
	preload("res://Assets/Lrojo.png")
]
var valores: Array[int] = [1,11,26,51,101,151]

func obtener_indice_sprite_por_nivel(v_input: int) -> int:
	if valores.is_empty():
		return -1
	for i in range(valores.size() - 1, -1, -1):
		var nivel_minimo = valores[i]
		if v_input >= nivel_minimo:
			return i
	return 0

func setValor(v: int):
	valor = v
	valorInicial = v
	var indice_sprite_a_usar = obtener_indice_sprite_por_nivel(v)
	if indice_sprite_a_usar != -1 and indice_sprite_a_usar < sprites.size():
		setNivel(indice_sprite_a_usar + 1)

func _physics_process(delta):
	if especialidad != null:
		$Label.text = str(valor, '\n', especialidad)
	else:
		$Label.text = str(valor)

func bajar_fila_logica(filas: int = 1):
	position.y += 64
	fila += filas 

func getTamaño() -> Vector2:
	if collisionShape.shape:
		return collisionShape.shape.get_rect().size
	else:
		return Vector2(64, 32) 

func getAncho() -> float:
	return getTamaño().x

func setNivel(niv: int):
	nivel = clamp(niv, 1, sprites.size())
	sprite.texture = sprites[nivel - 1]

func bajarNivel():
	valor -= 1 
	if valores[nivel-1] > valor:
		if nivel > 1:
			setNivel(nivel - 1)
		else:
			if ballSpawner != null:
				ballSpawner.score += (valorInicial * 3) 
			if blockGrid != null:
				blockGrid.activar_especialidad(especialidadID, self)
			fade_out()  

func fade_out():
	collisionShape.disabled = true
	var gemelo = get_tree().create_tween()
	gemelo.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.5)
	gemelo.tween_callback(destruir)

func destruir():
	queue_free()
	destruido.emit()

func bajar(filas: int = 1):
	var distancia = getTamaño().y * filas
	position.y += distancia
