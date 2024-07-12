extends CharacterBody2D

var speed := 500.0
var direction := Vector2.ZERO
var is_mouse_pressed := false

func _physics_process(_delta):
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT

	if direction != Vector2.ZERO:
		velocity = speed * direction.normalized()
		move_and_slide()

	if not is_mouse_pressed:
		direction = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		is_mouse_pressed = event.is_pressed()
		var inverse = get_canvas_transform().affine_inverse()
		var event_global_position = inverse.translated(event.position).origin
		direction = event_global_position - global_position
