extends Node2D

@export var game_active := false
@export var score: int = 0

@onready var player_spawn = get_node("PlayerSpawn")
@onready var spawner = get_node("PipeSpawner")
@onready var hud = get_node("HUD")

# pipes stuff
var pipes = preload("res://scenes/pipes.tscn")

var time_to_spawn := 2.0
var time_elapsed := time_to_spawn

var spawned_pipes: Array = []

# player stuff
var player
var flappy = preload("res://scenes/bird.tscn")

func _on_player_died():
    game_active = false
    print("game over")
    await get_tree().create_timer(3.0).timeout
    print("waited 2")
    hud.game_ended.emit()
    player.queue_free()
    player = null


func on_game_started():
    # reset game
    game_active = true
    score = 0
    hud.score_updated.emit(0)
    # start player
    var new_flappy = flappy.instantiate()
    new_flappy.global_position = player_spawn.global_position
    player = new_flappy
    add_child(new_flappy)
    player.died.connect(_on_player_died)


func _ready():
    hud.score_updated.emit(0)
    hud.game_started.connect(on_game_started)


func increment_score():
    score += 1
    # todo: update score labels
    hud.score_updated.emit(score)


func _process(delta):
    # pipe spawning
    time_elapsed += delta
    if time_elapsed >= time_to_spawn and game_active:
        time_elapsed = 0.0
        # create a new pipe
        var new_pipes = pipes.instantiate()
        new_pipes.global_position = spawner.global_position
        add_child(new_pipes)

        spawned_pipes.append([new_pipes, false])

    var pipes_to_clear = []

    # figure out which pipes to score and clear
    for x in spawned_pipes.size():
        var this_pipe = spawned_pipes[x]

        # increase score when it player successfully passes it
        if (player
        and this_pipe[0].global_position.x <= player.global_position.x 
        and not this_pipe[1] 
        and game_active):
            increment_score()
            print("score: " + str(score))
            this_pipe[1] = true

        # destroy after it goes far enough
        if this_pipe[0].global_position.x < -50:
            pipes_to_clear.append(x)

    # clear pipes later
    for n in pipes_to_clear.size():
        var index_to_remove = pipes_to_clear[-n-1]
        var cleared_pipe = spawned_pipes.pop_at(index_to_remove)
        cleared_pipe[0].queue_free()

