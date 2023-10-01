extends Node

const BUS_MUSIC: String = "Music"
const BUS_SFX: String = "SFX"



func play_sound(sound_path: String) -> void:
	if not ResourceLoader.exists(sound_path):
		push_error("ERROR: No file found. File name: %s" % sound_path)
		return
	var sound: AudioStream = ResourceLoader.load(sound_path)
	var audio: AudioStreamPlayer = _create_temp_audio_player()
	audio.stream = sound
	audio.play()



## Private helpers

func _create_temp_audio_player() -> AudioStreamPlayer:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	get_tree().root.add_child(audio)
	audio.bus = BUS_SFX
	
	audio.finished.connect(
		func():
			audio.queue_free()
	)
	
	return audio




