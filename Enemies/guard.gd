extends CharacterBody3D

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var ray3d = $RayCast3D

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false
var is_attacking = false
var attack_range = 10.0

func _ready():
	add_to_group("enemy")
	
func _physics_process(delta):
	if dead or is_attacking:
		return
		
	if player == null:
		return
		
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * SPEED
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	look_at(player.global_position)
		
	move_and_slide()
	attack()
	
func attack():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		$AnimatedSprite3D.play("default")
	else:
		is_attacking = true
		$AnimatedSprite3D.play("shoot")
		if ray3d.is_colliding() and ray3d.get_collider().has_method("damage"):
			ray3d.get_collider().damage()
		await $AnimatedSprite3D.animation_finished
		is_attacking = false
		
func die():
	dead = true
	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true
	
