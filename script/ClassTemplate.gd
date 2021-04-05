extends HBoxContainer
signal class_button

func _on_Button1_pressed():
	emit_signal("class_button",self.get_name(),"view")

func _on_Button2_pressed():
	emit_signal("class_button",self.get_name(),"edit")
