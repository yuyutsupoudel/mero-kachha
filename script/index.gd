extends Control
onready var textbox = get_node("HBoxContainer/MarginContainer/VBoxContainer/messagebox")
onready var email = get_node("HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/LineEdit")
onready var password = get_node("HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/LineEdit")
onready var http = get_node("HTTPRequest")
onready var http2 = get_node("HTTPRequest2")

func _ready():
	OS.window_borderless=true
	OS.window_resizable=false
func _on_login_pressed():
	if email.text.empty() or password.text.empty():
		textbox.set_text("Please enter Email and password.")
		yield(get_tree().create_timer(2.0),"timeout")
		textbox.text=""
	else:
		textbox.text="Connecting with database.."
		Firebase._user_login(email.text,password.text,http,http2)

func _on_cancel_pressed():
	get_tree().quit()

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code==0:
		textbox.set_text("CAN NOT CONNECT TO THE SERVER.")
		return
	var response_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code !=200:
		textbox.text = response_body.error.message.capitalize()
		email.set_text("")
		password.set_text("")

func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	if response_code==0:
		textbox.set_text("CAN NOT CONNECT TO THE SERVER.")
		return
	var response_body = JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code ==200:
		if response_body.fields.type.stringValue =="admin":
			textbox.text = "Sign in sucessful."
			ProjectSettings.set_setting("display/window/size/borderless",false)
			ProjectSettings.set_setting("display/window/size/resizable",true)
			yield(get_tree().create_timer(1.0),"timeout")
			get_tree().change_scene("res://scene/others/Main.tscn")
		else:
			textbox.text= "Sign in unsucessful."
			yield(get_tree().create_timer(2.0),"timeout")
			textbox.text=""
