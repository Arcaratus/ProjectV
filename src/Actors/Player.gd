class_name Player
extends Actor


const FLOOR_DETECT_DISTANCE = 20.0

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
#onready var shoot_timer = $ShootAnimation
onready var sprite = $Sprite
onready var shooter = $ProjShooter

var _double_jump = true # true if can double jump
var _fast_fall = false # true if fast falling
var _sliding = false # true if sliding


func _ready():
    # Static types are necessary here to avoid warnings.
    var camera: Camera2D = $Camera


# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
    var direction = get_direction()
    
    var jumped = Input.is_action_just_pressed(Inputs.JUMP)
    if jumped and not is_on_floor():
        _double_jump = false
        
    var is_jump_interrupted = Input.is_action_just_released(Inputs.JUMP) and _velocity.y < 0.0
    _velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
    if _sliding and _velocity.x == 0:
        _sliding = false
        
    var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
    var is_on_platform = platform_detector.is_colliding()
    _velocity = move_and_slide_with_snap(
        _velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
    )

    # When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
    # This will make Robi face left or right depending on the direction you move.
    if direction.x != 0:
        sprite.scale.x = 1 if direction.x > 0 else -1
    
    if is_on_floor():
        if not _double_jump:
            _double_jump = true
        if _fast_fall:
            _fast_fall = false

    # We use the sprite's scale to store Robi’s look direction which allows us to shoot
    # bullets forward.
    # There are many situations like these where you can reuse existing properties instead of
    # creating new variables.
    var is_shooting = false
    var crouching = Input.is_action_pressed(Inputs.DOWN)
    if crouching:
        if is_on_floor() and not _sliding and _velocity.x != 0:
            _sliding = true
        if not _fast_fall and not is_on_floor():
            _fast_fall = true
            _velocity.y = 100
    else:
        if is_on_floor() and _sliding and _velocity.x != 0:
            _sliding = false
        
    if Input.is_action_just_pressed(Inputs.MOUSE_CLICK_LEFT):
        is_shooting = shooter.on_shoot(get_node("/root/InputHandler").mouse_pos)

    var animation = get_new_animation(is_shooting, crouching)
    if animation != animation_player.current_animation:
        animation_player.play(animation)


func get_direction():
    var x = Input.get_action_strength(Inputs.RIGHT) - Input.get_action_strength(Inputs.LEFT)
    var y = 1 if Input.is_action_pressed(Inputs.DOWN) else -1 if (is_on_floor() or _double_jump) and Input.is_action_just_pressed(Inputs.JUMP) else 0 # For some reason y is positive going down
    return Vector2(x, y)


func calc_horizontal_velocity(velocity, direction, speed):
    if _sliding:
        return 0 if abs(velocity) < 50 else velocity * 0.97
    if direction == 0:
        return 0 if abs(velocity) < 50 else velocity * 0.88
    elif Input.get_action_strength(Inputs.DOWN) != 0:
        return 50 * sign(direction)
    return clamp(velocity + sign(direction) * 15, -speed, speed)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
        linear_velocity,
        direction,
        speed,
        is_jump_interrupted
    ):
    var velocity = linear_velocity
    velocity.x = calc_horizontal_velocity(velocity.x, direction.x, speed.x)
    if direction.y < 0:
        velocity.y = speed.y * direction.y
    if direction.y > 0:
        velocity.y = min(velocity.y * 1.05, 400)
    elif is_jump_interrupted:
        # Decrease the Y velocity by multiplying it, but don't set it to 0
        # as to not be too abrupt.
        velocity.y *= 0.6
        
    return velocity


func get_new_animation(is_shooting = false, crouching = false):
    var animation_new = ""
    if is_on_floor():
        animation_new = "run" if abs(_velocity.x) > 0.1 and not crouching else "crouch" if crouching else "idle"
    else:
        animation_new = "falling" if _velocity.y > 0 else "jumping"
    if is_shooting:
        animation_new += "_weapon"
    return animation_new
