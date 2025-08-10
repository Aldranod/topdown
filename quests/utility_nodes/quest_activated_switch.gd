@tool
@icon("res://quests/utility_nodes/icons/quest_switch.png")
class_name QuestActivatedSwitch extends QuestNode

enum CheckType {HAS_QUEST, QUEST_STEP_COMPLETE, ON_CURRENT_QUEST, QUEST_COMPLETE}

signal is_activated_chaged( v : bool)

@export var check_type : CheckType = CheckType.HAS_QUEST : set = _set_check_type
@export var remove_when_activated : bool = false
@export var react_to_global_signal : bool = false

var is_activated : bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if react_to_global_signal == true:
		QuestManager.quest_updated.connect( _on_quest_updated)
	check_is_activated()		
	pass	
	
func check_is_activated() -> void:
	var _q : Dictionary = QuestManager.find_quest( linked_quest)
	if _q.title != "not found":
		if check_type == CheckType.HAS_QUEST:
			set_is_activated(true)
		elif check_type -- CheckType.QUEST_COMPLETE:
			set_is_activated(quest_complete == _q.is_complete)		
		pass
	else:
		set_is_activated(false)	
	pass
	
func set_is_activated(_v: bool) -> void:
	is_activated = _v
	is_activated_chaged.emit(_v)
	if is_activated == true:
		if remove_when_activated == true:
			hide_children()
		else:
			show_children()
	else:
		if remove_when_activated == true:
			show_children()
		else:
			hide_children()			
	pass	

func show_children() -> void:
	for c in get_children():
		c.visible = true
		c.process_mode = Node.PROCESS_MODE_INHERIT

func hide_children() -> void:
	for c in get_children():
		c.set_deferred("visible", false)
		c.set_deferred("process_mode",Node.PROCESS_MODE_INHERIT)		

func _on_quest_updated( _a : Dictionary) -> void:
	check_is_activated()

func _set_check_type(v :CheckType) -> void:
	check_type = v
	update_summary()


func update_summary() -> void:
	settings_summary = "UPDATE QUEST:\nQuest: "+ linked_quest.title + "\n"
	if check_type == CheckType.HAS_QUEST:
		settings_summary += "Checking if player has quest"
	elif check_type ==CheckType.QUEST_STEP_COMPLETE:
		settings_summary += "Checking if player has completed step: " + get_step()
	elif check_type ==CheckType.ON_CURRENT_QUEST:
		settings_summary += "Checking if player is on step: " + get_step()
	elif check_type ==CheckType.QUEST_COMPLETE:	
		settings_summary += "Checking if quest is complete"		
	pass	
