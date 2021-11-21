extends KinematicBody2D

enum PlayerId {
	Player1, Player2
}

export (PlayerId) var player_id
const SPEED = 15000

export var INITIAL_HEALTH = 100
export var COLOR = "blue"
export var SHOOT_OFFSET = 20
export var BULLET_SPEED = 600

var health = INITIAL_HEALTH setget set_health

var Spark = preload("res://game/bullet/Spark.tscn")

func _ready():
	_hide_other_player_huds()
	_update_health_indicators()
	$WispAnimation.play(COLOR)

func _physics_process(delta):
	var velocity = Input.get_vector(
		str("move_left_player", player_id + 1), 
		str("move_right_player", player_id + 1), 
		str("move_up_player", player_id + 1), 
		str("move_down_player", player_id + 1))
	
	move_and_slide(velocity * delta * SPEED)

func _input(event):
	if Input.is_action_just_pressed(str("primary_fire_player", player_id + 1)):
		
		var direction = Input.get_vector(
			str("aim_left_player", player_id + 1), 
			str("aim_right_player", player_id + 1), 
			str("aim_up_player", player_id + 1), 
			str("aim_down_player", player_id + 1)
		).normalized()
		
		if direction.length_squared() > 0.0:
			var spark = Spark.instance()
			get_parent().add_child(spark)
			spark.global_position = self.global_position + direction * SHOOT_OFFSET
			spark.initialize(Color.red, direction * BULLET_SPEED)
	
	pass

func set_health(new_health):
	health = new_health
	_update_health_indicators()

func _update_health_indicators():
	if (player_id == PlayerId.Player1):
		_update_health_indicator($HUD/HUD_Player1/ProgressBar)
	if (player_id == PlayerId.Player2):
		_update_health_indicator($HUD/HUD_Player2/ProgressBar)

func _update_health_indicator(health_indicator: ProgressBar):
	health_indicator.value = health
	health_indicator.max_value = INITIAL_HEALTH

func _hide_other_player_huds():
	if (player_id != PlayerId.Player1):
		$HUD/HUD_Player1.visible = false
	if (player_id != PlayerId.Player2):
		$HUD/HUD_Player2.visible = false
