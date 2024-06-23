extends CharacterBody3D

var player_health = 100
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.05

@onready var ui_script = $UI
@onready var ray3d = $Camera3D/RayCast3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	add_to_group("player")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_pressed("leftlook"):
		self.rotate_y(TURN_SPEED)
	if Input.is_action_pressed("rightlook"):
		self.rotate_y(-TURN_SPEED)
	
	if Input.is_action_pressed("ui_accept"):
		if ui_script.can_shoot:
			shoot()
	
	move_and_slide()

func shoot():
	if ray3d.is_colliding() and ray3d.get_collider().has_method("die"):
		ray3d.get_collider().die()
