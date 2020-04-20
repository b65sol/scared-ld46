extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var has_been_entered = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	if(has_node("AnimationPlayer")):
		get_node("AnimationPlayer").play("Default")
	pass # Replace with function body.

func get_resist():
	return -40;

func on_enter():
	if(!has_been_entered):
		has_been_entered = true
		return [
			["I like this light...", 8+(randi()%10), -1 * (randi()%4)],
			["*A gentle light envelopes the lost spirit*", 8+(randi()%10), -1 * (randi()%7)]
		];
	else:
		return [
			["*Returning to the gentle light eases the spirit's worry.*", 3, -2],
			["I don't mind returning here...", 4, -2]
		];

func wait_conditions():
	return [
		["I don't mind waiting here for sure.", 3+ (randi()%3), -1 * (2+ randi()%3)],
		["I wish I could bring you with me, little light.", 2+ (randi()%3), -1 * (2 + randi()%3)],
		["*The lost spirit watches the orb*", 3, -1 * (2 + randi()%4)],
		["If I had hands, I would catch you!", 3, -5],
		["I guess you're the light of my afterlife, little orb", 3, -5]
	];
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
