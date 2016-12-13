type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec convert rules nt =
	match rules with
	|(l,r)::tail -> 
		if (l = nt)
		then r::(convert tail nt)
		else convert tail nt
	| [] -> []

let convert_grammar gram = 
	(fst gram, convert (snd gram))

let rec get_derivation sym rules gf deriv acc frag = 
	match rules with
	| [] -> None
	| h::t -> 
		match test_rule gf h acc (deriv@[(sym, h)]) frag with
	    | None -> get_derivation sym t gf deriv acc frag
        | d -> d
and test_rule gf rule acc deriv frag =
	match rule with
	| [] -> acc deriv frag
	| symbol::tail -> 
		match symbol with
		|N nt -> get_derivation nt (gf nt) gf deriv (test_rule gf tail acc) frag
		|T tm -> 
			match frag with
			|[] -> None
			|h::t -> 
				if h = tm
				then test_rule gf tail acc deriv t
				else None		

let parse_prefix gram acc frag = 
	get_derivation (fst gram) ((snd gram)(fst gram)) (snd gram) [] acc frag;; 
