extends Area2D

class_name AreaFinal

signal vidaPerdida


func _on_body_entered(body: Node2D) -> void:
	vidaPerdida.emit()
