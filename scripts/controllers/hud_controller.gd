extends CanvasLayer

@onready var hud = $HUD
@onready var crosshair = $HUD/Crosshair
@onready var health_bar = $HUD/HealthBar

func _on_player_spawned(player):
	player.health_changed.connect(update_health_bar)

func update_health_bar(health_value):
	health_bar.value = health_value
