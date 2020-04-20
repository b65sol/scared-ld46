extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var emotion="Sad"
export var size = 0.5
export var direction = "right"
export var energy = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_face(emotion);
	self.set_direction(direction);
	get_node("Anim").play("Float")
	get_node("Anim").playback_speed = self.energy;
	pass # Replace with function body.

func update_size():
	var x = 1;
	if(get_node("Sprite").scale.x < 0) :
		x = -1;
	get_node("Sprite").scale = Vector2( x * size,  size )

func reduce_energy():
	self.energy -= 0.1;
	get_node("Anim").playback_speed = self.energy;

func increase_energy():
	self.energy += 0.1;
	get_node("Anim").playback_speed = self.energy;

func set_direction(dir):
	if(dir == "left"):
		get_node("Sprite").scale = Vector2(-1*size, size);
	else :
		get_node("Sprite").scale = Vector2(size, size);

func set_face(emption):
	self.emotion = emption;
	var faces = get_node("Sprite/Faces");
	var children = faces.get_children()
	for face in children:
		if(face.name == emption):
			face.show()
		else :
			face.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
