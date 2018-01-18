
type 'a cell = {x:float; y:float; content: 'a}

type 'a quadtree = Empty | Cell of ('a cell) | Node of {x: float; y:float; ru: 'a quadtree; lu: 'a quadtree; ld: 'a quadtree; rd: 'a quadtree}

type quadrant = RightUp | LeftUp | LeftDown | RightDown

let determine_quadrant xq yq x y = 
  if x >= xq && y >= yq then RightUp
  else if x < xq && y >= yq then LeftUp
  else if x < xq && y < yq then LeftDown
  else RightDown


let rec insert cell qt size = 
  let rec aux xqt yqt qt level cell = 
    let aux2 opx opy dir = aux (opx xqt (size/.2.0/.2.0**(float_of_int level)) ) (opy yqt (size/.2.0/.2.0**(float_of_int level) ) ) dir (level+1) cell 
    in
    match qt with 
    | Empty -> Cell (cell)
    | Node {x; y; ru; lu; ld; rd} -> 
      Node{x; y; 
           ru = (if determine_quadrant x y cell.x cell.y = RightUp   then aux2 (+.) (+.) ru else ru);
           lu = (if determine_quadrant x y cell.x cell.y = LeftUp    then aux2 (-.) (+.) lu else lu);
           ld = (if determine_quadrant x y cell.x cell.y = LeftDown  then aux2 (-.) (-.) ld else ld);
           rd = (if determine_quadrant x y cell.x cell.y = RightDown then aux2 (+.) (-.) rd else rd);}
    | Cell cell2 -> aux xqt yqt (aux xqt yqt (Node {x=xqt; y=yqt; ru=Empty; lu=Empty; ld=Empty; rd=Empty}) level cell2) level cell
  in
  aux (size/.2.0) (size/.2.0) qt 1 cell


let generate_random_tree number_of_points = 
  let () = Random.self_init ()
  in
  let size = 1.0
  in
  let rec aux counter qt = 
    if counter< number_of_points 
    then aux (counter+1 ) (insert ({x=Random.float 1.0;y=Random.float 1.0; content=" "}) qt size)
    else qt
  in
  aux 0 Empty


let rec draw_quadtree qt x_size y_size scaling offset = 
  let offset, scaling= float_of_int offset, float_of_int scaling
  in
  let open Graphics in
  Graphics.open_graph (" "^(string_of_int x_size)^"x"^(string_of_int y_size));
  let radius = 2
  in
  let rec aux qt level =  
    match qt with
    | Empty -> ()
    | Cell c -> set_color red; fill_circle (int_of_float (offset+.c.x*.scaling) ) (int_of_float (offset+.c.y*.scaling) ) radius; set_color black;
    | Node n -> 
      draw_rect (int_of_float (offset+.(n.x-.1.0/.2.0**level)*.scaling)) (int_of_float (offset+.(n.y-.1.0/.2.0**level)*.scaling)) (int_of_float (scaling*.1.0/.2.0**level)) (int_of_float (scaling*.1.0/.2.0**level));
      draw_rect (int_of_float (offset+.(n.x)*.scaling)) (int_of_float (offset+.(n.y-.1.0/.2.0**level)*.scaling)) (int_of_float (scaling*.1.0/.2.0**level)) (int_of_float (scaling*.1.0/.2.0**level));
      draw_rect (int_of_float (offset+.(n.x)*.scaling)) (int_of_float (offset+.(n.y)*.scaling)) (int_of_float (scaling*.1.0/.2.0**level)) (int_of_float (scaling*.1.0/.2.0**level));
      draw_rect (int_of_float (offset+.(n.x-.1.0/.2.0**level)*.scaling)) (int_of_float (offset+.(n.y)*.scaling)) (int_of_float (scaling*.1.0/.2.0**level)) (int_of_float (scaling*.1.0/.2.0**level));
      aux n.ru (level+.1.0); aux n.lu (level+.1.0); aux n.ld (level+.1.0); aux n.rd (level+.1.0);         
  in
  let () = aux qt 1.0
  in
  let rec refresh x = 
    let c = read_key ()
    in
    if c = 'r' then let () = clear_graph () in aux (generate_random_tree 30) 1.0; refresh x
    else if c = 'x' then ()
    else refresh ()
  in
  refresh ()

let () = draw_quadtree (generate_random_tree 30) 500 500 400 30 
