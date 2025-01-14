extends Area2D
signal knockback

#the hit box for our attack. We spawn it when we hit our attack button. 
#It lasts for however long we want and then frees (deletes) itself

#one thing about using areas like this though is that they will NOT collide with anything on the first frame that they are moved or spawned 
#this includes right when the game starts or the scene starts
#so they need at least one frame to update

var lifetime = .2 #the time until deleted in seconds
var timer = 0.0 # the variable that will count the time for us

var direction = 1
#alternatively we could attach a timer node to this scene instead

var count = 0

export var slowdownscale = .8
export var slowdowntme = .2
export var eggpushvelocity = 150

func _ready():
	set_process(false)
	set_physics_process(true)



func _process(delta):
	
	pass

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if(body.is_in_group("Egg")):
			get_parent().root.travel("attack recoil")
			get_parent().Hforces.push_back(Vector3(30,6,-direction))
			body.get_node("AudioStreamPlayer").play()
			body.direction = direction
			body.velocity.x += eggpushvelocity 
			body.get_node("rolltimer").start()
			pass
		if body.is_in_group("Enemies"):
			if(get_parent().dashlevel == 0):
				global.SlowDown(slowdowntme,slowdownscale)
			
			
			
			if(get_parent().dashlevel == 1 and !body.stunned):
				get_parent().attacking = false
				get_parent().controllock = true
				get_parent().stunned = true
				#get reverse collision direction
				var hurtdirection = sign(global_position.x - body.global_position.x)
				print(hurtdirection)
				get_parent().velocity.y = -150
				get_parent().velocity.x = 100 * hurtdirection
				get_parent().dashattack = null
				get_parent().dashlevel = 0
				body.Damage(direction)
				queue_free()
				return
			else:
				body.Damage(direction)
				emit_signal("knockback")
				if(get_parent().dashlevel < 3):
					get_parent().dashlevel = 1
					get_parent().dashtimer = 0.0


	#if we are overlapping with an enemy then damage it and then free ourselves right after
	#use get_overlapping_bodies() and run through each one in a for loop
	#if body is in group "rat" or maybe body is in group "enemy"
	#body.Bonk()
	#queue_free()  so the hit box doesn't stick around any longer  sometimes queue_free() can take a frame or two to finally delete the scene though
	#set_physics_process(false)   so we dont keep detecting enemies and hitting them
	
	#instead of the above two lines we could just call free() which deletes the scene immediately
	#but people say that queue_free() is generally safer in terms of memory or whatever
	#ive never had any problems with just using free() when ive had to
	pass
