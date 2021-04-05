extends Node
var FIRESTORE_URL
var LOGIN_URL
var REGISTER_URL
var user_info = {}

func _ready():
	var file_data=get_file_data("res://data_file.json")
	REGISTER_URL="https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="+ file_data.apikey
	LOGIN_URL="https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + file_data.apikey
	FIRESTORE_URL = "https://firestore.googleapis.com/v1/projects/"+file_data.projectid+"/databases/(default)/documents/" 
	
func get_file_data(path:String) -> Dictionary:
	var dict = {}
	var file = File.new()
	file.open(path, file.READ)
	dict = parse_json(file.get_as_text())
	file.close()
	return dict

func register(email:String, password:String, http: HTTPRequest) -> void:
	var body :={
		"email": email,
		"password": password,
	}
	http.request(REGISTER_URL,[], false, HTTPClient.METHOD_POST,to_json(body))

func _user_login(email : String, password : String,http:HTTPRequest,http2:HTTPRequest):
	var body = {
		"email" : email,
		"password" : password,
		"returnSecureToken" : true 
	}
	
	http.request(LOGIN_URL,[],false,HTTPClient.METHOD_POST,to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] ==200:
		user_info = _get_user_info(result)
		var path = FIRESTORE_URL+"user_type/%s"%user_info.id
		http2.request(path,_get_request_headers(),false,HTTPClient.METHOD_GET)
		var result2 := yield(http, "request_completed") as Array
		
func _get_user_info(result:Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {"token" : result_body.idToken,
			"id": result_body.localId}


func _get_request_headers() ->PoolStringArray:
	return PoolStringArray([
		"Content-type : application/json",
		"Authorization: Bearer %s"% user_info.token
	])

func get_document(path: String, http: HTTPRequest) -> void:
	var url= FIRESTORE_URL+path
	http.request(url,_get_request_headers(), false, HTTPClient.METHOD_GET)
	

func save_document(path:String, fields:Dictionary, http:HTTPRequest)-> void:
	var document := {"fields": fields}
	var body := to_json(document)
	var url= FIRESTORE_URL + path
	print(url)
	http.request(url,_get_request_headers(),false,HTTPClient.METHOD_POST, body)
	
func update_document(path : String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := {"fields": fields}
	var body := to_json(document)
	var url= FIRESTORE_URL + path
	http.request(url,_get_request_headers(),false,HTTPClient.METHOD_PATCH, body)
	
func delete_document(path: String, http: HTTPRequest) ->void:
	var url= FIRESTORE_URL + path
	http.request(url, _get_request_headers(),false,HTTPClient.METHOD_DELETE)
