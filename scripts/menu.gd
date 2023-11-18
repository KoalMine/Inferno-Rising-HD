extends CanvasLayer

signal hdr
signal glow

func _on_glow_toggled(toggled_on):
	glow.emit(toggled_on)


func _on_hdr_toggled(toggled_on):
	hdr.emit(toggled_on)
