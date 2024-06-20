extends Control


@onready var video_player = $MarginContainer/VBoxContainer/AspectRatioContainer/VideoStreamPlayer
@onready var play_button = $MarginContainer/VBoxContainer/HBoxContainer/PauseButton
@onready var video_slider = $MarginContainer/VBoxContainer/HBoxContainer/SeekSlider
@onready var video_time = $MarginContainer/VBoxContainer/HBoxContainer/TimeLabel

func _ready():
	video_time.set_text(str(video_player.get_stream_length()))
	




func _on_check_box_toggled(toggled_on):
	video_player.set_paused(toggled_on)
	pass # Replace with function body.
