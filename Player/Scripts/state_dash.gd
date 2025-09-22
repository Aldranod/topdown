class_name State_Dash extends State

@export var move_speed : float = 200.0
@export var effect_delay : float = 0.1
@export var dash_audio : AudioStream

@onready var idle: State = $"../Idle"

var direction : Vector2 = Vector2.ZERO
var next_state : State = null
var effect_timer : float = 0
	
func Enter() -> void:
	player.UpdateAnimation("dash")
	player.animation_player.animation_finished.connect( _on_animation_finished)
	direction = player.direction
	if direction == Vector2.ZERO:
		direction = player.cardinal_direction
	if dash_audio:
		player.audio.stream = dash_audio
		player.audio.play()	 
	pass
	
func Exit() -> void:
	player.animation_player.animation_finished.disconnect( _on_animation_finished)
	next_state = null
	pass
	
func Process(_delta: float) -> State:
	player.velocity = direction * move_speed
	return next_state

func Physics(_delta: float) -> State:
	return null	

func HandleInput(_delta: InputEvent) -> State:
	return null		
	
func _on_animation_finished(anim_name : String) -> void:
	next_state = idle
	pass					
