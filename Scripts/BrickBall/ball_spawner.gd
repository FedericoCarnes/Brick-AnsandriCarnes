extends Node2D

var score = 0
@export var ball_scene: PackedScene
@export var num_pelotas: int = 5
var pelotasRestantes = 0
var direction: Vector2 = Vector2.RIGHT
var balls_disparadas: bool = false
var pelota_base: CharacterBody2D
@onready var blockGrid = $"../BlockGrid"
var seAcelero = false

func _process(delta):
	if balls_disparadas:
		return
	$"../Pelotas".text = "Pelotas: " + str(num_pelotas)
	$"../Score".text = "Score: " + str(score)

	var raw_dir = (get_global_mouse_position() - global_position).normalized()
	var angle_rad = raw_dir.angle()
	var angle_deg = rad_to_deg(angle_rad)
	if angle_deg >= 0:
		angle_deg = -1
	elif angle_deg >= 180:
		angle_deg = -170

	direction = Vector2.RIGHT.rotated(deg_to_rad(angle_deg))
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
	seAcelero = false


func crear_pelota_base():
	var base = ball_scene.instantiate()
	base.moverse()
	base.global_position = global_position
	base.name = "pelota_base"
	base.add_to_group("as")
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
	verificar_pelotas_activas()
	
	$"../Area2D".set_deferred("monitoring", false)
	await get_tree().process_frame
	$"../Area2D".set_deferred("monitoring", true)

func verificar_pelotas_activas():
	var pelotas = get_tree().get_nodes_in_group("pelota")
	var pelotas_vivas = pelotas.filter(func(p): return is_instance_valid(p) and p.name != "pelota_base")
	print(pelotas_vivas.size())
	if pelotas_vivas.size() == 0:
		balls_disparadas = false
		crear_pelota_base()
		blockGrid.on_round_terminada()


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_parent().perder()

func _on_acelerrar_pressed() -> void:
	if !seAcelero:
		for pelota in get_tree().get_nodes_in_group("pelota"):
			if is_instance_valid(pelota) and pelota.name != "pelota_base":
				seAcelero = true
				pelota.velocity *= 2
