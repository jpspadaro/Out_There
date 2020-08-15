extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setScene(scene):
	var s = load(scene)
	var old_scene = get_tree().current_scene
	get_tree().change_scene_to(s)
	old_scene.queue_free()
	
