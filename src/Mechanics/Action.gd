class_name Action
extends Node


var ATTACK
var ATTACK_SIDE # Use the facing direction to determine L or R
var ATTACK_DOWN
var ATTACK_UP
var AERIAL_ATTACK
var AERIAL_ATTACK_SIDE # Use the facing direction to determine L or R
var AERIAL_ATTACK_DOWN
var AERIAL_ATTACK_UP

var SPECIAL
var SPECIAL_SIDE
var SPECIAL_DOWN
var SPECIAL_UP

var ACTIONS = [ATTACK, ATTACK_SIDE, ATTACK_DOWN, ATTACK_UP, SPECIAL]

var _duration
var _startup
var _active_on
var _endlag


func _init(duration, startup, active_on, endlag):
    self._duration = duration
    self._startup = startup
    self._active_on = active_on
    self._endlag = endlag


# Returns the inputs that map to an (attack) action
func get_input_combo(inputs):
    if inputs.has(Inputs.JUMP):
        if inputs.has(Inputs.MOUSE_CLICK_LEFT):
            if inputs.has(Inputs.LEFT) or inputs.has(Inputs.RIGHT):
                return AERIAL_ATTACK_SIDE
            elif inputs.has(Inputs.DOWN):
                return AERIAL_ATTACK_DOWN
            elif inputs.has(Inputs.UP):
                return AERIAL_ATTACK_UP
            return AERIAL_ATTACK
    elif inputs.has(Inputs.MOUSE_CLICK_LEFT):
        if inputs.has(Inputs.LEFT) or inputs.has(Inputs.RIGHT):
            return ATTACK_SIDE
        elif inputs.has(Inputs.DOWN):
            return ATTACK_DOWN
        elif inputs.has(Inputs.UP):
            return ATTACK_UP
        return ATTACK
    elif inputs.has(Inputs.MOUSE_CLICK_RIGHT):
        if inputs.has(Inputs.LEFT) or inputs.has(Inputs.RIGHT):
            return SPECIAL_SIDE
        elif inputs.has(Inputs.DOWN):
            return SPECIAL_DOWN
        elif inputs.has(Inputs.UP):
            return SPECIAL_UP
        return SPECIAL
                


func get_instance():
    pass
