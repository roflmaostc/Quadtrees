type 'a cell = {x:float; y:float; content: 'a}


type 'a quadtree = Empty | Cell of ('a cell) | Node of {x: float; y:float; ru: 'a quadtree; lu: 'a quadtree; ld: 'a quadtree; rd: 'a quadtree}

type quadrant = RightUp | LeftUp | LeftDown | RightDown

let determine_quadrant xq yq x y = 
  if x >= xq && y >= yq then RightUp
  else if x < xq && y >= yq then LeftUp
  else if x < xq && y < yq then LeftDown
  else RightDown


let insert cell qt size = 
  let rec aux xqt yqt qt level = match qt with 
    | Empty -> Cell (cell)
    | Node {x; y; ru; lu; ld; rd} -> 
      let aux2 opx opy dir = aux (opx xqt (size/.2.0/.2.0**(float_of_int level)) ) (opy yqt (size/.2.0/.2.0**(float_of_int level) ) ) dir (level+1) 
      in
      Node{x; y; 
           ru = (if determine_quadrant x y cell.x cell.y = RightUp   then aux2 (+.) (+.) ru else ru);
           lu = (if determine_quadrant x y cell.x cell.y = LeftUp    then aux2 (-.) (+.) lu else lu);
           ld = (if determine_quadrant x y cell.x cell.y = LeftDown  then aux2 (-.) (-.) ld else ld);
           rd = (if determine_quadrant x y cell.x cell.y = RightDown then aux2 (+.) (-.) rd else rd);}
    | Cell cell2 -> 
      let q_cell, q_cell2 = determine_quadrant xq yq cell.x cell.y, determine_quadrant xq yq cell2.x cell2.y 
  in
  aux (size/.2.0) (size/.2.0) qt 1

