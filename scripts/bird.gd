class_name Bird
extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@onready var anims = get_node("AnimatedSprite2D")
@onready var bird_collider = get_node("CollisionShape2D")

var alive := true
signal died

var FLAP_VELOCITY = -400.0
var DEATH_SPIN_SPEED = 10.0
var DEATH_SPIN_DIR = rng.randi_range(-1, 1)
var rotation_speed = 120.0

    
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
    anims.play("flying")

    if DEATH_SPIN_DIR == 0:
        DEATH_SPIN_DIR = -1

func _physics_process(delta):
    velocity.y += gravity * delta

    if deg_to_rad(rotation) < 60.0:
        rotation += deg_to_rad(rotation_speed) * delta

    if (global_position.y < 34 or global_position.y > 467) and alive:
        velocity.y = 0
        alive = false
        died.emit()

    var collision = move_and_collide(velocity * delta)
    if collision:
        var collider = collision.get_collider()
        if collider.name.find("Pipe") > 0:
            bird_collider.disabled = true
            alive = false
            velocity.y = FLAP_VELOCITY / 2
            died.emit()



func _process(delta):
    if Input.is_action_just_pressed("flap") and alive:
        velocity.y = FLAP_VELOCITY
        rotation = -45.0
    elif not alive:
        rotation = rotation + (DEATH_SPIN_SPEED * DEATH_SPIN_DIR * delta)
