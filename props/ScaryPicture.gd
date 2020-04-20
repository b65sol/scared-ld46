extends "res://scripts/EvilEyes.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Prevent fallback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_resist():
	if(has_been_entered) :
		return -200;
	else:
		return -200;

func on_enter():
	if(!has_been_entered):
		has_been_entered = true
		get_node("Eyes").hide()
		return [
			["This... this is too much.", -10, 20],
			["*The image overwhelms the spirit with dread*", -7, 20],
			["The picture reads 'the dark is all there is.'", -20, 20],
		];
	else:
		return [
			["The picture that was here was scary...", 0, -2],
			["The picture that was here was awful...", 0, -2],
		];

func wait_conditions():
	return [
		["The picture's gone... but I don't want to be here...", 1, 3],
		["Ugh... this place...", 0, 5],
	];

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
