extends KinematicBody2D

export var debugON = false

var bulTimer
var ray
var bt = false

var candodge = true
# PLAYER STATS
export var maxHP = 100
export var HP = 100
var moveSPEED = 250
var canmove = true
var bulletdmg = 5

# do not attach to player like this
var CL
var StatsPage
func _ready():
	#CL = get_tree().get_root().get_node('Game1/CanvasLayer')
	#StatsPage = CL.get_node('StatsPage')
	ray = $RayCast2D
	ray.collide_with_bodies = true
	bulTimer = $BulletTimer
	UpdateHUD()
	FadeIn()

var vel = Vector2(0,0)

func _input(event):
	if(canmove):
		if (Input.get_action_strength('move_up') > 0 ):
			vel.y = -moveSPEED
		elif (Input.get_action_strength('move_down') > 0 ):
			vel.y = moveSPEED
		else: vel.y = 0
		if (Input.get_action_strength('move_left') > 0 ):
			vel.x = -moveSPEED
		elif (Input.get_action_strength('move_right') > 0 ):
			vel.x = moveSPEED
		else: vel.x = 0

		if !bt and event.is_action_pressed("leftMouseDown") : 
			bulTimer.start()
			fireWep()
			bt = true
		if event.is_action_released("leftMouseDown"):
			bulTimer.stop()
			bt = false
			
		if candodge and event.is_action_pressed('spacebar'):
			#moveSPEED = 1000
			#dodge mechanic
			candodge = false
			$DodgeTimer.start()
			
		if event.is_action_pressed('t_key'):
			StatsPage.visible = !StatsPage.visible

func _on_BulletTimer_timeout():
	fireWep()

func fireWep():
	# rotate/point around character stuff
	var point = ($Pointer.global_position - global_position).normalized()
	$MF.position = point*50
	$MF.look_at($Pointer.global_position)
	$MF.rotate(PI/2)
	$MF.visible = true
	
	if(Input.get_action_strength('leftMouseDown') > 0):
		ray.position = Vector2(0,0)
		ray.cast_to = point * 10000
		$RH.global_position = ray.get_collision_point()
		$RH.look_at(self.global_position)
		$RH.rotate(PI/2)
		$RH.visible = true
		if(ray.is_colliding()):
			if ray.get_collider().is_in_group('onHit'): 
				print('player shot %s' % ray.get_collider().name)
				ray.get_collider().onHit(bulletdmg)

# dodge recharge timer
func _on_DodgeTimer_timeout():
	candodge = true

func _physics_process(_delta):
	update()
	var _i = move_and_slide(vel, Vector2.UP)
	$MF.visible = false
	$RH.visible = false
	
var killflag = false
func onHit(dmgOH):
	HP -= dmgOH
	UpdateHUD()
	print('player hit for : %d' % dmgOH)
	if(HP <= 0 and !killflag): 
		killPlayer()

func _draw():
	if(debugON):
		#debug player gun raycast
		draw_line(ray.position, ray.cast_to, Color(255, 0, 0), 1)
	else: pass

func killPlayer():
	killflag = true
	canmove = false
	$Sprite.visible = false
	vel = Vector2(0,0)
	#$CollisionShape2D.disabled = true
	var ef = load('res://Effects/small_splash_1.tscn').instance()
	self.add_child(ef)
	ef.scale *= 5
	ef.get_node('CPUParticles2D').emitting = true
	get_tree().get_root().get_node('Game1/CanvasLayer').add_child(load('res://Effects/DeathScreen.tscn').instance())
	FadeToBlack()
	yield(get_tree().create_timer(3), 'timeout')
	print('DEADED') 
	var _u = get_tree().reload_current_scene()

# do not attach to player
func FadeIn():
	pass#CL.get_node('Panel').FadeIn()
func FadeToBlack():
	pass#CL.get_node('Panel').FadeToBlack()
	
func UpdateHUD():
	var HPbar = $PlayerCanvas/PlayerHUD/HPbar
	HPbar.get_node('maxhp_label').text = '/' + String(maxHP)
	HPbar.get_node('TP').value = HP
	HPbar.get_node('chp_label').text = String(HP)
