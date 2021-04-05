extends Control
onready var table = $VBoxContainer/PanelContainer2/ScrollContainer/Table
onready var template = preload("res://scene/others/ClassTemplate.tscn")
onready var textbox = get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/Label")

onready var EditId = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer2/EditId")
onready var LabelId = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer2/LabelId")
onready var EditName = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3//HBoxContainer3/EditName")
onready var LabelName = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer3/LabelName")
onready var EditTag = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3//HBoxContainer4/EditTag")
onready var LabelTag = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer4/LabelTag")
onready var EditTeacherSelectable= get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer/EditTeacherSelectable")
onready var LabelTeacher= get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer/EditTeacher")
onready var EditDiscription = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/VBoxContainer5/EditDiscription")
onready var NotificationLabel = get_node("EditDialog/VBoxContainer/Label")
onready var mainLabel = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer3/PanelContainer/VBoxContainer/Label")
onready var saveButton = get_node("EditDialog/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/HBoxContainer2/Button2")
var local_teacher_data
var save_button_state
var selected
var sn = 0
var class_info = {
	"id":{},
	"name":{},
	"tag" : {},
	"teacher":{},
	"teacherid":{},
	"Discription":{}
}
func _ready():
	textbox.visible = true
	textbox.text ="Loading."
	var path = "class/%s/classes/" %Firebase.user_info.id
	textbox.text ="Connecting to database.."
	Firebase.get_document(path,get_node("HTTPRequest"))

func on_item_button_pressed(item_name : String, button_name : String):
	selected = int(item_name)-1
	if button_name == "view":
		save_button_state="view"
		
		LabelTeacher.visible=true
		LabelId.visible= true
		LabelName.visible= true
		LabelTag.visible= true
		EditDiscription.readonly=true
		
		EditId.visible=false
		EditName.visible=false
		EditTag.visible=false
		EditTeacherSelectable.visible = false
		saveButton.text="Delete"
		mainLabel.text=Global.all_class_data.documents[selected].fields.id.stringValue+"  "+ Global.all_class_data.documents[selected].fields.name.stringValue
		#set data to view dialog
		LabelId.text = Global.all_class_data.documents[selected].fields.id.stringValue
		LabelName.text=Global.all_class_data.documents[selected].fields.name.stringValue
		LabelTag.text=Global.all_class_data.documents[selected].fields.tag.stringValue
		EditDiscription.text=Global.all_class_data.documents[selected].fields.discription.stringValue
		LabelTeacher.text=Global.all_class_data.documents[selected].fields.teacher.stringValue
		get_node("EditDialog").popup()
	
	elif button_name == "edit":
		# Adds teachers in class creation tab
		save_button_state="edit"
		saveButton.text="Save"
		EditTeacherSelectable.clear()
		if  Global.all_teacher_data != null:
			for i in range(0,Global.all_teacher_data.documents.size()):
				var teacher_info =Global.all_teacher_data.documents[i].fields
				EditTeacherSelectable.add_item(teacher_info.name.stringValue,true)
		
		EditTeacherSelectable.visible = true
		EditName.visible=true
		EditId.visible=true
		EditTag.visible=true
		EditTeacherSelectable.visible = true
		
		EditDiscription.readonly=false
		LabelTeacher.visible=false
		LabelId.visible= false
		LabelName.visible= false
		LabelTag.visible= false
		
		saveButton.disabled = false
		mainLabel.text = "Edit :  "+Global.all_class_data.documents[selected].fields.id.stringValue
		EditId.editable=true
		#set data to edit dialog
		EditId.text = Global.all_class_data.documents[selected].fields.id.stringValue
		EditName.text=Global.all_class_data.documents[selected].fields.name.stringValue
		EditTag.text=Global.all_class_data.documents[selected].fields.tag.stringValue
		EditDiscription.text=Global.all_class_data.documents[selected].fields.discription.stringValue
		#checks if teacher assigned to class still has id or not
		for i in range(0,Global.all_teacher_data.documents.size()):
			if Global.all_teacher_data.documents[i].fields.email.stringValue==Global.all_class_data.documents[selected].fields.teacherid.stringValue:
				EditTeacherSelectable.selected=selected
				print("yes")
				break
		get_node("EditDialog").popup()
		
func _on_AddNew_pressed():
	EditTeacherSelectable.visible = true
	EditName.visible=true
	EditId.visible=true
	EditTag.visible=true
	
	LabelTeacher.visible=false
	LabelId.visible=false
	LabelName.visible=false
	LabelTag.visible=false
	save_button_state="new"
	saveButton.text="Save"
	mainLabel.text="Add new class:"
	EditId.text=""
	EditName.text=""
	EditTag.text=""
	EditDiscription.text=""
	EditTeacherSelectable.selected=-1
	EditId.editable=true
	
	get_node("EditDialog").popup()
	
	if Global.all_teacher_data==null:
		return
# Adds teachers in class creation tab
	EditTeacherSelectable.clear()
	for i in range(0,Global.all_teacher_data.documents.size()):
		var teacher_info =Global.all_teacher_data.documents[i].fields
		EditTeacherSelectable.add_item(teacher_info.name.stringValue,true)

func set_class_data(data : Dictionary):
	sn = sn+1
	var new_item = template.instance()
	new_item.set_name("item" + str(sn))
	table.add_child(new_item)
	new_item.connect("class_button",self,"on_item_button_pressed")
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Id").text = data.id.stringValue
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Name").text=data.name.stringValue
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Tag").text=data.tag.stringValue
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table/"+new_item.name+"/Teacher").text=data.teacher.stringValue
	
