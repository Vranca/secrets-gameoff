extends Area2D
signal hit

@export var sinking_speed = 1
@export var swimming_speed = 10
var screen_size
var button_pressed_delta = 0 
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed tSime since the previous frame.
func _process(delta: float) -> void:
	var old_velocity = velocity
	velocity.y += sinking_speed * delta
	self.rotation = 0
	if(Input.is_action_pressed("move_up")):
		button_pressed_delta += delta
		if (button_pressed_delta < 0.1):
			velocity.y -= swimming_speed * delta
	else:
		button_pressed_delta = 0
	
	velocity.y = clampf(velocity.y, -1, 1)
	if(velocity.y < old_velocity.y or velocity.y < 0):
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(_body: Node2D) -> void:
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	$CollisionShape2D.disabled = false
