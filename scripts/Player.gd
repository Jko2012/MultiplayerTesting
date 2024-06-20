extends CharacterBody3D

signal health_changed(health_value)

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MAX_HEALTH = 10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = MAX_HEALTH
var doing_action = false
var inventory: Array = []
var selected_item = 0

@onready var curr_item: HeldItem = $Camera3D/ItemNone
@onready var camera = $Camera3D
@onready var anim_player = $AnimationPlayer

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true
	inventory.append(curr_item)

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .0025)
		camera.rotate_x(-event.relative.y * .0025)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if doing_action:
		pass
	elif Input.is_action_just_pressed("scroll_up"):
		swap_to_next_item()
	elif input_dir != Vector2.ZERO and is_on_floor():
		anim_player.play("move")
	else:
		anim_player.play("idle")
	
	move_and_slide()

@rpc("any_peer")
func receive_damage():
	health -= 1
	if health <= 0:
		health = MAX_HEALTH
		position = Vector3.ZERO
	health_changed.emit(health)

func action_start():
	anim_player.stop()
	doing_action = true

func action_stop():
	anim_player.play("idle")
	doing_action = false

func _on_swap_to_item(item: HeldItem, itemType: Resource):
	item.action_started.connect(action_start)
	item.action_finished.connect(action_stop)
	GameManager.Players[str(name).to_int()]["holding"] = itemType

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "primary":
		anim_player.play("idle")

func _on_item_area_3d_area_entered(area):
	var Item := area.get_parent() as FloatingItem
	if Item != null:
		var new_item = Item.TargetItem.instantiate() as HeldItem
		if new_item != null:
			add_item_to_inventory(new_item)
			#camera.add_child(holding)
			#holding.set_owner(self)
			#_on_pickup_item(holding, Item.TargetItem)

func add_item_to_inventory(Item: HeldItem):
	if !inventory.has(Item):
		inventory.append(Item)

func add_item_to_hand(Item: HeldItem):
	curr_item.replace_by(Item)
	curr_item = Item

func item_pickup(Item: HeldItem):
	add_item_to_inventory(Item)
	pass

func swap_to_next_item():
	selected_item += 1
	if selected_item >= inventory.size():
		selected_item = 0
	add_item_to_hand(inventory[selected_item])
