class_name State_Dash extends State

@export var move_speed : float = 200.0

func _ready():
	pass
	
func init() -> void:
	pass	
	
func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State:
	return null	

func HandleInput(_delta: InputEvent) -> State:
	return null						
