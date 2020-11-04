class_name ProjShooter
extends Shooter


const Projectile = preload("res://src/Mechanics/Shooting/Projectile/Projectile.tscn")


func on_shoot(ray):
    if not .on_shoot(ray):
        return false
    
    var proj = Projectile.instance()
    var offset = get_viewport().size / 2
    
    var pos_offset = Vector2(-4, -15)
    var center = global_position + pos_offset
    # use global coordinates, not local to node
    var proj_offset = Vector2(4, -40)
    var direction = (ray - (offset + pos_offset) + proj_offset).normalized() # idk wtf im doing
    
    proj.global_position = center + 20 * direction.normalized()
    proj.linear_velocity = direction * 500 + get_parent()._velocity / 3 # relativity implementation
    
    proj.set_as_toplevel(true)
    add_child(proj)
    
    return true
