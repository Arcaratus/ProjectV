extends Node
# Helper script that handles all the inputs for the game

var mouse_pos
var mouse_click = false

var input_buffer = [] # Raw inputs
var pressed = [] # Buttons that remain pressed
var elapsed_input_time = 0
var action_buffer = [] # Translated inputs
var elapsed_move_time = 0

const BUFFER_WINDOW = 0.15 # in seconds


func add_input(event):
    if not event.is_echo():
        for input in Inputs.INPUTS:
            if event.is_action_pressed(input):
                input_buffer.append(input)
                pressed.append(input)
            elif event.is_action_released(input):
                pressed.erase(input)
    
    if event is InputEventMouseButton:
        InputHandler.mouse_pos = event.position


func set_mouse_pos(pos):
    mouse_pos = pos


func get_mouse_pos():
    return mouse_pos


func get_current_action():
    return action_buffer.front()


func process_inputs():
    var action = Action.get_input_combo(input_buffer + pressed)
    if not action == null:
        action_buffer.append(action)
        print(action_buffer)
    input_buffer.clear()


func process_buffer(delta):
    process_input_buffer(delta)
    process_buffered_action(delta)


func process_input_buffer(delta):
    if len(input_buffer) > 0:
        elapsed_input_time += delta
        
        if elapsed_input_time > BUFFER_WINDOW:
            process_inputs()
    else:
        elapsed_input_time = 0


func process_buffered_action(delta):
    if len(action_buffer) > 0:
        elapsed_move_time += delta
        var current = get_current_action()
        
        if elapsed_move_time > BUFFER_WINDOW:
            elapsed_move_time -= BUFFER_WINDOW
            action_buffer.pop_front()
    else:
        elapsed_move_time = 0
