extends CharacterBody2D

enum Animal { BIRD, FISH, PHOENIX, NONE }

const FRICTION := 0.99

const BIRD_GRAVITY := 50.0

const BIRD_IMPULSE_X := 1000.0
const BIRD_IMPULSE_Y := 2000.0

const FISH_GRAVITY := 10.0
const FISH_MAX_SPEED := 20000.0

const COYOTE_TIME := 0.1
const INPUT_COOLDOWN := 0.25

## 1 if right, -1 if left
var facing_dir := 1

var current_animal := Animal.BIRD
var next_input := Animal.NONE

var input_timer := 0.0


func _physics_process(delta: float) -> void:
	var should_action := _handle_input(delta)

	_animal_movement()

	if should_action:
		_animal_action()

	_move_and_bounce()


func _animal_action():
	match current_animal:
		Animal.BIRD:
			_bird_action()
		Animal.FISH:
			_fish_action()
		Animal.PHOENIX:
			_phoenix_action()


func _animal_movement():
	match current_animal:
		Animal.BIRD:
			_bird_movement()
		Animal.FISH:
			_fish_movement()
		Animal.PHOENIX:
			_phoenix_movement()


func _bird_movement() -> void:
	velocity *= FRICTION
	velocity.y += BIRD_GRAVITY


func _bird_action() -> void:
	velocity.x += BIRD_IMPULSE_X
	velocity.y = min(-BIRD_IMPULSE_Y, velocity.y - BIRD_IMPULSE_Y)


func _fish_movement() -> void:
	velocity.y += FISH_GRAVITY


func _fish_action() -> void:
	velocity.x = lerp(velocity.x, FISH_MAX_SPEED, 0.25)


func _phoenix_movement() -> void:
	pass


func _phoenix_action() -> void:
	pass


## Returns whether or not to action
func _handle_input(delta: float) -> bool:
	input_timer -= delta

	var current_input := _get_current_input()

	if current_input != Animal.NONE and input_timer - COYOTE_TIME <= 0:
		next_input = current_input

	if input_timer <= 0 and next_input != Animal.NONE:
		input_timer = INPUT_COOLDOWN
		current_animal = next_input
		next_input = Animal.NONE
		return true

	return false


func _get_current_input() -> Animal:
	if Input.is_action_just_pressed("bird"):
		return Animal.BIRD

	if Input.is_action_just_pressed("fish"):
		return Animal.FISH

	if Input.is_action_just_pressed("phoenix"):
		return Animal.PHOENIX

	if Input.is_action_pressed("bird"):
		return Animal.BIRD

	if Input.is_action_pressed("fish"):
		return Animal.FISH

	if Input.is_action_pressed("phoenix"):
		return Animal.PHOENIX

	return Animal.NONE


func _move_and_bounce() -> void:
	move_and_slide()
