extends CanvasLayer

@onready var score_label: Label = get_node("Score")
@onready var start_button: Button = get_node("Start")

signal score_updated
signal game_started
signal game_ended

func _ready():
    start_button.pressed.connect(start_pressed)
    game_ended.connect(_on_game_ended)

func start_pressed():
    start_button.hide()
    game_started.emit()

func _on_score_updated(score: int):
    score_label.text = str(score)

func _on_game_ended():
    start_button.show()
    print("show start")
