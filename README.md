This is a visualization of the [Quadtree](https://en.wikipedia.org/wiki/Quadtree) using [OCaml](https://ocaml.org/).

To compile this visualization use:

```bash
ocamlbuild -package graphics quadtree.native
```
As you can see we use the [Graphics package](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Graphics.html#VALdraw_circle) for visualization.

Execution of the command can be done with:
```bash
./quadtree.native <number_of_points>
```

Then a graphics window will open. With the key **r** you can randomly generate a new quadtree. Using **x** you can close the window
