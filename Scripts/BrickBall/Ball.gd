extends CharacterBody2D

var moversePermitido = true
var colisionoAntes = false
func _ready() -> void:
	collision_layer = 1 << 1
	collision_mask = ~(1 << 1)

func _physics_process(_delta):
	if moversePermitido:
		var previous_velocity = velocity
		var col = move_and_slide()

		if col:
			var processed_colliders = {}
			for i in range(get_slide_collision_count()):
				var collision = get_slide_collision(i)
				var normal = collision.get_normal()
				var collider = collision.get_collider()
				if collider is Brick:
					if not processed_colliders.has(collider):
						collider.bajarNivel()
						processed_colliders.get_or_add(collider)
				velocity = previous_velocity.bounce(normal).normalized() * previous_velocity.length()
				
			
func moverse():
	moversePermitido = !moversePermitido
