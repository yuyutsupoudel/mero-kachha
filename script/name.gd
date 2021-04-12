extends LineEdit

func _on_Name_focus_entered():
	$AnimationPlayer.play("test")

func _on_Name_focus_exited():
	$AnimationPlayer.play_backwards("test")
