(* ************************************************************************** *)
(* Project: Ocsigen Quick Howto : Javascript Form                             *)
(* Description: Example of js action when a form is submitted.                *)
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
(* Js                                                                         *)
(* ************************************************************************** *)

{client{

let dummy_js () =
  Dom_html.window##alert(Js.string "Thanks for checking this dummy box!")

}}
  
(* ************************************************************************** *)
(* Form                                                                       *)
(* ************************************************************************** *)

(* Declaration of the form                                                    *)
let dummy_form =
  Eliom_service.post_service
    ~fallback:main
    ~post_params:(bool "dummy_checkbox")
    ()

(* Registration of the action that will occur when the form is submitted      *)
let _ =
  Eliom_registration.Action.register
    ~service:dummy_form
    (fun () ->
      (fun check ->
        Lwt.return
          (if check
           then Eliom_service.onload {{ dummy_js () }})))

(* HTML5 form element                                                         *)
let display_form () =
  post_form ~service:dummy_form
    (fun check ->
      [bool_checkbox ~name:check ();
       string_input ~input_type:`Submit
         ~value:"OK" ()]) ()

(* ************************************************************************** *)
(* Service definition                                                         *)
(* ************************************************************************** *)

let _ =
  Example.register
    ~service:main
    (fun () () ->
      Lwt.return
        (html
           (head (title (pcdata "Call js after form")) [])
           (body [div [display_form ()]])))
