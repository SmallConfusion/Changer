class_name Player
extends CharacterBody2D

signal die

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

var animal_moves := {
	Animal.BIRD: _move_and_bounce.bind(Vector2(0.5, 1)),
	Animal.FISH: _move_and_bounce,
	Animal.PHOENIX: _move_and_bounce,
}

const FRICTION := 0.99
const BIRD_WATER_FRICTION := 0.9

const PHOENIX_FRICTION := 1.

const CHANGE_FRICTION := 0.85

const BIRD_GRAVITY := 50.0

const BIRD_IMPULSE_X := 1000.0
const BIRD_IMPULSE_Y := 2000.0

const FISH_GRAVITY := 30.0
const FISH_MAX_SPEED := 10000.0

const COYOTE_TIME := 0.1
const INPUT_COOLDOWN := 0.25

var current_animal := Animal.BIRD
var next_input := Animal.NONE

var previous_animal := Animal.BIRD

var dir := 1

var in_water := false
var in_fire := false

var input_timer := 0.0

var previous_velocity: Vector2

var inputs: Array[Animal] = []


func _physics_process(delta: float) -> void:
	if in_fire and current_animal != Animal.PHOENIX:
		die.emit()

	var should_action := _handle_input(delta)

	$Draw.set_animal(current_animal)

	animal_movements[current_animal].call()

	if should_action:
		animal_actions[current_animal].call()

	animal_moves[current_animal].call()

	if current_animal != previous_animal:
		velocity *= CHANGE_FRICTION

	$Draw.scale.x = dir

	previous_animal = current_animal


func _input(e: InputEvent):
	if e.is_action_pressed("bird"):
		inputs.push_front(Animal.BIRD)

	elif e.is_action_pressed("fish"):
		inputs.push_front(Animal.FISH)

	elif e.is_action_pressed("phoenix"):
		inputs.push_front(Animal.PHOENIX)

	elif e.is_action_released("bird"):
		inputs.erase(Animal.BIRD)

	elif e.is_action_released("fish"):
		inputs.erase(Animal.FISH)

	elif e.is_action_released("phoenix"):
		inputs.erase(Animal.PHOENIX)


func _bird_movement() -> void:
	velocity *= BIRD_WATER_FRICTION if in_water else FRICTION
	velocity.y += BIRD_GRAVITY


func _bird_action() -> void:
	velocity.x += BIRD_IMPULSE_X * get_direction()
	velocity.y = min(-BIRD_IMPULSE_Y, velocity.y - BIRD_IMPULSE_Y)


func _fish_movement() -> void:
	velocity.y += FISH_GRAVITY


func _fish_action() -> void:
	if in_water:
		velocity.x = lerp(velocity.x, FISH_MAX_SPEED * get_direction(), 0.25)
	else:
		input_timer = -1


func _phoenix_movement() -> void:
	velocity *= PHOENIX_FRICTION


func _phoenix_action() -> void:
	input_timer = -1


## Returns whether or not to action
func _handle_input(delta: float) -> bool:
	input_timer -= delta

	var current_input := _get_current_input()

	if (
		current_input != Animal.NONE
		and (input_timer - COYOTE_TIME <= 0 or current_input != current_animal)
	):
		next_input = current_input
		current_animal = next_input

	if input_timer <= 0 and next_input != Animal.NONE:
		input_timer = INPUT_COOLDOWN
		next_input = Animal.NONE
		return true

	return false


func _get_current_input() -> Animal:
	if len(inputs) > 0:
		return inputs[0]

	return Animal.NONE


func _move_and_bounce(bounce: Vector2 = Vector2(1, 1)) -> void:
	move_and_slide()

	if get_slide_collision_count() > 0:
		var normal := get_slide_collision(0).get_normal()
		velocity = previous_velocity.bounce(normal) * bounce

		if abs(normal.x) > 0.5:
			dir = sign(normal.x)

	previous_velocity = velocity


func get_direction() -> float:
	return dir


func get_speed() -> float:
	return velocity.length()


func water_enter() -> void:
	in_water = true


func water_exit() -> void:
	in_water = false


func fire_enter() -> void:
	in_fire = true


func fire_exit() -> void:
	in_fire = false


func acid_enter() -> void:
	die.emit()


func acid_exit() -> void:
	pass
