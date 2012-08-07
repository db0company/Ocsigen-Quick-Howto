(* ************************************************************************** *)
(* Project: Ocsigen Quick Howto : CSS                                         *)
(* Description: Example of a page with CSS stylesheet                         *)
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

let page_title () =
  h1 [pcdata "Ocsigen CSS Example"]

let page_menu () =
  ul ~a:[a_class ["menu"]]
    [li [a (~service:main) [pcdata "Lorem ipsum"] ()];
     li [a (~service:main) [pcdata "Dolor sit amet"] ()];
     li [a (~service:main) [pcdata "Consectetur"] ()];
     li [a (~service:main) [pcdata "Adipiscing elit"] ()];
     li [a (~service:main) [pcdata "Vivamus"] ()];
     li [a (~service:main) [pcdata "Congue ligula"] ()];
     li [a (~service:main) [pcdata "In velit aliquam"] ()];
     li [a (~service:main) [pcdata "Et dignissim"] ()];
     li [a (~service:main) [pcdata "Erat congue"] ()]
    ]

let page_content () =
  div
    [h3 [pcdata "Ut elit ante, pulvinar sed"];
     p [pcdata "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at risus at purus pellentesque tincidunt. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tincidunt elementum odio id pellentesque. Etiam pretium ipsum in turpis egestas in consectetur tortor porttitor. Aliquam ac vestibulum lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent vitae odio odio. Nulla auctor velit vitae odio aliquam consectetur. Curabitur est quam, sodales id sagittis non, malesuada et eros. Aenean fermentum faucibus dui nec ornare. Integer non odio ac libero tempor porttitor. Nulla facilisi. Phasellus tincidunt pretium fermentum. Nullam quis leo quis dolor lacinia sollicitudin vel facilisis lectus. Nam sem magna, porttitor sit amet adipiscing nec, luctus nec lectus."];
     h3 [pcdata "Sed porttitor sagittis etiam"];
     p [pcdata "Donec sit amet nunc vitae magna congue porta. Praesent convallis augue at est pharetra vel consectetur enim interdum. Cras erat dui, commodo quis malesuada sed, mattis at ante. Donec aliquet, velit dignissim porta volutpat, ligula orci vestibulum mauris, in egestas nibh lectus nec eros. Fusce vitae dolor magna, porttitor mattis est. Integer libero tortor, ultrices sit amet vehicula at, accumsan sit amet neque. Fusce nec diam quis urna faucibus aliquam quis scelerisque magna."]
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
           (body [page_title ();
		  page_menu ();
		  div ~a:[a_class ["page"]]
		  [page_content ()]
		 ])
	)
    )
