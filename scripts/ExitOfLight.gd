extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var has_been_entered = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("Default")
	pass # Replace with function body.

func get_resist():
	return -200;

func on_enter():
	if(!has_been_entered):
		has_been_entered = true
		return [
			["I'm free! I'm out!", 8+(randi()%10), -1 * (randi()%4)],
			["Hooray!", 8+(randi()%10), -1 * (randi()%7)]
		];
	else:
		return [
			["*Returning to the gentle light eases the spirit's worry.*", 3, -2],
			["I don't mind returning here...", 4, -2]
		];

func wait_conditions():
	return [];
