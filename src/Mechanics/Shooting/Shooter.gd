class_name Shooter
extends Position2D
# Represents a shooter that spawns and shoots stuff


onready var base_damage = 1 # Base damage of weapon
onready var hitstun = 1 # Hitstun applied to enemies when hit
onready var cooldown = 10 # Cooldown between shots -> if (lastShotTime - currTime) >= cooldown: then shoot
onready var reload_time = 1 # Total time to reload (for reload animation)
onready var bullet_life = 10 # Life of the shot before it expires
 
onready var max_ammo = 10 # Max ammo
onready var current_ammo = max_ammo # Current ammo that the shooter has

onready var anim_shoot = null

onready var sound_shoot = null
onready var sound_reload = null


# Called when the player shoots the shooter
# Returns if cannot shoot
func on_shoot(ray):
    return true
    

# Returns the applied relevant falloff calculations to damage
func apply_falloff(damage = base_damage):
    pass


# Returns damage upon impact
func get_damage():
    pass


# Any extra calculations to be made when fired -> might not need this
func extra_calcs():
    pass


# Called after the gun is fired -> for recoil modifications?
func after_shoot():
    pass
    

# Called when player starts the reload animation
func start_reload():
    pass
    

# Called when the reload animation finishes -> update current_ammo
func end_reload():
    pass


func _on_Cooldown_timeout():
    pass # Replace with function body.
