(* ************************************************************************** *)
(* Project: Ocsigen Quick Howto : Parameters                                  *)
(* Description: Example of services with parameters                           *)
(* Author: db0 (db0company@gmail.com, http://db0.fr/)                         *)
(* Latest Version is on GitHub: http://goo.gl/sfvvq                           *)
(* ************************************************************************** *)

open Eliom_content
open Html5.D
open Eliom_parameter

(* ************************************************************************** *)
(* Application                                                                *)
(* ************************************************************************** *)

module Example =
  Eliom_registration.App
    (struct
      let application_name = "example"
     end)

(* ************************************************************************** *)
(* Page Skeletton                                                             *)
(* ************************************************************************** *)

let skeletton body_content =
  let css_uri =
    Xml.uri_of_string
      "http://twitter.github.com/bootstrap/assets/css/bootstrap.css" in
  Lwt.return
    (html
       (head (title (pcdata "Ocsigen Services Example"))
	  [css_link ~uri:css_uri ()])
       (body [div ~a:[a_class ["well"]] body_content]))

(* ************************************************************************** *)
(* Services accessible at a specific Url a/b/c                                *)
(* ************************************************************************** *)

(* Service declaration                                                        *)
let abc_service =
  Eliom_service.service
    ~path:["a"; "b"; "c"]
    ~get_params:unit
    ()

(* Service definition                                                         *)
let _ =
  Example.register ~service:abc_service
    (fun () () ->
      skeletton [p [pcdata "A, B, C..."]])

(* Link to this service                                                       *)
let abc_service_link =
  a abc_service [pcdata "Service with a url"] ()

(* ************************************************************************** *)
(* Service with two get parameters                                            *)
(* ************************************************************************** *)

(* Service declaration                                                        *)
let you_service =
  Eliom_service.service
    ~path:["you"]
    ~get_params:(string "name" ** int "age")
    ()

(* Service definition                                                         *)
let _ =
  Example.register ~service:you_service
    (fun (name, age) () ->
      skeletton
	[p [pcdata ("You are " ^ name ^ ".")];
	 p [pcdata ("You are " ^ (string_of_int age) ^ " years old.")];
	 p [pcdata "Nice to meet you!"]])

(* Link to this service                                                       *)
let you_service_link =
  a you_service [pcdata "Service with two get parameters"]
    ("db0", 18)


(* ************************************************************************** *)
(* Service with a parameter in the Url path                                   *)
(* ************************************************************************** *)

(* Service declaration                                                        *)
let user_service =
  Eliom_service.service
    ~path:["user"]
    ~get_params:(suffix (string "username"))
    ()

(* Service definition                                                         *)
let _ =
  Example.register ~service:user_service
    (fun name () ->
      skeletton
	[p [pcdata ("This page is a special page for the user " ^ name)];
	 h3 [pcdata "Some other users pages:"];
	 ul
	   [li [a user_service [pcdata "korfuri's special page"] ("korfuri")];
	    li [a user_service [pcdata "db0's special page"] ("db0")];
	    li [a user_service [pcdata "thomas's special page"] ("thomas")];
	    li [a user_service [pcdata "nicolas's special page"] ("nicolas")];
	   ]])

(* Link to this service                                                       *)
let user_service_link =
  a user_service [pcdata "Service with a parameter in url"]
    ("korfuri")

(* ************************************************************************** *)
(* Service with multiple parameters                                           *)
(* ************************************************************************** *)

(* Service declaration                                                        *)
let multiple_service =
  Eliom_service.service
    ~path:["multiple"]
    ~get_params:(string "a_string"
		 ** int "an_int"
		 ** int32 "an_int32"
		 ** float "a_float"
		 ** bool "a_bool"
		 ** opt (string "an_optional_string"))
    ()

(* Service definition                                                         *)
let _ =
  Example.register ~service:multiple_service
    (fun (the_string, (the_int, (the_int32, (the_float,
          (the_bool, (the_optional_string)))))) () ->
      skeletton
	[ul
	    [li [pcdata ("The string: " ^ the_string)];
	     li [pcdata ("The int: " ^ (string_of_int the_int))];
	     li [pcdata ("The int32: " ^ (Int32.to_string the_int32))];
	     li [pcdata ("The float: " ^ (string_of_float the_float))];
	     li [pcdata ("The bool: " ^ (string_of_bool the_bool))];
	     li [pcdata ("The optional string: " ^
			    (match the_optional_string with
			      | Some str -> str
			      | None -> "not provided"))];
	    ]])


(* Link to this service                                                       *)
let multiple_service_link =
  a multiple_service [pcdata "Service with multiple parameters"]
    ("towel",
     (42,
      (Int32.of_int 64,
       (13.37,
	(true,
	 (Some "nyan"))))))

(* ************************************************************************** *)
(* Service which take any get parameter                                       *)
(* ************************************************************************** *)

(* Service declaration                                                        *)
let any_service =
  Eliom_service.service
    ~path:["any"]
    ~get_params:any
    ()

(* Service definition                                                         *)
let _ =
  Example.register ~service:any_service
    (fun list_of_params () ->
      skeletton
	[ul (List.map
	       (fun (key, value) ->
		 li [b [pcdata (key ^ ": ")];
		     pcdata value])
	       list_of_params)])

(* Link to this service                                                       *)
let any_service_link =
  a any_service [pcdata "Service with any parameter"]
    [("duck", "quack");
     ("cat", "meow");
     ("dog", "woof")]

(* ************************************************************************** *)
(* Service which take a list parameter                                        *)
(* ************************************************************************** *)

(* Service declaration                                                        *)
let list_service =
  Eliom_service.service
    ~path:["list"]
    ~get_params:(set string "a_list")
    ()

(* Service definition                                                         *)
let _ =
  Example.register ~service:list_service
    (fun the_list () ->
      skeletton
	[ul (List.map (fun elem -> li [pcdata elem]) the_list)]
    )

(* Link to this service                                                       *)
let list_service_link =
  a list_service [pcdata "Service with a list"]
    ["ananas"; "kiwi"; "banana"; "apple"]

(* ************************************************************************** *)
(* Service with your own type                                                 *)
(* ************************************************************************** *)

(* Example of type of your own                                                *)

module type PROFILE =
sig
  type t
  val create : string -> string -> int -> t
  val firstname : t -> string
  val lastname : t -> string
  val age : t -> int
  val to_string : t -> string
  val of_string : string -> t
end

module Profile : PROFILE =
struct
  type t = (string * string * int)

  let create f l a = (f, l, a)

  let firstname (f, _, _) = f
  let lastname (_, l, _) = l
  let age (_, _, a) = a

  let sep = "_"

  let of_string str =
    let l = Str.split (Str.regexp sep) str in
    (List.hd l, List.nth l 1, int_of_string (List.nth l 2))

  let to_string p =
    String.concat sep
      [firstname p;
       lastname p;
       string_of_int (age p)]
end

(* Service declaration                                                        *)
let my_type_service =
  Eliom_service.service
    ~path:["profile"]
    ~get_params:(user_type
		   ~of_string:Profile.of_string
		   ~to_string:Profile.to_string
		   "profile")
    ()

(* Service definition                                                         *)
let _ =
  Example.register ~service:my_type_service
    (fun the_profile () ->
      skeletton
	[p [pcdata "I can read in your profile: "];
	 ul
	   [li [pcdata ("Your first name is: " ^
			   (Profile.firstname the_profile))];
	    li [pcdata ("Your last name is: " ^
			   (Profile.lastname the_profile))];
	    li [pcdata ("You are " ^
			   (string_of_int (Profile.age the_profile)) ^
			   " years old.")];
	   ]])

(* Link to this service                                                       *)
let my_type_service_link =
  a my_type_service [pcdata "Service with your own type"]
    (Profile.create "Barbara" "Lepage" 18)

(* ************************************************************************** *)
(* Services with no parameter at all                                          *)
(* ************************************************************************** *)

(* Service declaration                                                        *)
let main_service =
  Eliom_service.service
    ~path:[]
    ~get_params:unit
    ()

(* Link to this service                                                       *)
let main_service_link =
  a main_service [pcdata "Service with no parameter"] ()

(* Service definition                                                         *)
let _ = 
  Example.register ~service:main_service
    (fun () () ->
      skeletton [h4 [pcdata "Welcome to my home page!"];
		 p [pcdata "Try some services on the following list :)"];
		 ul
		   [
                     li [abc_service_link];
                     li [you_service_link];
                     li [user_service_link];
                     li [multiple_service_link];
                     li [any_service_link];
                     li [list_service_link];
                     li [my_type_service_link];
                     li [main_service_link];
		   ]
		])

