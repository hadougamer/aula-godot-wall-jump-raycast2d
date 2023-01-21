extends KinematicBody2D

# Constants
const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 20000
const JUMP_HEIGHT = -650

# Variables
var motion   = Vector2()
var cast_ray = 50
var action   =  'walk'

var in_wall  	= false

# When our Hero is ready
func _ready():
	$Sprite.flip_h = false
	
	# Cast starts looking to 50 right
	$RayCast.enabled = true
	$RayCast.cast_to = Vector2(cast_ray,0)
	
	
func _physics_process(delta):
	var speed = SPEED * delta
	in_wall = false
	
	motion.y += GRAVITY

	if Input.is_action_pressed("ui_left"):		
		$Sprite.flip_h = true
		action = 'walk'
		
		# Cast look to 50 left
		$RayCast.cast_to = Vector2((-1 * cast_ray),0)
						
		motion.x = -speed
	elif  Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
		action = 'walk'
		
		# Cast look to 50 right
		$RayCast.cast_to = Vector2(cast_ray,0)
			
		motion.x = speed
	else:
		action = 'idle'
		motion.x = 0

	if is_on_floor():
		if Input.is_action_pressed("ui_jump"):
			motion.y = JUMP_HEIGHT
	else:
		var collider = $RayCast.get_collider()
		if collider and collider.is_in_group("platform"):
			in_wall = true
		
		action = 'jump'
	
	if in_wall:
		motion = hero_wall(motion)
				
	$Sprite.play(action)
	motion = move_and_slide(motion, UP)


func hero_wall(motion):
	motion.y = motion.y/1.3
	action = 'wall'
	if Input.is_action_just_pressed("ui_jump"):
		motion.x = motion.x * (-2)
		motion.y = JUMP_HEIGHT
		
		if not in_wall:
			$Sprite.flip_h = not $Sprite.flip_h
		
	return motion
