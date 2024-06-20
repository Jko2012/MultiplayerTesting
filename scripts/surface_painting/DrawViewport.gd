extends SubViewport

@onready var brush: Node2D = $Brush

func paint(position: Vector2, color: Color = Color(1, 1, 1)):
	brush.queue_brush(position * 10240, color)
