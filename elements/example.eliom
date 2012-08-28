(* ************************************************************************** *)
(* Project: Ocsigen Quick Howto : Elements                                    *)
(* Description: Example of a page with a bunch of elements                    *)
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
(* Parts of the page                                                          *)
(* ************************************************************************** *)

(* ************************************************************************** *)
(* DIV                                                                        *)
(* ************************************************************************** *)

let simple_div_example () =
  div [pcdata "div content"]

let div_with_attributes_example () =
  div ~a:[a_class ["red";"shadow"];
	  a_id "the_div";
	  a_onclick {{ Dom_html.window##alert(Js.string "hello") }}]
    [pcdata "I'm a div with two classes to describe me (red and shadow), ";
     pcdata "an id to make me unique and an action when you click me."]
  
(* ************************************************************************** *)
(* LIST                                                                       *)
(* ************************************************************************** *)

let simple_list_example () =
  ul
    [li [pcdata "first item"];
     li [pcdata "second item"];
     li [pcdata "third item"];
     li [pcdata "fourth item"]
    ]

let ordered_list_example () =
  let list = ["banana"; "apple"; "kiwi"; "blueberry"; "orange"; "cherry"] in
  let sort_list = List.sort String.compare list in
  ol (List.map (fun fruit -> li [pcdata fruit]) sort_list)

let definition_list_example () =
  dl
    [((dt [pcdata "Banana"], []),
      (dd [pcdata "An elongated curved fruit"], []));
     ((dt [pcdata "Orange"], []),
      (dd [pcdata "A globose, reddish-yellow, edible fruit"],
       [dd [pcdata "A color between yellow and red"]]));
     ((dt [pcdata "Kiwi"], []),
      (dd [pcdata "Egg-sized green fruit from China"], []))]

(* ************************************************************************** *)
(* IMAGE                                                                      *)
(* ************************************************************************** *)

let internal_image () =
  img ~alt:("Ocsigen Logo")
      ~src:(make_uri
	      ~service:(Eliom_service.static_dir ())
	      ["ocsigen_logo.png"])
    ()

let external_image () =
  img ~alt:("Ocsigen Logo")
      ~src:(Xml.uri_of_string ("http://ocsigen.org/resources/logos/text_ocsigen_with_shadow.png"))
    ()

(* ************************************************************************** *)
(* Titles and paragraphs                                                      *)
(* ************************************************************************** *)

let titles_and_paragraphs () =
  div ~a:[a_class ["well"]]
    [
      h1 [pcdata "Title of the page"];
      h2 [pcdata "Subtitle: a short description of the page"];
      h3 [pcdata "Chapter 1"];
      h4 [pcdata "Section 1"];
      p [pcdata "Some text, semper nec lacinia vel, ultricies eu nulla. Proin lacinia justo nec sem sagittis a tincidunt est blandit. Aliquam tincidunt vulputate sapien, quis semper ligula pellentesque a."];
      h4 [pcdata "Section 2"];
      h5 [pcdata "Subsection 1"];
      p [pcdata "Some text, Duis sollicitudin, felis vitae dapibus lobortis. Donec placerat, sapien vel fringilla volutpat, purus nibh dignissim elit, non volutpat elit felis sit amet nulla. Proin eget eros odio, non pretium ante."];
      h6 [pcdata "Something you should reed"];
      p [pcdata "Some text. Duis lectus enim, viverra a aliquet sed, aliquet sit amet lectus."];
      h5 [pcdata "Subsection 2"];
      p [pcdata "Sed ac enim vel metus placerat bibendum. Fusce ligula est, laoreet et vestibulum quis, semper sit amet felis. Vestibulum orci nisl, mattis a lobortis id, tincidunt id nisi. Sed scelerisque metus vitae tellus molestie placerat. Aenean nisl ligula, malesuada eu pellentesque eget, ultricies sed elit. Sed eu ligula ligula. Vivamus eu diam quis orci venenatis viverra ac ut orci. Suspendisse a consectetur enim. Cras at dolor a tellus egestas posuere. Nunc sit amet lorem velit. Nunc nec turpis massa, vel tempus lorem. Vivamus at dolor ut tellus accumsan rhoncus."];
      h3 [pcdata "Chapter 2"];
      p [pcdata "Proin eget eros odio, non pretium ante."]
    ]

(* ************************************************************************** *)
(* Service definition                                                         *)
(* ************************************************************************** *)

let _ = 
  Example.register ~service:main
    (fun () () ->
      Lwt.return
        (html
	   (head
	      (title (pcdata "Ocsigen CSS Example"))
	      [css_link ~uri:(make_uri (Eliom_service.static_dir ())
				["style.css"]) ()])
           (body [div ~a:[a_id "main"]
		     [
		       h3 [pcdata "Examples of div"];
		       simple_div_example ();
		       div_with_attributes_example ();

		       h3 [pcdata "Examples of list"];
		       simple_list_example ();
		       ordered_list_example ();
		       definition_list_example ();

		       h3 [pcdata "Examples of image"];
		       internal_image ();
		       external_image ();

		       h3 [pcdata "Examples of titles and paragraphs"];
		       titles_and_paragraphs ();
		     ]
		 ]
	   )
	)
    )
    
