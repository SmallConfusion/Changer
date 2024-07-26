class_name Player
extends CharacterBody2D

enum Animal { BIRD, FISH, PHOENIX, NONE }

var animal_movements := {
	Animal.BIRD: _bird_movement,
	Animal.FISH: _fish_movement,
	Animal.PHOENIX: _phoenix_movement,
}

var animal_actions := {
	Animal.BIRD: _bird_action,
	Animal.FISH: _fish_action,
	Animal.PHOENIX: _phoenix_action,
}

const FRICTION := 0.99

const BIRD_GRAVITY := 50.0

const BIRD_IMPULSE_X := 1000.0
const BIRD_IMPULSE_Y := 2000.0

const FISH_GRAVITY := 10.0
const FISH_MAX_SPEED := 20000.0

const COYOTE_TIME := 0.1
const INPUT_COOLDOWN := 0.25

var current_animal := Animal.BIRD
var next_input := Animal.NONE

var input_timer := 0.0

var previous_velocity: Vector2


func _physics_process(delta: float) -> void:
	print(get_direction())

	var should_action := _handle_input(delta)

	animal_movements[current_animal].call()

	if should_action:
		animal_actions[current_animal].call()

	_move_and_bounce()


func _bird_movement() -> void:
	velocity *= FRICTION
	velocity.y += BIRD_GRAVITY


func _bird_action() -> void:
	velocity.x += BIRD_IMPULSE_X * get_direction()
	velocity.y = min(-BIRD_IMPULSE_Y, velocity.y - BIRD_IMPULSE_Y)


func _fish_movement() -> void:
	velocity.y += FISH_GRAVITY


func _fish_action() -> void:
	velocity.x = lerp(velocity.x, FISH_MAX_SPEED * get_direction(), 0.25)


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

	if get_slide_collision_count() > 0:
		var col := get_slide_collision(0)
		velocity = previous_velocity.bounce(col.get_normal())

	previous_velocity = velocity


func get_direction() -> float:
	var dir: float = sign(velocity.x)

	if dir == 0:
		dir = 1

	return dir


func get_speed() -> float:
	return velocity.length()