func _on_WarningYes_pressed():
	get_node("WarningDialog").hide()
	NotificationLabel.text=("(1/1) Deleting class data..")
	var path = "class/"+Firebase.user_info.id+"/classes/%s" %LabelId.text
	Firebase.delete_document(path,get_node("HTTPRequest5"))

func _on_Refresh_pressed():
	sn=0
	textbox.show()
	var node = get_node("VBoxContainer/PanelContainer2/ScrollContainer/Table")
	for n in node.get_children():
		if n.name !="Label":
			node.remove_child(n)
			n.queue_free()
	_ready()

func _on_Button2_pressed():
	var class_info = {
	"id":{"stringValue":EditId.text},
	"name":{"stringValue":EditName.text},
	"tag" : {"stringValue":EditTag.text},
	"teacher":{"stringValue":Global.all_teacher_data.documents[EditTeacherSelectable.selected].fields.name.stringValue},
	"teacherid":{"stringValue":Global.all_teacher_data.documents[EditTeacherSelectable.selected].fields.email.stringValue},
	"discription":{"stringValue":EditDiscription.text}
	}
	local_teacher_data=Global.all_teacher_data.documents[EditTeacherSelectable.selected]
	#adds class details into teacher
	if "values" in local_teacher_data.fields.cls_id.arrayValue:
		var is_not_present = true
		#checks if new class added is already presented in teacher
		print(local_teacher_data.fields.cls_id.arrayValue)
		for i in range (0,local_teacher_data.fields.cls_id.arrayValue.values.size()):
			if local_teacher_data.fields.cls_id.arrayValue.values[i].hash()=={"stringValue":EditId.text}.hash():
				is_not_present = false
				break
		if is_not_present:
			local_teacher_data.fields.cls_id.arrayValue.values.push_back({"stringValue":EditId.text})
			local_teacher_data.fields.cls_name.arrayValue.values.push_back({"stringValue":EditName.text})
	else:
		local_teacher_data.fields["cls_id"]={"arrayValue":{"values":[{"stringValue":EditId.text}]}}
		local_teacher_data.fields["cls_name"]={"arrayValue":{"values":[{"stringValue":EditName.text}]}}
	#----------------------------------------------------------------------
	if save_button_state=="new":
		NotificationLabel.text="(1/2) Creating class.."
		var http = get_node("HTTPRequest2")
		var path = "class/"+Firebase.user_info.id+"/classes/?documentId=%s" %EditId.text
		Firebase.save_document(path,class_info,http)
	#----------------------------------------------------------------------
	elif save_button_state=="view":
		#Save button will act as delete if mode is "view"
		get_node("WarningDialog").popup()
	#----------------------------------------------------------------------
	elif save_button_state=="edit":
		NotificationLabel.text="(1/2) Updating class.."
		var path = "class/"+Firebase.user_info.id+"/classes/%s" %EditId.text
		Firebase.update_document(path,class_info,get_node("HTTPRequest3"))
	#----------------------------------------------------------------------
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code==0:
		textbox.set_text("CAN NOT CONNECT TO THE SERVER.")
		return
	
	if response_code==404:
		textbox.text = "Wow! Such a empty place."
		return
	var response_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code!=200:
		textbox.text = response_body.error.message.capitalize()
		yield(get_tree().create_timer(2.0),"timeout")
		textbox.text="End"
		return
	textbox.text=""
	textbox.visible = false
	if response_body.has("documents"):
		Global.all_class_data = response_body
		for i in range(0,response_body.documents.size()):
			class_info =response_body.documents[i].fields
			set_class_data(class_info)

func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	if response_code==200:
		NotificationLabel.text="(2/2) Updating teacher...."
		var teacher_id = local_teacher_data.name.split("/",true,0)[-1]
		var path = "teacher/"+Firebase.user_info.id+"/teachers/%s" %teacher_id
		Firebase.update_document(path,local_teacher_data.fields,get_node("HTTPRequest4"))
	else:
		NotificationLabel.text="G0t error."
		yield(get_tree().create_timer(2),"timeout")
		NotificationLabel.text=""

func _on_HTTPRequest3_request_completed(result, response_code, headers, body):
	var response_body:=JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code!= 200:
		NotificationLabel.text = response_body.result.error.message
		yield(get_tree().create_timer(2.0),"timeout")
		textbox.text=""
	else:
		NotificationLabel.text="(2/2) Updating teacher...."
		var teacher_id = local_teacher_data.name.split("/",true,0)[-1]
		var path = "teacher/"+Firebase.user_info.id+"/teachers/%s" %teacher_id
		Firebase.update_document(path,local_teacher_data.fields,get_node("HTTPRequest4"))
		
func _on_HTTPRequest4_request_completed(result, response_code, headers, body):
	var response_body:=JSON.parse(body.get_string_from_ascii()).result as Dictionary
#	print(response_body)
	if response_code!= 200:
		textbox.text="Updating data failed. Retry again. "
		yield(get_tree().create_timer(5.0),"timeout")
		textbox.text=""
	else:
		NotificationLabel.text=("Sucessfull.")
		_on_Refresh_pressed()
		yield(get_tree().create_timer(2.0),"timeout")
		NotificationLabel.text=("")
		yield(get_tree().create_timer(1.0),"timeout")
		get_node("EditDialog").hide()
		

func _on_HTTPRequest5_request_completed(result, response_code, headers, body):
	if response_code==200:
		NotificationLabel.text=("Sucessfull.")
		_on_Refresh_pressed()
		yield(get_tree().create_timer(2.0),"timeout")
		NotificationLabel.text=""
		yield(get_tree().create_timer(1.0),"timeout")
		get_node("EditDialog").hide()
		NotificationLabel.text=""

func _on_Button_pressed():
	get_node("EditDialog").hide()
