extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var messages = ["I don't know.", "I'm scared.", "Can you get me out of here?"]
var max_messages = 4;
export var fear = 50.0
export var hope = 58.0
export var wait_time = 1.0
var resist_offset = 0;
var tilemap;
var current_tile;
var exit_tile;
var item_classes = [];
var placements = {};
# Called when the node enters the scene tree for the first time.
func _ready():
	item_classes.append([]); #0
	item_classes.append([
		preload("res://props/EvilEyes.tscn")
	]); #1
	item_classes.append([
		preload("res://props/GentleLight.tscn"),
		preload("res://props/Candy.tscn")
	]); #2
	item_classes.append([
		preload("res://props/ScaryPicture.tscn")
	]); #3
	item_classes.append([]); #4
	item_classes.append([
		preload("res://props/ExitOfLight.tscn")
	]); #5
	update_bars();
	print_message_queue();
	get_node("Spirit").size = 0.4;
	get_node("Spirit").update_size()
	tilemap = get_node("TileMap")
	ready_tilemap();
	place_items();
	set_start_loc();
	request_wait()
	get_node("HUD_Controls/TurnWait").connect("timeout", self, "request_ready")
	set_process(true)
	update_bars()
	get_node("HUD_Controls/Controls/Down").connect("button_up", self, "advise", ["down"]);
	get_node("HUD_Controls/Controls/Up").connect("button_up", self, "advise", ["up"]);
	get_node("HUD_Controls/Controls/Left").connect("button_up", self, "advise", ["left"]);
	get_node("HUD_Controls/Controls/Right").connect("button_up", self, "advise", ["right"]);
	get_node("HUD_Controls/Controls/Wait").connect("button_up", self, "advise", ["wait"]);
	set_process_unhandled_key_input(true)
	pass # Replace with function body.

func tiletokey(tilecoord):
	return str(tilecoord.x)+'--'+str(tilecoord.y);

func _unhandled_key_input(event):
	if(get_node("HUD_Controls/Controls").visible):
		if(Input.is_action_just_released("ui_left")):
			advise("left")
		elif(Input.is_action_just_released("ui_right")):
			advise("right")
		elif(Input.is_action_just_released("ui_down")):
			advise("down")
		elif(Input.is_action_just_released("ui_up")):
			advise("up")
		elif(Input.is_action_just_released("ui_wait")):
			advise("wait")

func place_items():
	var used_cells = tilemap.get_used_cells();
	for set in used_cells:
		var type = tilemap.get_cell(set.x, set.y);
		if(len(item_classes[type])):
			placements[tiletokey(set)] = item_classes[type][randi() % len(item_classes[type])].instance();
			get_node("FieldItems").add_child(placements[tiletokey(set)]);
			var pos = tilemap.map_to_world(set);
			pos.x += 64;
			pos.y += 100;
			placements[tiletokey(set)].position = pos;

func check_comply(resistance, entry):
	var available_text = [];
	var compliance = false
	if(hope-resistance > 75):
		available_text.append("Sure!")
		available_text.append("Roger dodger!")
		available_text.append("Ok! Will head that way!")
		available_text.append("Let's go!")
		available_text.append("You know, the dark is bad for skin. Good thing I don't have any.")
		compliance = true;
	elif(hope-resistance > 50):
		available_text.append("Sounds good.")
		available_text.append("Alright.")
		available_text.append("*Nods*")
		available_text.append("I hope this works out.")
		available_text.append("Pressing onward.")
		compliance = true;
	elif(hope-resistance > 20):
		if(randi() % 100 > 80):
			compliance = false;
			available_text.append("Why?")
			available_text.append("I don't know about this...")
			available_text.append("...")
			available_text.append("Not... not right now...")
		else:
			compliance = true
			available_text.append("Are you sure?")
			available_text.append("Well... Ok")
			available_text.append("...")
			available_text.append("I'll try")
	else:
		var check_val;
		if(hope <= 20 && resistance < 10):
			check_val = 80;
		else :
			check_val = 95;
		if(randi() % 100 > 80):
			compliance = true
			available_text.append("I really don't think this is a good idea.")
			available_text.append("Everything is so dark... Why am I listening to you?")
			available_text.append("This will probably end poorly.")
			available_text.append("Ugh. Are you really sure about this?")
		else:
			compliance = false
			available_text.append("NoO[b]O[/b]oO!");
			available_text.append("I'm not listening to you anymore!")
			available_text.append("I can't do this! [b]I WON'T![/b]")
			available_text.append("Never never never neverneverner!")
	if( (entry && entry.has_method("on_failed_entry")) && compliance == false ):
		var results = entry.on_failed_entry()
		var sel_result = results[randi() % len(results)];
		add_message(sel_result[0]);
		hope += sel_result[1];
		fear += sel_result[2];
		update_bars();
		return false;
		
	if(len(available_text)):
		add_message(available_text[randi() % len(available_text)])
	return compliance

