extends KinematicBody2D

export var GRAVITY := 1600.0
export var MAX_SPEED := 220.0
export var ACCEL := 2200.0
export var JUMP_FORCE := -420.0
export var DOUBLE_JUMP_FORCE := -380.0
export var DASH_SPEED := 520.0
export var DASH_TIME := 0.18

var vel := Vector2()
var facing := 1
var on_ground := false
var can_double_jump := false
var is_dashing := false
var dash_timer := 0.0

func _physics_process(delta):
    if is_dashing:
        dash_timer -= delta
        if dash_timer <= 0:
            is_dashing = false

    var input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

    if not is_dashing:
        vel.x = lerp(vel.x, input_dir * MAX_SPEED, ACCEL * delta / MAX_SPEED)
    else:
        vel.x = facing * DASH_SPEED

    if is_on_floor():
        on_ground = true
        can_double_jump = true
    else:
        on_ground = false

    if Input.is_action_just_pressed("jump"):
        if on_ground:
            vel.y = JUMP_FORCE
        elif can_double_jump:
            vel.y = DOUBLE_JUMP_FORCE
            can_double_jump = false

    if Input.is_action_just_pressed("dash") and not is_dashing:
        is_dashing = true
        dash_timer = DASH_TIME
        facing = sign(input_dir) if input_dir != 0 else facing

    vel.y += GRAVITY * delta
    vel = move_and_slide(vel, Vector2.UP)
