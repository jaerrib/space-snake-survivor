extends Node

const MAX_CHANNELS = 16

var channels: Array = []
var channel_meta: Dictionary = {}
var global_volume: float = 1.0
var ui_player: AudioStreamPlayer = null
var music_player: AudioStreamPlayer = null
var alert_player: AudioStreamPlayer = null


func _ready() -> void:
	ui_player = AudioStreamPlayer.new()
	ui_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(ui_player)
	
	music_player = AudioStreamPlayer.new()
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)

	alert_player = AudioStreamPlayer.new()
	alert_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(alert_player)
	
	for i in range(MAX_CHANNELS):
		var player := AudioStreamPlayer2D.new()
		add_child(player)
		channels.append(player)
		channel_meta[player] = {"priority": 0, "type": null}


func play_ui_sound(s_type: int) -> void:
	var stream: AudioStream = SoundDefs.UI_SOUND_TYPES.get(s_type, null)
	if stream:
		ui_player.stream = stream
		ui_player.volume_db = _calculate_volume(
			SoundDefs.UI_SOUND_VOLUMES.get(s_type, 1.0)
			)
		ui_player.play()


func play_music(level: int) -> void:
	var s_type: int = level % (len(SoundDefs.MUSIC_TYPES) - 2) # exclude menu music
	var stream: AudioStream
	if level == -1:
		stream = SoundDefs.MUSIC_TYPES.get(len(SoundDefs.MUSIC_TYPES) - 1, null)
	elif level == -2:
		stream = SoundDefs.MUSIC_TYPES.get(len(SoundDefs.MUSIC_TYPES) - 2, null)
	else:
		stream = SoundDefs.MUSIC_TYPES.get(s_type, null)
	if stream:
		music_player.stream = stream
		music_player.volume_db = _calculate_volume(
			SoundDefs.MUSIC_VOLUMES.get(s_type, 0.4)
			)
		music_player.play()


func stop_music() -> void:
	music_player.stop()


func pause_music() -> void:
	music_player.stream_paused = true


func resume_music() -> void:
	music_player.stream_paused = false


func play_alert(s_type: int, volume: float = 1.0) -> void:
	var stream: AudioStream = SoundDefs.LOOPING_SOUND_TYPES.get(s_type, null)
	if stream:
		alert_player.stream = stream
		alert_player.volume_db = _calculate_volume(
			SoundDefs.LOOPING_SOUND_VOLUMES.get(s_type, volume)
			)
		alert_player.play()



func stop_alert() -> void:
	alert_player.stop()


func pause_alert() -> void:
	if alert_player.playing:
		alert_player.stream_paused = true


func resume_alert() -> void:
	if alert_player.stream_paused:
		alert_player.stream_paused = false


func play_sound_at(s_type: int, position: Vector2) -> void:
	var stream: AudioStream = SoundDefs.SOUND_TYPES.get(s_type, null)
	if stream == null:
		return
	var priority: int = SoundDefs.SOUND_PRIORITIES.get(s_type, 1)
	for player in channels:
		if not player.playing:
			_use_channel(player, stream, s_type, priority, position)
			return
	var lowest_player: AudioStreamPlayer2D = null
	var lowest_priority: float = float("inf")
	for player in channels:
		var p: int = int(channel_meta[player]["priority"])
		if p < lowest_priority:
			lowest_priority = p
			lowest_player = player
	if priority > lowest_priority and lowest_player:
		lowest_player.stop()
		_use_channel(lowest_player, stream, s_type, priority, position)


func _use_channel(
	player: AudioStreamPlayer2D,
	stream: AudioStream,
	s_type: int,
	priority: int,
	position: Vector2) -> void:
	player.global_position = position
	player.stream = stream
	player.volume_db = _calculate_volume(
		SoundDefs.SOUND_VOLUMES.get(s_type, 1.0)
		)
	player.play()
	channel_meta[player] = {"priority": priority, "type": s_type}


func _calculate_volume(base_volume: float) -> float:
	return linear_to_db(base_volume * global_volume)
