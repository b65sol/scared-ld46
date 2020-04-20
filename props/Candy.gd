extends "res://scripts/GentleLight.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_resist():
	return -80;

func on_enter():
	if(!has_been_entered):
		has_been_entered = true
		get_node("Sprite").hide();
		get_node("Sprite2").modulate = Color(66,66,66)
		return [
			["Yay! Candy!", 25+(randi()%10), -10 * (randi()%4)],
			["It's candy! It's candy!", 25+(randi()%10), -10 * (randi()%7)]
		];
	else:
		return [
			["I wish there were more candy here...", 3, -2],
			["I want me candy and to eat it too.", 4, -2]
		];

func wait_conditions():
	return [
		["If only the candy grew back...", 1+ (randi()%3), -1 * (1+ randi()%3)],
	];

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
