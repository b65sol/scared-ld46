extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var has_been_entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(has_node("AnimationPlayer")):
		get_node("AnimationPlayer").play("Default");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_resist():
	if(has_been_entered) :
		return -100;
	else:
		return 60;

func on_failed_entry():
	return [
		["The monster peers into my eyes.", -3+(randi()%2), (randi()%4)],
		["I don't have the strength to face the monster.", -1+(randi()%3), (randi()%4)],
		["I... I can't face the monster.", -2+(randi()%3), (randi()%4)],
	];

func on_enter():
	if(!has_been_entered):
		has_been_entered = true
		get_node("Eyes").hide()
		return [
			["The monster peers into my eyes. But... it vanished?", 20, 20],
			["Yahhhhh!!!! Wait... The monster ran off!", 21, 20],
		];
	else:
		return [
			["There was a monster here...", 0, -2],
			["I don't want to be here again, but I was victorious...", 2, 2],
		];

func wait_conditions():
	return [
		["There was once a monster here...", 1, 3],
		["I wish I could bring you with me, little light.", 2+ (randi()%3), -1 * (randi()%3)],
		["*The lost spirit watches the orb*", 1, -1 * (randi()%4)],
		["If I had hands, I would catch you!", 1, -1],
		["I guess you're the light of my afterlife, little orb", 1, -3]
	];
