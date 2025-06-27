extends CharacterBody2D

class_name Paddle

var direccion = Vector2.ZERO
var camaraBordes : Rect2
var mitadPadleAncho: float
var pelotaIniciada = false

@export var velocidad = 400
@export var camara: Camera2D

@onready var pelota = $"../Pelota" as Pelota
@onready var collisionShape = $CollisionShape2D

func _ready():
	pelota.vidaPerdida.connect(pelotaPerdida)
	camaraBordes = camara.get_viewport_rect()
	mitadPadleAncho = collisionShape.shape.get_rect().size.x / 2 * scale.x

func _physics_process(delta):
	velocity = velocidad * direccion
	move_and_slide()

func _process(delta):
	var camaraIniciox = camara.position.x - camaraBordes.size.x / 2
	var finalCamarax = camaraIniciox + camaraBordes.size.x
	
	if global_position.x - mitadPadleAncho < camaraIniciox:
		global_position.x = camaraIniciox + mitadPadleAncho
	elif global_position.x + mitadPadleAncho > finalCamarax:
		global_position.x = finalCamarax - mitadPadleAncho

func _input(event):
	if Input.is_action_pressed("Derecha"):
		direccion = Vector2.RIGHT
	elif Input.is_action_pressed("Izquierda"):
		direccion = Vector2.LEFT
	else: 
		direccion = Vector2.ZERO 
		
	if direccion != Vector2.ZERO && !pelotaIniciada:
		pelota.start_pelota()
		pelotaIniciada = true
	
func pelotaPerdida():
	pelotaIniciada = false
	direccion = Vector2.ZERO
	
func getAncho():
	return collisionShape.shape.get_rect().size.x
