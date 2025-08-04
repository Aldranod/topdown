class_name Plant extends Node2D

var is_choped : bool = false

@onready var is_choped_data: PersistentDataHandler = $IsChoped
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	$HitBox.Damaged.connect( TakeDamage )
	$Throwable.destroyed.connect( Destroy )
	set_plant_state()

func set_plant_state() -> void:
	is_choped = is_choped_data.value
	if is_choped:
		queue_free()

func TakeDamage( _damage : HurtBox ) -> void:
	animation_player.play("destroy")
	await animation_player.animation_finished
	is_choped_data.set_value()
	queue_free()
	pass
	
func Destroy() ->void:
	animation_player.play("destroy")
	await animation_player.animation_finished
	is_choped_data.set_value()
	queue_free()
	pass
		
	
