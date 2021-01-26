extends KinematicBody2D

export var disabled = false
var mybul

var velocity = Vector2(0,0)

export var waitTime = 1
var movespeed = 8
var bulletspeed = 20

var meleedmg = 5
var bulletdmg = 5
var HP = 100

onready var rand = RandomNumberGenerator.new()
var deatheffect

func _ready():
	mybul = $Bullet
	if !disabled:
		deatheffect = load('res://Effects/small_splash_1.tscn')
		mybul.dmg = bulletdmg
		mybul.position = Vector2(0, 0)
	remove_child(mybul)
	$FireTimer.start()

func _physics_process(delta):
	self.rotate(2*delta)


func fire():
	var nb = mybul.duplicate()
	nb.dmg = bulletdmg
	get_parent().add_child(nb)
	nb.global_position = global_position
	nb.visible = true
	nb.velocity = ($ray.global_position - global_position).normalized() * bulletspeed

func onHit(dmgOH):
	HP -= dmgOH
	if(HP <= 0):
		var de = deatheffect.instance()
		get_parent().add_child(de)
		de.global_position = global_position
		de.scale *= 4
		de.get_node('CPUParticles2D').emitting = true
		self.queue_free()

func _on_FireTimer_timeout():
	if(debugON): update()
	fire()

export var debugON = false
func _draw():
	if(debugON):
		pass#draw_line(Vector2(0,0), player.global_position - global_position, Color(200, 0, 200), 1)

