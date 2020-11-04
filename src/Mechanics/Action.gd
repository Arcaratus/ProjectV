class_name Action
extends Node


const ATTACK = "attack"
const ATTACK_SIDE = "attack_side" # Use the facing direction to determine L or R
const ATTACK_DOWN = "attack_down"
const ATTACK_UP = "attack_up"
const AERIAL_ATTACK = "aerial_attack"
const AERIAL_ATTACK_SIDE = "aerial_attack_side" # Use the facing direction to determine L or R
const AERIAL_ATTACK_DOWN = "aerial_attack_down"
const AERIAL_ATTACK_UP = "aerial_attack_up"

const SPECIAL = "special"
const SPECIAL_SIDE = "special_side"
const SPECIAL_DOWN = "special_down"
const SPECIAL_UP = "special_up"

const ACTIONS = [ATTACK, ATTACK_SIDE, ATTACK_DOWN, ATTACK_UP, SPECIAL]

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
static func get_input_combo(inputs):
    if inputs.has(Inputs.JUMP):
        if inputs.has(Inputs.MOUSE_CLICK_LEFT):
            if inputs.has(Inputs.LEFT) or inputs.has(Inputs.RIGHT):
                return AERIAL_ATTACK_SIDE
            elif inputs.has(Inputs.DOWN):
                return AERIAL_ATTACK_DOWN
            elif inputs.has(Inputs.UP):
                return AERIAL_ATTACK_UP
            return AERIAL_ATTACK
    if inputs.has(Inputs.MOUSE_CLICK_LEFT):
        if inputs.has(Inputs.LEFT) or inputs.has(Inputs.RIGHT):
            return ATTACK_SIDE
        elif inputs.has(Inputs.DOWN):
            return ATTACK_DOWN
        elif inputs.has(Inputs.UP):
            return ATTACK_UP
        return ATTACK
    if inputs.has(Inputs.MOUSE_CLICK_RIGHT):
        if inputs.has(Inputs.LEFT) or inputs.has(Inputs.RIGHT):
            return SPECIAL_SIDE
        elif inputs.has(Inputs.DOWN):
            return SPECIAL_DOWN
        elif inputs.has(Inputs.UP):
            return SPECIAL_UP
        return SPECIAL
    return null
                


func get_instance():
    pass
