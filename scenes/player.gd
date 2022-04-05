extends KinematicBody2D

var gravity = 1200
var jump_force = -720
var is_grounded

var velocity = Vector2.ZERO
var move_speed = 200

onready var jumpTimer = $jumpBufferTimer
onready var coyoteTimer = $coyoteJumpTimer

func _ready():
	pass

func _physics_process(delta):
	_get_input(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _get_input(delta):
	var move_direction = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.3)
		
	if Input.is_action_just_pressed("ui_select"):
		jumpTimer.start()
	
	if is_on_floor():
		coyoteTimer.start()
		if !jumpTimer.is_stopped():
			_jump()
	else:
		if coyoteTimer.is_stopped():
			_apply_gravity(delta)
		elif !jumpTimer.is_stopped():
			_jump()
		# cancel jump if player has not reached the full height
		if Input.is_action_just_released("ui_select") and velocity.y < jump_force/4:
			velocity.y = jump_force/4
			
func _apply_gravity(delta):
	velocity.y += gravity * delta
		
func _jump():
	velocity.y = jump_force/2
	jumpTimer.stop()
	coyoteTimer.stop()
