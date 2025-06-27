extends Node2D

var score = 0
@export var ball_scene: PackedScene
@export var num_pelotas: int = 5
var pelotasRestantes = 0
var direction: Vector2 = Vector2.RIGHT
var balls_disparadas: bool = false
var pelota_base: CharacterBody2D
@onready var blockGrid = $"../BlockGrid"

func _process(delta):
	if balls_disparadas:
		return
	$"../Pelotas".text = "Pelotas: " + str(num_pelotas)
	$"../Score".text = "Score: " + str(score)
	direction = (get_global_mouse_position() - global_position).normalized()
	queue_redraw()

func _input(event):
	if (event.is_action_pressed("ui_select") or event.is_action_pressed("click")) and not balls_disparadas:
		disparar_pelotas()
		balls_disparadas = true

func disparar_pelotas():
	var delay = 0.1
	for i in range(num_pelotas):
		await get_tree().create_timer(delay).timeout
		disparar_una_pelota()
	pelotasRestantes = num_pelotas


func crear_pelota_base():
	var base = ball_scene.instantiate()
	base.moverse()
	base.global_position = global_position
	base.name = "pelota_base"
	base.add_to_group("pelota")
	get_parent().add_child(base)



func disparar_una_pelota():
	var angle = direction.angle()
	var dir = Vector2.RIGHT.rotated(angle)

	var pelota = ball_scene.instantiate()
	pelota.global_position = global_position
	pelota.velocity = dir * 400
	pelota.add_to_group("pelota")
	get_parent().add_child(pelota)


func _draw():
	draw_line(Vector2.ZERO, direction * 100, Color.WHITE, 2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Brick:
		get_parent().perder()
	if not body.is_in_group("pelota") or body.name == "pelota_base":
		return
	body.queue_free()
	await get_tree().process_frame
	pelotasRestantes -= 1;
	if pelotasRestantes == 0:
		balls_disparadas = false
		crear_pelota_base()
		blockGrid.on_round_terminada()
	
	$"../Area2D".set_deferred("monitoring", false)
	await get_tree().process_frame
	$"../Area2D".set_deferred("monitoring", true)


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_parent().perder()
