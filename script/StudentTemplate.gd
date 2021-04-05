extends HBoxContainer
signal student_button

func _on_Button1_pressed():
	emit_signal("student_button",self.get_name(),"view")

func _on_Button2_pressed():
	emit_signal("student_button",self.get_name(),"edit")
