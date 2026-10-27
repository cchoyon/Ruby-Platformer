extends Node

const BGM_BUS = "BGM"
const SFX_BUS = "SFX"

var bgm_player: AudioStreamPlayer
var bgm_tween: Tween
var duck_tween: Tween

var default_bgm_db: float = -14.0
var current_bgm_stream: AudioStream
var is_paused_by_hit: bool = false

var hit_timer: Timer

func _ready() -> void:
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = BGM_BUS
	add_child(bgm_player)
	bgm_player.finished.connect(_on_bgm_finished)
	
	hit_timer = Timer.new()
	hit_timer.one_shot = true
	hit_timer.timeout.connect(_on_hit_timer_timeout)
	add_child(hit_timer)

func play_sfx(stream: AudioStream, pitch_variance: float = 0.08, volume_db: float = 0.0) -> void:
	if not stream:
		return
		
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.bus = SFX_BUS
	sfx_player.volume_db = volume_db
	sfx_player.pitch_scale = randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)
	
	add_child(sfx_player)
	sfx_player.play()
	sfx_player.finished.connect(sfx_player.queue_free)
	
	if bgm_player.playing and not is_paused_by_hit:
		_trigger_fast_duck()

func play_bgm(stream: AudioStream) -> void:
	current_bgm_stream = stream
	bgm_player.stream = stream
	is_paused_by_hit = false
	_apply_bgm_volume(default_bgm_db, 0.0)
	bgm_player.play()

func _on_bgm_finished() -> void:
	if not hit_timer.is_stopped() or is_paused_by_hit:
		return
		
	await get_tree().create_timer(3.5).timeout
	
	if hit_timer.is_stopped() and not is_paused_by_hit and current_bgm_stream:
		bgm_player.play()
		_apply_bgm_volume(default_bgm_db, 0.2)

func pause_bgm_on_hit() -> void:
	is_paused_by_hit = true
	hit_timer.start(10.0)
	if duck_tween and duck_tween.is_running():
		duck_tween.kill()
	_apply_bgm_volume(-80.0, 0.5, true)

func _on_hit_timer_timeout() -> void:
	is_paused_by_hit = false
	bgm_player.stream_paused = false
	if not bgm_player.playing and current_bgm_stream:
		bgm_player.play()
		
	_apply_bgm_volume(default_bgm_db, 0.2)

func _trigger_fast_duck() -> void:
	if is_paused_by_hit:
		return
		
	if duck_tween and duck_tween.is_running():
		duck_tween.kill()
		
	duck_tween = create_tween()
	duck_tween.tween_property(bgm_player, "volume_db", default_bgm_db - 2.0, 0.01)
	duck_tween.tween_property(bgm_player, "volume_db", default_bgm_db, 0.01)

func _apply_bgm_volume(target_db: float, duration: float, pause_at_end: bool = false) -> void:
	if bgm_tween and bgm_tween.is_running():
		bgm_tween.kill()
		
	bgm_tween = create_tween()
	bgm_tween.tween_property(bgm_player, "volume_db", target_db, duration)
	
	if pause_at_end:
		bgm_tween.tween_callback(func(): bgm_player.stream_paused = true)
