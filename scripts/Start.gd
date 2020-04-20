extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_up", self, "load_game")
	pass # Replace with function body.

func load_game():
	get_tree().change_scene("res://load_game.tscn")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
