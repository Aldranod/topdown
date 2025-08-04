class_name Pathfinder extends Node2D

var vectors: Array[Vector2] = [
	Vector2(0,-1), # UP
	Vector2(1,-1), # UP/RIGHT
	Vector2(1,0),  #RIGHT
	Vector2(1,1),  #DOWN/RIGHT
	Vector2(0,1),  #DOWN
	Vector2(-1,1), #DOWN/LEFT
	Vector2(-1,0), #LEFT
	Vector2(-1,-1) #UP/LEFT
]

var interests : Array[float] 
var obstacles : Array[float] = [0,0,0,0,0,0,0,0] 
var outcomes : Array[float] = [0,0,0,0,0,0,0,0] 
var rays : Array[RayCast2D] 

var move_dir : Vector2 = Vector2.ZERO
var best_path : Vector2 = Vector2.ZERO

@onready var timer: Timer = $Timer


func _ready() -> void:
	#Gather all raycasts
	for c in get_children():
		if c is RayCast2D:
			rays.append(c)
	# Normalize all vectors
	for v in vectors:
		v = v.normalized()
	#Perform initial pathifinder function
	set_path()
	#Connect our timer
	timer.timeout.connect(set_path)
	pass

func _process(delta: float) -> void:
	# smoothy out direction change
	move_dir = lerp(move_dir,best_path,10*delta)
	pass

#set the best path vector by checking desired direction and considering obstacles
func set_path() -> void:
	#get dir to player
	var player_dir : Vector2 = global_position.direction_to(PlayerManager.player.global_position)
	# reset obstacle values to 0
	for i in 8:
		obstacles[i] = 0
		outcomes[i] = 0
	# check each raycast for collision
	for i in 8:
		if rays[i].is_colliding():
			obstacles[i] += 4
			obstacles[get_next_i(i)] += 1
			obstacles[get_prev_i(i)] += 1
	# if no obstacles recommend dir to player
	if obstacles.max() == 0:
		best_path = player_dir
		return
	# populate our interest array
	interests.clear()
	for v in vectors:
		interests.append(v.dot(player_dir))
	# calculate outcomes array by combining interest and obstacles arrays
	
	for i in 8:
		outcomes[i] = interests[i] - obstacles[i]
	
	# set best path 
	
	best_path = vectors[outcomes.find(outcomes.max())]
	pass
	
func get_next_i( i : int ) -> int:
	var n_i : int = i+1
	if n_i >= 8:
		return 0
	else:
		return n_i	
	pass
	
func get_prev_i( i : int ) -> int:
	var n_i : int = i-1
	if n_i < 0:
		return 7
	else:
		return n_i	
	pass	
