extends KinematicBody2D

export var velocity = Vector2(0,0)
var dmg = 0
func _physics_process(_delta):
	var _u = move_and_collide(velocity)

func _on_Area2D_body_entered(body):
	if(body.name == 'Player'):
		body.onHit(dmg)
	if (!body.is_in_group('Entity')):
#		velocity = Vector2(0,0)
#		self.visible = false
#		position = Vector2(0,0)
		self.queue_free()
