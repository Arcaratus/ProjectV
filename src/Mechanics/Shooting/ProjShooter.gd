class_name ProjShooter
extends Shooter


const Projectile = preload("res://src/Mechanics/Shooting/Projectile/Projectile.tscn")


func on_shoot(ray):
    if not .on_shoot(ray):
        return false
    
    var proj = Projectile.instance()
    var offset = get_viewport().size / 2
    
    # use global coordinates, not local to node
    var direction = (ray - offset).normalized()
    var pos_offset = Vector2(20 * direction.x, 25 * direction.y - 10).normalized()
    var scuffed = (-pos_offset + direction).normalized()
    var scuffed2 = Vector2(scuffed.y if direction.x > 0 else -scuffed.y, scuffed.x if direction.y < 0 else -scuffed.x)
#    print(scuffed)
#    print(scuffed2)
#    print(direction)
    proj.global_position = global_position + pos_offset * 20
    proj.linear_velocity = direction * 500 + get_parent()._velocity / 2
    
    proj.set_as_toplevel(true)
    add_child(proj)
    
    return true
