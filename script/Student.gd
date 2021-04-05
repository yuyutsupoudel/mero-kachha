extends Control
onready var table=get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table")

onready var template = preload("res://scene/others/StudentTemplate.tscn")
onready var template2 = preload("res://scene/others/Row.tscn")
onready var template3 = preload("res://scene/others/CheckButtonRow.tscn")
onready var gender_male = preload("res://assets/textures/male_teacher.png")
onready var gender_female = preload("res://assets/textures/female_teacher.png")
onready var gender_other = preload("res://assets/textures/flag.png")

onready var EditId =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditId")
onready var EditPhone =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditPhone")
onready var EditName =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditName")
onready var EditEmail =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditEmail")
onready var EditPassword =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditPassword")
onready var EditPassword2 =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditPassword2")
onready var EditFacility =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditFacility")
onready var EditAddress =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditAddress")
onready var EditGender =get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Data/EditGender")
onready var EditNameLabel = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/Label")
onready var EditTextbox = get_node("EditDialog/VBoxContainer/Label")
onready var EditClassList=get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ScrollContainer/Container")
onready var textbox = get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/Label")

onready var viewLabel = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/Label")
onready var viewId = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Field/Value/ViewId")
onready var viewPhone = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Field/Value/ViewPhone")
onready var viewName = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Field/Value/ViewName")
onready var viewEmail = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Field/Value/ViewEmail")
onready var viewFacility = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Field/Value/ViewFacility")
onready var viewAddress = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Field/Value/ViewAddress")
onready var viewGender = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Field/Value/ViewGender")
onready var ViewClassList = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Panel/VBoxContainer/ViewClassList/Table")
onready var viewProfile = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/PanelContainer/Profile")
onready var viewTextbox = get_node("ViewDialog/VBoxContainer/Label")

var  selected
var selected_id
var sn = 0
var profile = {}
var all_student_data

func _ready():
	textbox.text ="Connecting to database.."
	var path = "student/%s/students/" %Firebase.user_info.id
	Firebase.get_document(path,get_node("HTTPRequest"))

func set_student_data(data:Dictionary):
	sn=sn+1
	var new_item = template.instance()
	new_item.set_name("item" + str(sn))
	table.add_child(new_item)
	new_item.connect("student_button",self,"on_item_button_pressed")
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Sn").text = str(sn)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Id").text = data.id.stringValue
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Name").text = data.name.stringValue
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Phone").text = data.phone.stringValue
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Email").text =  data.email.stringValue

func on_item_button_pressed(item_name:String,button_name:String):
	selected = int(item_name)-1
	selected_id = all_student_data.documents[selected].name.split("/",true,0)[-1]
	if button_name == "view":
		#Removes any clild that may present in view class table
		var node = get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Panel/VBoxContainer/ViewClassList/Table/")
		for n in node.get_children():
			node.remove_child(n)
			n.queue_free()
			#checks if teacher is assigned any class or not
		if "values" in all_student_data.documents[selected].fields.cls_id.arrayValue:
			for i in range (0,all_student_data.documents[selected].fields.cls_id.arrayValue.values.size()):
				var new_item = template2.instance()
				new_item.set_name("item" + str(i))
				ViewClassList.add_child(new_item)
				get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Panel/VBoxContainer/ViewClassList/Table/"+new_item.name+"/RowId").text = all_student_data.documents[selected].fields.cls_id.arrayValue.values[i].stringValue
				get_node("ViewDialog/VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/HBoxContainer/Data/Panel/VBoxContainer/ViewClassList/Table/"+new_item.name+"/RowName").text = all_student_data.documents[selected].fields.cls_name.arrayValue.values[i].stringValue
		viewId.text = all_student_data.documents[selected].fields.id.stringValue
		viewLabel.text = all_student_data.documents[selected].fields.name.stringValue
		viewName.text = all_student_data.documents[selected].fields.name.stringValue
		viewPhone.text = all_student_data.documents[selected].fields.phone.stringValue
		viewEmail.text = all_student_data.documents[selected].fields.email.stringValue
		viewFacility.text = all_student_data.documents[selected].fields.facility.stringValue
		viewAddress.text = all_student_data.documents[selected].fields.address.stringValue
		var gender = int(all_student_data.documents[selected].fields.gender.stringValue)
		if gender ==0:
			viewGender.text = "Male"
			viewProfile.texture = gender_male
		elif gender ==1:
			viewGender.text ="Female"
			viewProfile.texture = gender_female
		elif gender ==2:
			viewGender.text ="Other"
			viewProfile.texture = gender_other
		else:
			viewGender.text ="ERROR"
		get_node("ViewDialog").popup()
	
	elif button_name == "edit":
		set_classes_template()
		#set data to edit dialog
		var node = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ScrollContainer/Container/")
		for n in node.get_children():
			if "values" in all_student_data.documents[selected].fields.cls_id.arrayValue:
				for i in range (0,all_student_data.documents[selected].fields.cls_id.arrayValue.values.size()):
					if n.get_child(0).text==all_student_data.documents[selected].fields.cls_id.arrayValue.values[i].stringValue:
						n.get_child(3).pressed=true
						break
		
		EditId.editable = false
		EditId.text=""
		EditId.placeholder_text = "Id can not be changed."
		EditPassword.editable = false
		EditPassword.text=""
		EditPassword.placeholder_text = "Password can not be changed."
		EditPassword2.editable =false
		EditPassword2.text=""
		EditPassword2.placeholder_text = "Password can not be changed."
		EditEmail.editable=false
		EditNameLabel.text = "Edit Student"
		EditId.text = all_student_data.documents[selected].fields.id.stringValue
		EditName.text = all_student_data.documents[selected].fields.name.stringValue
		EditPhone.text = all_student_data.documents[selected].fields.phone.stringValue
		EditEmail.text = all_student_data.documents[selected].fields.email.stringValue
		EditFacility.text = all_student_data.documents[selected].fields.facility.stringValue
		EditAddress.text = all_student_data.documents[selected].fields.address.stringValue
		EditGender.selected = int(all_student_data.documents[selected].fields.gender.stringValue)
		_on_EditGender_item_selected(int(all_student_data.documents[selected].fields.gender.stringValue))
		
		get_node("EditDialog").popup()

