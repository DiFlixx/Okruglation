extends Node2D

const WIDTH = 100 # сколькл ячеек генерировать
const HEIGHT = 30 # высота земной коры
const CENTER_Y = 4 # середина мира по вертикали

const generate_to_end = 30 # за сколко ячеек до конца начинать новую генерацию

var current_world_end = 0 # текущий край земли
var delta_sum = 0 # сумма дельты для проверки раз в секунду


var noise


func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 15
	noise.lacunarity = 2
	noise.persistence = 0.25
	generate_world()
	
func generate_world():
	for x in range(current_world_end, current_world_end + WIDTH):
		var delta_y = int(noise.get_noise_2d(x, CENTER_Y) * 10)
		var y = CENTER_Y + delta_y
		$TileMap.set_cellv(Vector2(x, y), 0)
		for i in range(y + 1, HEIGHT):
			$TileMap.set_cellv(Vector2(x, i), 1)
	current_world_end += WIDTH

func _process(delta):
	delta_sum += delta
	if delta_sum > 1:
		if (current_world_end - $TileMap.world_to_map($player.position).x) < generate_to_end:
			generate_world()
		delta_sum = 0
