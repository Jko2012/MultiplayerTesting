class_name HeldItem
extends Node3D


signal action_started()
signal action_finished()

@onready var anim_player = $AnimationPlayer
@onready var raycast = $RayCast3D

@onready var can_do_primary = true
@onready var active_item = true
