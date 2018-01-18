This is a visualization of the [Quadtree](https://en.wikipedia.org/wiki/Quadtree) using [OCaml](https://ocaml.org/).

To compile this visualization use:

```bash
ocamlbuild -package graphics -package unix quadtree.native
```
As you can see we use the [Graphics package](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Graphics.html) for visualization. 
*unix* is used for delay.

Execution of the command can be done with:
```bash
./quadtree.native [number_of_points] [optional delay in seconds]
```
Example:
```bash
./quadtree.native 30
```
will draw a quadtree with 30 points.
```bash
./quadtree.native 30 0.1
```
will draw slowly a quadtree with 30 points. Nice for visualization.

With the key **r** you can randomly generate a new quadtree. Using **x** you can close the window
