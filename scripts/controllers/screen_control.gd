extends Node3D

@onready var Audio_Player = $AudioStreamPlayer3D
@onready var Video_Player = $SubViewport/VideoController/MarginContainer/VBoxContainer/AspectRatioContainer/VideoStreamPlayer
@onready var Aspect_Container = $SubViewport/VideoController/MarginContainer/VBoxContainer/AspectRatioContainer
@onready var ratios = [1.0, 16.0/9, 4.0/3]

@export var Video: VideoStreamTheora

@export_enum("1/1", "16/9", "4/3") var Aspect_Ratio: int

func _ready():
	Aspect_Container.ratio = ratios[Aspect_Ratio]
	if Video:
		Video_Player.stream = Video
		Audio_Player.stream = AudioStreamOggVorbis.load_from_file(Video.file)
		Video_Player.play()
		Audio_Player.play()
