extends CharacterBody2D

class_name Pelota
const limiteVelocidad = 40

signal vidaPerdida


@export var velocidadPelota = 350
@export var vidas = 3
@export var areaFinal: AreaFinal
@export var ui: UI

var incrementoVelocidad = 1

@onready var collisionShape = $CollisionShape2D

var posicionInicial: Vector2
var ultimoCollider

func _ready():
	ui.setVidas(vidas)
	posicionInicial = position
	areaFinal.vidaPerdida.connect(onVidaPerdida)
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * velocidadPelota * delta)
	if(!collision):
		return
		
	var collider = collision.get_collider()
	if collider is Ladrillo:
		collider.bajarNivel()
		
	if(collider is Ladrillo or collider is Paddle):
		collisionPelota(collider)
	else:
		velocity = velocity.bounce(collision.get_normal())
		
func collisionPelota(collider):
	var anchoPelota = collisionShape.shape.get_rect().size.x
	var centroPelotax = position.x
	var anchoCollider = collider.getAncho()
	var centroColliderx = collider.position.x
	
	var velocidadxy = velocity.length()
	
	var collisionx = (centroPelotax - centroColliderx) / (anchoCollider / 2)
	
	var nuevaVelocidad = Vector2.ZERO
	nuevaVelocidad.x = velocidadxy * collisionx * 0.5
	
	if collider.get_rid() == ultimoCollider and collider is Ladrillo:
		nuevaVelocidad.x = nuevaVelocidad.rotated(randf_range(-45, 45)).x * 10
	else:
		ultimoCollider = collider.get_rid()
	
	nuevaVelocidad.y = sqrt(absf(velocidadxy * velocidadxy - nuevaVelocidad.x * nuevaVelocidad.x)) * (-1 if velocity.y > 0 else 1)
	
	var velocidadMultiplier = incrementoVelocidad if collider is Paddle else 1
	
	velocity = (nuevaVelocidad * velocidadMultiplier).limit_length(limiteVelocidad)

	
	
func onVidaPerdida():
	vidas -= 1
	if vidas == 0:
		ui.perder()
	else:
		vidaPerdida.emit()
		ResetPelota()
		ui.setVidas(vidas)
		
func ResetPelota():
	position = posicionInicial
	velocity = Vector2.ZERO
	
func start_pelota():
	position = posicionInicial
	randomize()
	
	velocity = Vector2(randf_range(-1,1), randf_range(-.1, -1)).normalized()
	

	
