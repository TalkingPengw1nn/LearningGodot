extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var players : Array = [1, -1]
var first_turn : int
var player_turn : int
var turn_count : int
var winner : int
var turn_display
var turn_display_pos : Vector2i
var pos_list : Array
var cell_pos : Vector2i
var grid_size : int
var cell_size : int
var row_sum : int
var col_sum : int
var pdiagonal_sum : int
var adiagonal_sum : int


func _ready():
	grid_size = $Grid.texture.get_width()
	cell_size = grid_size/3
	turn_display_pos = $SidePanel/TurnDisplay.get_position()
	
	game()

	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		cell_pos = event.position / cell_size
		if event.position.x < grid_size and pos_list [cell_pos.y][cell_pos.x] == 0:
			pos_list [cell_pos.y][cell_pos.x] = player_turn
			put_mark(player_turn, cell_pos * cell_size + Vector2i(cell_size/2, cell_size/2))
			turn_count += 1	
			player_turn *= -1
			turn_display.queue_free()
			put_mark(player_turn,turn_display_pos + Vector2i(cell_size / 2.2 , cell_size / 2.2), true)
			print(pos_list)
			if check_win() != 0:
					$Sounds/WinSound.play()
					get_tree().paused = true
					$PauseScreen.show()
					if winner == 1:
						$PauseScreen.get_node("PauseLabel").text = "player O wins!"
					elif winner == -1:
						$PauseScreen.get_node("PauseLabel").text = "player X wins!"
			elif turn_count == 9:
				$Sounds/TieSound.play()
				get_tree().paused = true
				$PauseScreen.show()
				$PauseScreen.get_node("PauseLabel").text = "It's a TIE!"


func game():
	player_turn = players[randi() % players.size()]
	turn_count = 0
	winner = 0
	pos_list = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]
	row_sum = 0
	col_sum = 0
	pdiagonal_sum = 0
	adiagonal_sum = 0
	get_tree().call_group("circles","queue_free")
	get_tree().call_group("crosses","queue_free")
	put_mark(player_turn,turn_display_pos + Vector2i(cell_size / 2.2 , cell_size / 2.2), true)
	$PauseScreen.hide()
	get_tree().paused = false


func put_mark(player_turn, position, turn = false):
	if player_turn == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		if !turn: $Sounds/MarkSoundCircle.play()
		if turn: turn_display = circle
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if !turn: $Sounds/MarkSoundCross.play()
		if turn: turn_display = cross


func check_win():
	for i in (pos_list[0]):
		row_sum = pos_list[i][0] + pos_list[i][1] + pos_list[i][2]
		col_sum = pos_list[0][i] + pos_list[1][i] + pos_list[2][i]
		pdiagonal_sum = pos_list[0][0] + pos_list[1][1] + pos_list[2][2]
		adiagonal_sum = pos_list[2][0] + pos_list[1][1] + pos_list[0][2]
	
		if row_sum == 3 or col_sum == 3 or pdiagonal_sum == 3 or adiagonal_sum == 3:
			winner = 1
		if row_sum == -3 or col_sum == -3 or pdiagonal_sum == -3 or adiagonal_sum == -3:
			winner = -1
	return winner



func _on_pause_screen_restart():
	game()
	$Sounds/WinSound.stop()

func _on_restart_button_main_button_down():
	$Sounds/RestartSound.play()

func _on_restart_button_main_button_up():
	game()

				

