extends Node


var nivelActual = 1

var nivel1 = [
	[0,0,1,0,1,0,1,0,1,0,0],
	[0,1,1,1,1,1,1,1,1,1,0],
	[1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1],
	[0,1,1,0,1,1,1,0,1,1,0],
	[0,0,1,1,1,0,1,1,1,0,0],
	[0,1,0,0,0,0,0,0,0,1,0],
	[1,0,0,0,0,0,0,0,0,0,1],
	[0,1,0,0,0,0,0,0,0,1,0]
]

var nivel2 = [
	[0,0,2,0,0,  0,0,4,0,0,  0,0,5,0,0],
	[0,2,1,2,0,  0,4,3,4,0,  0,5,1,5,0],
	[0,0,2,0,0,  0,0,4,0,0,  0,0,5,0,0],

	[0,0,0,0,0,  0,0,0,0,0,  0,0,0,0,0],

	[0,0,3,0,0,  0,0,1,0,0,  0,0,4,0,0],
	[0,3,2,3,0,  0,1,5,1,0,  0,4,3,4,0],
	[0,0,3,0,0,  0,0,1,0,0,  0,0,4,0,0],

	[0,0,0,0,0,  0,0,0,0,0,  0,0,0,0,0]
]

var nivel3 = [
	[0,0,2,3,4,5,6,5,4,3,2,0,0],
	[0,2,3,4,5,6,5,4,3,2,1,2,0],
	[2,3,4,5,6,5,4,3,2,1,2,3,2],
	[3,4,5,6,5,4,3,2,1,2,3,4,3],
	[2,3,4,5,6,5,4,3,2,3,4,3,2],
	[0,2,3,4,5,6,5,4,3,4,3,2,0],
]

var nivel4 = [
	[0,0,5,5,5,5,5,0,0],
	[0,4,2,3,3,3,2,4,0],
	[5,3,6,4,2,4,6,3,5],
	[5,2,5,3,6,3,5,2,5],
	[4,3,3,5,5,5,3,3,4],
	[4,4,6,2,2,2,6,4,4],
	[0,5,4,0,0,0,4,5,0],
	[0,0,5,5,0,5,5,0,0],
]

var niveles = [nivel1, nivel2, nivel3, nivel4]

func generarNivelAutomatico():
	var ancho = 15 + randi_range(0, 5)
	var alto = 4 + randi_range(0, 3)

	var nuevo_nivel = []
	for y in range(alto):
		var fila = []
		for x in range(ancho):
			var valor_celda = randi_range(0, 5)
			if randf() < 0.2:
				valor_celda = 0
			elif randf() < 0.1:
				valor_celda = randi_range(3, 7)
			fila.append(valor_celda)
		nuevo_nivel.append(fila)

	return nuevo_nivel

func getNivelActual():
	print(nivelActual)
	if nivelActual <= niveles.size():
		return niveles[nivelActual - 1]
	else:
		var nuevo_nivel_generado = generarNivelAutomatico()
		return nuevo_nivel_generado
