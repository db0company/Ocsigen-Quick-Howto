(* ************************************************************************** *)
(* Project: Ocsigen Quick Howto : Javascript Inclusion                        *)
(* Description: Example of a page including external javascript script        *)
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
(* Service declaration                                                        *)
(* ************************************************************************** *)

let main =
  Eliom_service.service
    ~path:[]
    ~get_params:unit
    ()

(* ************************************************************************** *)
(* Service definition                                                         *)
(* ************************************************************************** *)

let _ =

  Example.register
    ~service:main
    (fun () () ->
      let clickable_div =
	div ~a:[a_onclick {{ Js.Unsafe.eval_string "hello_function()" }}]
	  [pcdata "Click me!"] in
      Lwt.return
	(html
	   (head (title (pcdata "Hello World of Ocsigen"))
	      [js_script ~uri:(make_uri (Eliom_service.static_dir ())
				 ["hello.js"]) ()])
	   (body [clickable_div])))
