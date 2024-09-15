extends Node2D

@onready var game_manager = preload("res://Scenes/gameManager.tscn")
@onready var boss_fight_manager = preload("res://Scenes/bossFightManager.tscn")

var playerStats = preload("res://Scenes/playerStats.tres")

@onready var village_manager: Node2D = $villageManager

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var SFX = $SFX

var hasSeenBoss: bool = false

var oldScore: float = 0
var oldRescuedCount: int = 0

func _ready() -> void:
	load_game()
	village_manager.showVillage()

func gameStart():
	var g = game_manager.instantiate()
	add_child(g)
	village_manager.hideVillage()
	
func villageStart(score, rescuedCount):
	village_manager.showVillage()
	village_manager.earnResources(score + oldScore, rescuedCount + oldRescuedCount)
	oldScore = 0
	oldRescuedCount = 0
	save_game()
	print("saved game")

func bossFightStart(score, rescuedCount):
	hasSeenBoss = true
	oldScore = score
	oldRescuedCount = rescuedCount
	animation_player.play("screenTransitionToBoss")
	await animation_player.animation_finished
	animation_player.play("RESET")
	var b = boss_fight_manager.instantiate()
	add_child(b)

func save():
	var save_dict = {
		"filename": get_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y, 
		"hasSeenBoss": hasSeenBoss
	}
	return save_dict

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	ResourceSaver.save(playerStats, "user://playerStats.tres")
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

		
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		print("No save file")
		return # Error! We don't have a save to load.
	if ResourceLoader.exists("user://playerStats.tres"):
		playerStats = ResourceLoader.load("user://playerStats.tres").duplicate()
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		#i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = get_node(node_data["filename"])
		#get_node(node_data["parent"]).add_child(new_object)
		#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			print(i)
			print(node_data[i])
			new_object.set(i, node_data[i])
		for j in node_data.keys():
			if new_object.has_method("reload_page"):
				new_object.reload_page() 


func _on_timer_timeout() -> void:
	save_game()
	print("autosave")