func set_classes_template():
	#adds checkable class list 
	var node = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ScrollContainer/Container/")
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		#checks if teacher is assigned any class or not
	if Global.all_class_data.has("documents"):
		for i in range(0,Global.all_class_data.documents.size()):
			var new_item = template3.instance()
			new_item.set_name(str(i))
			EditClassList.add_child(new_item)
			get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ScrollContainer/Container/"+new_item.name+"/RowId").text = Global.all_class_data.documents[i].fields.id.stringValue
			get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ScrollContainer/Container/"+new_item.name+"/RowName").text = Global.all_class_data.documents[i].fields.name.stringValue

func _on_EditGender_item_selected(index:int):
	profile = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/Profile")
	if index == 0:
		profile.texture = gender_male
	elif index ==1:
		profile.texture = gender_female
	else:
		profile.texture = gender_other

func _on_AddNew_pressed():
	EditId.text =""
	EditPhone.text =""
	EditName.text =""
	EditEmail.text =""
	EditPassword.text =""
	EditPassword2.text =""
	EditFacility.text =""
	EditAddress.text =""
	EditGender.selected = int(0)
	set_classes_template()
	_on_EditGender_item_selected(0)
	EditNameLabel.text = "ADD NEW STUDENT"
	EditId.editable = true
	EditId.placeholder_text = "Unique ID."
	EditPassword.editable = true
	EditPassword.placeholder_text = "Password"
	EditPassword2.editable =true
	EditPassword2.placeholder_text = "Varify password"
	EditEmail.editable=true
	get_node("EditDialog").popup()

func _on_Save_pressed():
	profile={
		"address":{"stringValue":EditAddress.text},
		"cls_id":{"arrayValue":{}},
		"cls_name":{"arrayValue":{}},
		"email":{"stringValue":EditEmail.text},
		"facility":{"stringValue":EditFacility.text},
		"gender":{"stringValue":str(EditGender.selected)},
		"id":{"stringValue":EditId.text},
		"name":{"stringValue":EditName.text},
		"phone":{"stringValue":EditPhone.text}
	}
	
	var class_id_array = []
	var class_name_array = []
	
	var node = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ScrollContainer/Container")
	for i in range(0,node.get_child_count()):
		var current_node = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ScrollContainer/Container/"+str(i))
		if current_node.get_child(3).pressed:
			class_id_array.push_back({"stringValue":current_node.get_child(0).text})
			class_name_array.push_back({"stringValue":current_node.get_child(2).text})
	profile.cls_id={"arrayValue":{"values":class_id_array}}
	profile.cls_name={"arrayValue":{"values":class_name_array}}
	
	if EditId.editable == true:
		#New student
		if EditEmail.text.empty() or EditPassword.text.empty() or EditPassword2.text.empty() or EditPassword.text !=EditPassword2.text:
			yield(get_tree().create_timer(2.0),"timeout")
			EditTextbox.text="Please check Email or password."
		else:
			EditTextbox.text="(1/3) Registering teacher.."
			Firebase.register(EditEmail.text,EditPassword2.text,get_node("HTTPRequest4"))
	
	else:
		#update student
		EditTextbox.text="Updating data.."
		var current_profile =all_student_data.documents[selected]
		var path = "student/"+Firebase.user_info.id+"/students/%s" %selected_id
		Firebase.update_document(path,profile,get_node("HTTPRequest3"))

