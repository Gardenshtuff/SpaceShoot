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

var CL
var StatsPage

#puppet var puppet_position = Vector2()
#puppet var puppet_vel = Vector2()

func init(_nickname, start_position):
	#$GUI/Nickname.text = nickname
	global_position = start_position

func _ready():
	CL = get_node('CL')
	StatsPage = CL.get_node('StatsPage')
	ray = $RayCast2D
	ray.collide_with_bodies = true
	bulTimer = $BulletTimer
	UpdateHUD()
	#FadeIn()

func _input(event):
	if(canmove):
		if !bt and event.is_action_pressed("leftMouseDown") : 
			bulTimer.start()
			fireWep()
			bt = true
		if event.is_action_released("leftMouseDown"):
			bulTimer.stop()
			bt = false
		if event.is_action_pressed('spacebar'):
			Network.debugPos()
#			print('---')
#			print(name)
#			print("%0.0f, %0.0f" % [transform.origin.x, transform.origin.y])
			#moveSPEED = 1000
			#dodge mechanic
			#candodge = false
			#$DodgeTimer.start()
			
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
		# gun audio
		$gunaudio.play()

# dodge recharge timer
func _on_DodgeTimer_timeout():
	candodge = true

var vel = Vector2(0,0)

remote func _set_position(pos):
	global_transform.origin = pos

func _physics_process(_delta):
	update()
	$MF.visible = false
	$RH.visible = false
	vel = Vector2()
	if Input.is_action_pressed('move_left'):
		vel.x = -moveSPEED
	if Input.is_action_pressed('move_right'):
		vel.x = moveSPEED
	if Input.is_action_pressed('move_up'):
		vel.y = -moveSPEED
	if Input.is_action_pressed('move_down'):
		vel.y = moveSPEED
	if vel != Vector2():
		if is_network_master():
			var _u = move_and_slide(vel, Vector2.UP)
		rpc_unreliable("_set_position", global_transform.origin)
		
	if get_tree().is_network_server():
		Network.update_position(int(name), position)

var killflag = false
func onHit(dmgOH):
	if HP > 0:
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
	add_child(load('res://Effects/DeathScreen.tscn').instance())
	FadeToBlack()
	yield(get_tree().create_timer(3), 'timeout')
	print('DEADED')

func FadeIn():
	CL.get_node('Panel').FadeIn()
func FadeToBlack():
	CL.get_node('Panel').FadeToBlack()
	
func UpdateHUD():
	var HPbar = $PlayerCanvas/PlayerHUD/HPbar
	HPbar.get_node('maxhp_label').text = '/' + String(maxHP)
	HPbar.get_node('TP').value = HP
	HPbar.get_node('chp_label').text = String(HP)
