
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
    | Cell cell2 ->
      (* let q_cell, q_cell2 = determine_quadrant xq yq cell.x cell.y, determine_quadrant xq yq cell2.x cell2.y *) 
      (* in *)
      (* if q_cell <> q_cell2 then *) 
        (* let x_new = ((if q_cell2 = RightUp || q_cell2 = RightDown then (+.) else (-.)) xqt (size/.2.0/.2.0**(float_of_int level))) *)
        (* in *)
        (* let y_new =  ((if q_cell2 = LeftUp || q_cell2 = LeftDown then (+.) else (-.)) yqt (size/.2.0/.2.0**(float_of_int level))) *) 
        (* in *)
        aux xqt yqt (aux xqt yqt (Node {x=xqt; y=yqt; ru=Empty; lu=Empty; ld=Empty; rd=Empty}) level cell2) level cell
      (* else *)
        (* aux x_new y_new (Node{x=x_new; y=y_new; ru=Empty; lu=Empty; ld=Empty; rd=Empty}) (level+1) *)
      (* else if q_cell = RightUp then aux Node{x;y } hier eine cell ablegen im richtigen und auf diesen subpart wieder insertion machen) *)
  in
  aux (size/.2.0) (size/.2.0) qt 1 cell




let rec draw_quadtree qt scaling = 
  Graphics.open_graph " 800x600";
  match qt with
  | Empty -> ()
  | Cell c -> Graphics.fill_circle (int_of_float (c.x*.scaling) ) (int_of_float (c.y*.scaling) ) 10;
  ignore (Graphics.read_key ())


let () = draw_quadtree (Cell{x=0.5;y=0.5; content=" "}) 600.0
