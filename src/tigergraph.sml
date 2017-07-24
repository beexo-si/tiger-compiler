structure tigergraph :> tigergraph =
struct

open Dynarray
open tigerutils

(* Graph types and operations *)

type nodeId = int

type nodeInfo = {pred: nodeId list, succ: nodeId list}

type graph = nodeInfo array

type node = graph * nodeId (*como las operaciones no toman como argumento el grafo, el tipo nodo debe incluir a qué grafo pertenece *)

val fakeNode = {pred = [~1], succ = []}

fun isFake({pred=[~1], succ = []}) = true
|   isFake _ = false

val emptyNode = {pred = [], succ = []}


fun nodes(g:graph) =
	let fun aux i = if isFake(sub(g,i)) then [] else (g, i)::aux(i+1)	
	in aux 0
	end

fun succ(n:node) = map (fn id => (#1 n, id)) (#succ (sub(#1 n, #2 n)))

fun pred(n:node) = map (fn id => (#1 n, id)) (#pred (sub(#1 n, #2 n)))

fun adj(n:node) =
	let 
		val succid = #succ (sub(#1 n, #2 n)) 
		val predid = #pred (sub(#1 n, #2 n))
		val adjsid = elimRep (succid @ predid) (*elimino repetidos, pues un nodo puede ser succ y pred de otro al mismo tiempo*)
	in map (fn id => (#1 n, id)) adjsid
	end

(*vamos a necesitar esto?:
fun eqGraph g h = ....
fun eq ((g,n), (h,m)) = if eqGraph g h then n = m else false
podríamos agregar al tipo grafo un id para hacerlo simple
pero si eq sólo se usa para un mismo grafo, no hace falta*)
fun eq ((_,n), (_,m)) = n = m

fun cmp ((_,n), (_,m)) = Int.compare(n,m)

fun newGraph () = array(0, fakeNode)

fun newNode(g:graph) = (*agrego el nodo al final porque no hay una operación de destrucción de nodos en la interfaz*)
	let val _ = update(g, bound g, emptyNode)
	in (g, bound g -1)
	end

exception GraphEdge

fun mk_edge {from=n:node, to=m:node} =
	let val g = #1 n
		val i = #2 n
		val j = #2 m
	in update(g, i, {pred = #pred(sub(g,i)), succ = j::(#succ(sub(g,i)))});
	   update(g, j, {pred = i::(#pred(sub(g,j))), succ = #succ(sub(g,j))})
	end

fun rm_edge {from=n:node, to=m:node} =
	let val g = #1 n
		val i = #2 n
		val j = #2 m
	in update(g, i, {pred = #pred(sub(g,i)), succ = remove j (#succ(sub(g,i)))});
	   update(g, j, {pred = remove i (#pred(sub(g,j))), succ = #succ(sub(g,j))})
	end
	
(* Tables *)

type 'a table = (node, 'a) Splaymap.dict

end

