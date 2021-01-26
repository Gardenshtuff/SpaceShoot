extends StaticBody2D

func _ready():
	pass
	
func onHit(_d):
	$CollisionShape2D.disabled = true
	self.visible = false
