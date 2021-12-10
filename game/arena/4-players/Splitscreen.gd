extends CanvasLayer

export var WORLD: PackedScene

onready var viewport1 = $"MarginContainer/GridContainer/Container 1/Viewport"
onready var grid = $"MarginContainer/GridContainer"


func _ready():
	var world = WORLD.instance()
	viewport1.add_child(world, true)
	
	for i in range(1,grid.get_child_count() + 1):
		var view : Viewport = get_node("MarginContainer/GridContainer/Container " + str(i) + "/Viewport")
		if(view != null):
			var zoom_size = 1.5
			var cam : Camera2D = view.get_node("Camera")
			
			view.world_2d = viewport1.world_2d
			
			var player = get_node("MarginContainer/GridContainer/Container 1/Viewport/Arena 4 Players/Players/Player" + str(i))
			cam.zoom = Vector2(zoom_size,zoom_size)
			cam.target = player
