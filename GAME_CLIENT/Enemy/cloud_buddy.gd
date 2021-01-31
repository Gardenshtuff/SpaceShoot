extends KinematicBody2D

export var disabled = false
var mybul

var engagewithplayer = false

var player
var velocity = Vector2(0,0)

export var waitTime = 1
var movespeed = 8
var bulletspeed = 16

var meleedmg = 5
var bulletdmg = 5
var HP = 20

onready var rand = RandomNumberGenerator.new()
var deatheffect

func _ready():
	mybul = $Bullet
	mybul.visible = false
	if !disabled:
		deatheffect = load('res://Effects/small_splash_1.tscn')
		player = get_tree().get_root().get_node('Game1/Player')
		mybul.dmg = bulletdmg
		mybul.position = Vector2(0, 0)
		$FireTimer.wait_time = waitTime
func _physics_process(_delta):
	var _u = move_and_collide(velocity)

func fire():
	var nb = mybul.duplicate()
	nb.dmg = bulletdmg
	get_parent().add_child(nb)
	nb.global_position = global_position
	nb.visible = true
	nb.velocity = (player.global_position - global_position).normalized() * bulletspeed

func move_action():
	if player != null:
		velocity = (player.global_position - global_position).normalized() * movespeed
	else:
		velocity = Vector2(0,0)
func _on_SightLine_body_entered(body):
	if(body.name == 'Player'):
		$FireTimer.start()
		#fire()
		move_action()
		engagewithplayer = true

func _on_SightLine_body_exited(body):
	if(body.name == 'Player'):
		engagewithplayer = false
	if(debugON): update()
	
func _on_MeleeArea_body_entered(body):
	velocity = Vector2(0,0)
	if(body.name == 'Player'):
		body.onHit(meleedmg)
		
func onHit(dmgOH):
	HP -= dmgOH
	if(HP <= 0):
		var de = deatheffect.instance()
		get_parent().add_child(de)
		de.global_position = global_position
		de.scale *= 3
		de.get_node('CPUParticles2D').emitting = true
		self.queue_free()

var f = true
func _on_FireTimer_timeout():
	if(debugON): update()
	if f:
		velocity = Vector2(0,0)
		fire()
	else:
		move_action()
	f = !f
	$FireTimer.wait_time = rand.randf() + waitTime

export var debugON = false
func _draw():
	if(debugON):
		draw_line(Vector2(0,0), player.global_position - global_position, Color(200, 0, 200), 1)

