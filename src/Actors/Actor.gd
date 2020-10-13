class_name Actor
extends KinematicBody2D


export var speed = Vector2(300.0, 300.0)
onready var gravity = 600

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
    _velocity.y += gravity * delta