func _on_Refresh_pressed():
	sn=0
	textbox.show()
	var node = get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table")
	for n in node.get_children():
		if n.name !="Label":
			node.remove_child(n)
			n.queue_free()
	_ready()

func _on_DeleteTeacher_pressed():
	get_node("WarningDialog").popup()

func _on_WarningYes_pressed():
	get_node("WarningDialog").hide()
	viewTextbox.text="Deleting student data(1/2).."
	var path = "student/"+Firebase.user_info.id+"/students/%s" %selected_id
	Firebase.delete_document(path,get_node("HTTPRequest6"))

func _on_WarningCancel_pressed():
	get_node("WarningDialog").hide()

func _on_LoadPicture_pressed():
	get_node("FileDialog").popup()

func _on_ClearPicture_pressed():
	 _on_EditGender_item_selected(EditGender.text)

func _on_Cancel_pressed():
	get_node("EditDialog").hide

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	
	if response_code==0:
		textbox.set_text("CAN NOT CONNECT TO THE SERVER.")
		yield(get_tree().create_timer(2.0),"timeout")
		textbox.text=""
		return
	if response_code==404:
		textbox.text = "Wow! Such a empty place."
		return
	var response_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code!=200:
		textbox.text = response_body.error.message.capitalize()
		yield(get_tree().create_timer(2.0),"timeout")
		textbox.text=""
		return
	if response_body.empty():
		print(response_code)
		textbox.text = "Wow! Such a empty place."
		return
	all_student_data = response_body
	textbox.text=""
	textbox.visible = false
	for i in range(0,all_student_data.documents.size()):
		var student_info =all_student_data.documents[i].fields
		set_student_data(student_info)
		
func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	var response_body:=JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code!= 200:
		EditTextbox.text = response_body.error.message
		yield(get_tree().create_timer(2.0),"timeout")
		textbox.text=""
	else:
		_on_Refresh_pressed()
		EditTextbox.text = "Student created sucessfully."
		yield(get_tree().create_timer(2.0),"timeout")
		textbox.text=""

func _on_HTTPRequest3_request_completed(result, response_code, headers, body):
	var response_body:=JSON.parse(body.get_string_from_ascii())
	if response_code!= 200:
		EditTextbox.text = response_body.result.error.message
		yield(get_tree().create_timer(2.0),"timeout")
		EditTextbox.text=""
	else:
		_on_Refresh_pressed()
		EditTextbox.text = "Data updated sucessfully."
		yield(get_tree().create_timer(2.0),"timeout")
		EditTextbox.text=""

func _on_HTTPRequest4_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code!= 200:
		print(response_body.result)
		if response_body.result.error.message =="EMAIL_EXISTS":
			EditTextbox.text = "Email already exists. Contact data administor to remove account or enter another email."
			yield(get_tree().create_timer(5.0),"timeout")
			EditEmail.text=""
			EditPassword.text=""
			EditPassword2.text=""
			EditTextbox.text=""
		else:
			EditTextbox.text = response_body.result.error.message
			yield(get_tree().create_timer(2.0),"timeout")
			EditTextbox.text=""
	else:
		EditTextbox.text = "(2/3) Saving student data...."
		var user_type ={
			"admin":{"stringValue":Firebase.user_info.id},
			"type":{"stringValue":"student"}}
		var path = "user_type?documentId=%s"%profile.email.stringValue
		Firebase.save_document(path,user_type,get_node("HTTPRequest5"))

func _on_HTTPRequest5_request_completed(result, response_code, headers, body):
	if response_code==0:
		EditTextbox.text="CONNECTION ERROR:Account created but data is not saved."
		return
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code!=200:
		EditTextbox.text=response_body.result.error.message
		return
	EditTextbox.text = "(3/3) Saving student data...."
	var path = "student/"+Firebase.user_info.id+"/students?documentId=%s" %profile.email.stringValue
	Firebase.save_document(path,profile,get_node("HTTPRequest2"))

func _on_HTTPRequest6_request_completed(result, response_code, headers, body):
	
	if response_code==200:
		viewTextbox.text="Deleting student data(2/2)...."
		var path = "user_type/%s" %selected_id
		Firebase.delete_document(path,get_node("HTTPRequest7"))
	else:
		var response_body = JSON.parse(body.get_string_from_ascii())
		viewTextbox.text=response_body.result.error.message
		yield(get_tree().create_timer(2.0),"timeout")
		viewTextbox.text=""
		
func _on_HTTPRequest7_request_completed(result, response_code, headers, body):
	if response_code==200:
		_on_Refresh_pressed()
		viewTextbox.text="Student deleted."
		yield(get_tree().create_timer(2.0),"timeout")
		viewTextbox.text=""
	else:
		viewTextbox.text="ERROR:Data deleted but id is still present."
