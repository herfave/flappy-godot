class_name Pipes
extends Node2D

var SPEED = 200
var rng = RandomNumberGenerator.new()

@onready var upper_pipe = get_node("UpperPipe")
@onready var lower_pipe = get_node("LowerPipe")

func _ready():
    position.y = position.y + rng.randf_range(-100.0, 100.0)

func _physics_process(delta):
    position.x = position.x - (SPEED * delta)
