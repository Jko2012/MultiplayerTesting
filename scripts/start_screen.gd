extends Control

@onready var address_entry = $MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var username_entry = $MainMenu/MarginContainer/VBoxContainer/UsernameEntry

func _on_host_button_pressed():
	GameManager.hosting_world(username_entry.text)
	pass # Replace with function body.


func _on_join_button_pressed():
	GameManager.joining_world(username_entry.text)
	pass # Replace with function body.