func advise(action):
	add_message("[Advise: "+action+"]")
	if(hope <= 0) :
		hope = 0
		self.wait_time = 4;
	elif(hope > 50):
		self.wait_time = 0.5
	else:
		self.wait_time = 1
	request_wait()
	var target = Vector2(self.current_tile.x, self.current_tile.y)
	var new_tile = Vector2(self.current_tile.x, self.current_tile.y)
	if(action == "left"):
		target = Vector2(self.current_tile.x-1, self.current_tile.y)
	elif(action == "right"):
		target = Vector2(self.current_tile.x+1, self.current_tile.y)
	elif(action == "up"):
		target = Vector2(self.current_tile.x, self.current_tile.y-1)
	elif(action == "down"):
		target = Vector2(self.current_tile.x, self.current_tile.y+1)
	elif(action == "wait"):
		if(hope < 10):
			var wait_texts = [
				"You'll wait for me to be ready? Really?",
				"Thanks...",
				"Hmm... yeah. Waiting a moment should be good.",
				"Ok. I'll take a break."
			];
			hope+=5;
			fear-=5;
			add_message(wait_texts[randi() % len(wait_texts)])
		var wait_outcomes = determine_wait_outcomes();
		if( len(wait_outcomes) > 0 ) :
			var wait_outcome = wait_outcomes[randi() % len(wait_outcomes)]
			add_message(wait_outcome[0]);
			fear += wait_outcome[2];
			hope += wait_outcome[1];
		update_bars()
	
	if(target != self.current_tile):
		var resist = resist_offset
		var entry = false;
		if(tiletokey(target) in placements) :
			entry = placements[tiletokey(target)]
			if(entry.has_method("get_resist")):
				resist = entry.get_resist() + resist_offset;
		if(check_comply(resist, entry)):
			new_tile = target;
			if(target.x != self.current_tile.x):
				if(target.x < self.current_tile.x):
					get_node("Spirit").set_direction("left")
				else:
					get_node("Spirit").set_direction("right")
			if(entry and entry.has_method("on_enter")):
				var entry_results = entry.on_enter();
				if(len(entry_results)):
					var sel_result = entry_results[randi() % len(entry_results)];
					add_message(sel_result[0]);
					hope += sel_result[1];
					fear += sel_result[2];
					update_bars();
		else:
			fear += 2;
			hope -= 2;
			update_bars();

	if(new_tile != self.current_tile):
		var start_pos = get_node("Spirit").position;
		var new_pos = tilemap.map_to_world(new_tile);
		var content_of_cell = tilemap.get_cell(new_tile.x, new_tile.y);
		if(content_of_cell == -1) :
			fear += 2
			hope -= 2
			update_bars()
		new_pos.x += 64;
		new_pos.y += 32;
		var tween = Tween.new();
		self.current_tile = new_tile;
		tween.interpolate_property(get_node("Spirit"), "position", start_pos, new_pos, self.wait_time-0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		add_child(tween)
		tween.start()
	update_bars()

func _process(delta):
	get_node("HUD_Controls/WaitBar").value = 100 * ( (self.wait_time - get_node("HUD_Controls/TurnWait").time_left) / self.wait_time);

func request_wait():
	get_node("HUD_Controls/Controls").hide()
	get_node("HUD_Controls/WaitBar").value = 0;
	get_node("HUD_Controls/WaitBar").show();
	get_node("HUD_Controls/TurnWait").wait_time = self.wait_time
	get_node("HUD_Controls/TurnWait").start()

func request_ready():
	if self.current_tile == self.exit_tile :
		get_node("HUD_Controls/Controls").hide();
		get_node("HUD_Controls/EndControls").show();
		add_message("THANKS!")
	else:
		get_node("HUD_Controls/EndControls").hide();
		get_node("HUD_Controls/Controls").show();
		get_node("HUD_Controls/WaitBar").hide();

func ready_tilemap():
	randomize()
	tilemap.clear()
	var min_coord = -15
	var coord_range = 32
	var min_exit_distance = 14
	#Pick start location.
	var startloc = Vector2(min_coord + (randi() % coord_range), min_coord + (randi() % coord_range))
	tilemap.set_cell(startloc.x, startloc.y, 4);
	var endloc = Vector2(min_coord + (randi() % coord_range), min_coord + (randi() % coord_range))
	while vector_taxi_dist(endloc, startloc) < min_exit_distance or tilemap.get_cell(endloc.x, endloc.y) != -1:
		endloc = Vector2(min_coord + (randi() % coord_range), min_coord + (randi() % coord_range));
	tilemap.set_cellv(endloc, 5)
	
	for n in range(1,25):
		set_item(min_coord, coord_range, 2);
	
	for n in range(1,18):
		set_item(min_coord, coord_range, 1);

	for n in range(1,16):
		set_item(min_coord, coord_range, 3);
	tilemap.set_cellv(endloc, 5)

func set_item(min_coord, coord_range, index):
	var targetloc = Vector2(min_coord + (randi() % coord_range), min_coord + (randi() % coord_range));
	while tilemap.get_cell(targetloc.x, targetloc.y) != -1:
		targetloc = Vector2(min_coord + (randi() % coord_range), min_coord + (randi() % coord_range));
	tilemap.set_cellv(targetloc, index)

func vector_taxi_dist(v1, v2):
	return abs(v1.x - v2.x)+abs(v1.y - v2.y);

func set_start_loc():
	var used = tilemap.get_used_cells()
	print(used)
	for set in used:
		var val = tilemap.get_cell(set.x, set.y)
		if(val == 4) :
			self.current_tile = set
			var startloc = tilemap.map_to_world(set);
			get_node("Spirit").position = Vector2(startloc.x+64, startloc.y + 32)
			print(get_node("Spirit").position)
		elif(val == 5) :
			self.exit_tile = set;
	print("Not implemented yet.")

func update_bars():
	if(fear >= 105):
		fear = 105
	if(hope >= 105):
		hope = 105
	if(fear < 0):
		fear = 0
	if(hope < 0):
		hope = 0
	var emotion_label = ""
	if(hope > 60 and fear > 75) :
		get_node("Spirit").set_face("Determined");
		emotion_label = "Determined"
		resist_offset -= 25;
	elif(hope > 60) :
		get_node("Spirit").set_face("Happy");
		emotion_label = "Content"
		resist_offset -= 15;
	elif(hope <= 60 and fear > 60) :
		get_node("Spirit").set_face("Scared")
		emotion_label = "Scared"
		resist_offset = 10
	elif(hope <= 30 and fear > 40):
		get_node("Spirit").set_face("Scared")
		emotion_label = "Scared"
		resist_offset = 10
	else:
		get_node("Spirit").set_face("Sad")
		emotion_label = "Empty"
		resist_offset = 0
	
	if(hope < 5):
		get_node("Spirit").set_face("Scared")
		emotion_label = "Hopeless"
		resist_offset = 1

	if( exit_tile ):
		var exit_distance = abs(current_tile.x - exit_tile.x) + abs(current_tile.y - exit_tile.y)
		get_node("HUD_Controls/ExitDistance").text = "To Exit: "+str(exit_distance);
	get_node("HUD_Controls/EmotionLabel").text = emotion_label;
	get_node("HUD_Controls/FearBar").value = fear;
	get_node("HUD_Controls/HopeBar").value = hope;

func add_message(msg):
	messages.push_back(msg)
	while(len(messages) > max_messages):
		messages.pop_front()
	print_message_queue();

func print_message_queue():
	get_node("HUD_Controls/MessagesArea").bbcode_enabled = true;
	var output_string = "";
	for msg in messages:
		output_string += msg+"\n";
	get_node("HUD_Controls/MessagesArea").bbcode_text = output_string


func determine_wait_outcomes():
	var c_cell = tilemap.get_cell(self.current_tile.x, self.current_tile.y);
	var conditions = [];
	if(tiletokey(self.current_tile) in placements) :
		var entry = placements[tiletokey(self.current_tile)]
		if(entry.has_method("wait_conditions")):
			return entry.wait_conditions()
	if(c_cell == -1) :
		conditions.append(["*Looks around*", 1+randi()%3, -1 + (randi()%2)])
		conditions.append(["*Meditates*", 1+randi()%2, 1])
		conditions.append(["*The spirit hums a song*", 2+randi()%2, -3])
		if(fear > 60):
			conditions.append(["No, I... I don't want to wait here. I'm too scared! Someplace else! Please!", -3, 5])
	else:
		conditions.append(["*Meditates*", randi()%3, -1])
	return conditions;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
