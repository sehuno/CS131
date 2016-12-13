let rec contains a b = 
	match b with 
	[] -> false
	| h::t -> if a = h then true else contains a t

let rec subset a b =
	match a with 
	[] -> true
	| h::t -> if contains h b then subset t b else false

let equal_sets a b = (subset a b) && (subset b a)

let rec set_union a b = 
	match a with 
	[] -> b
	| h::t -> if contains h b then set_union t b else h::(set_union t b)

let rec set_intersection a b =
	match a with
	[] -> []
	| h::t -> if contains h b then h::(set_intersection t b) else (set_intersection t b)

let rec set_diff a b = 
	match a with
	[] -> []
	| h::t -> if not (contains h b) then h::(set_diff t b) else set_diff t b

let rec computed_fixed_point eq f x = if eq (f x) x then x else computed_fixed_point eq f (f x)

let rec compute_periodic_helper f p x = 
	match p with
	0 -> x
	| _ -> compute_periodic_helper f (p-1) (f x) 

let rec computed_periodic_point eq f p x =
	if eq (compute_periodic_helper f p x) x then x else computed_periodic_point eq f p (f x)

let rec while_away s p x =
	match p x with
	false -> []
	| _ -> x::(while_away s p (s x))

let rec rle_decode_helper lpe =
	match lpe with 
	(0,_) -> []
	| (n,x) -> x::(rle_decode_helper (n-1,x))

let rec rle_decode lp = 
	match lp with
	[] -> [] 
	| h::t -> (rle_decode_helper h)@(rle_decode t)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

(* checks if all symbols in list is terminal *)
let rec all_terminal_symbols tl =
	match tl with
	[] -> true
	| h::t -> match h with
			  T _ -> all_terminal_symbols t
			  | N _ -> false 

(* returns a symbol list consisting of only terminal symbols *)
let rec terminal_symbols gl sl =
	match gl with
	[] -> sl 
	| (lhs,rhs)::tail -> match all_terminal_symbols rhs with
						 true -> terminal_symbols tail sl@[lhs]
						 | false -> terminal_symbols tail sl

(* checks if symbol is in symbol list *)
let rec in_symbol_list gl sl = 
	match gl with
	[] -> true
	| h::t -> match h with
			  N x -> if contains x sl then in_symbol_list t sl else false
			| T _ -> in_symbol_list t sl

(* adds additional tokens that are become terminal based off of other terminal symbols *)
let rec nonterminal_symbols gl sl =
	match gl with
	[] -> sl
	| (lhs,rhs)::tail -> if in_symbol_list rhs sl && not (contains lhs sl) then nonterminal_symbols tail sl@[lhs]
						 else nonterminal_symbols tail sl

(* a computed_fixed_point function for nonterminal_symbols *)
let rec nonterminal_symbols_cf eq gl sl = 
	if eq (nonterminal_symbols gl sl) sl then sl
	else nonterminal_symbols_cf eq gl (nonterminal_symbols gl sl)

(* returns a list of rules containing all tokens that become terminal *)
let rec fba_rules g =
	match g with
	(lhs, rhs) -> nonterminal_symbols_cf (=) rhs (terminal_symbols rhs [])


let rec fba_out_grammar_list gl rules = 
	match gl with
	[] -> []
	| h::t -> match h with
			  (lhs,rhs) -> if in_symbol_list rhs rules then h::(fba_out_grammar_list t rules)
			  				else fba_out_grammar_list t rules

let filter_blind_alleys g =
	match g with
	(lhs, rhs) -> (lhs, fba_out_grammar_list rhs (fba_rules g))