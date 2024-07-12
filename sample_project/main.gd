extends Node2D

func _ready():
	var size = get_viewport_rect().size

	var top = Vector2(0, -size.y / 2)
	var bottom = Vector2(0, size.y / 2)
	var left = Vector2(-size.x / 2, 0)
	var right = Vector2(size.x / 2, 0)

	create_wall(top, Vector2(size.x, 1))
	create_wall(bottom, Vector2(size.x, 1))
	create_wall(left,Vector2(1, size.y))
	create_wall(right,Vector2(1, size.y))

func create_wall(pos: Vector2, size: Vector2):
	var wall := StaticBody2D.new()
	var col_shape = CollisionShape2D.new()
	wall.add_child(col_shape)

	var shape := RectangleShape2D.new()
	shape.size = size
	col_shape.set_shape(shape)

	wall.position = pos
	add_child(wall)
