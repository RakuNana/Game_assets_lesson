extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var mouse_sensitivity = .002

@onready var cam_pivot = get_node("cam_pivot")

func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		#places mouse cursor to center of screen, then locks it to center
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	
	
	
func _input(event):
	
	if event is InputEventMouseMotion:
		
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		#keeps camera from being able to 360, sprite should be parented to camera
		cam_pivot.rotation.x = clamp(cam_pivot.rotation.x,-PI/2, PI/2)
