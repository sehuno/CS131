let my_subset_test0 = subset [] [1]
let my_subset_test1 = subset [4;1;4;4] [1;2;3;4]

let my_equal_sets_test0 = equal_sets [3;5] [5;5;5;3]
let my_equal_sets_test1 = not (equal_sets [1;3;4;6] [3;1;3;4])

let my_set_union_test0 = equal_sets (set_union [4;5] [1;2;3]) [1;2;3;4;5]
let my_set_union_test1 = equal_sets (set_union [0;3] [2;3]) [0;2;3]

let my_set_intersection_test0 =
  equal_sets (set_intersection [] [3;2]) []
let my_set_intersection_test1 =
  equal_sets (set_intersection [3;1;3;6] [1;2;3;5;6]) [1;3;6]

let my_set_diff_test0 = equal_sets (set_diff [1;3;4] [1;4;3;1;5]) []
let my_set_diff_test1 = equal_sets (set_diff [4;3;1;1;3;5;6] [1;3]) [4;5;6]

let my_computed_fixed_point_test0 = 
  computed_fixed_point (=) (fun x -> x**2.0 -. 3.0 *. x +. 4.0) 1.0 = 2.0;;

let my_computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x / 4) 0 (-1) = -1

let my_while_away_test0 = 
  while_away ((+) 3) ((>) 10) 0 = [0; 3; 6; 9]
let my_while_away_test1 = 
  while_away ((+) 2) ((>) 14) 0 = [0; 2; 4; 6; 8; 10; 12]
let my_while_away_test2 = 
  while_away ((-) 3) ((<) 0) 10 = [10]

let my_rle_decode_test0 = 
  rle_decode [(2,0); (1,6)] = [0; 0; 6]
let my_rle_decode_test1 = 
  rle_decode [(5,"s");(6,"a")] = ["s"; "s"; "s"; "s"; "s"; "a"; "a"; "a"; "a"; "a"; "a"]

type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num

let my_test_rules = 
  [Expr, [N Num; N Binop; N Num];
   Expr, [N Lvalue];
   Lvalue, [N Expr; N Lvalue];
   Binop, [T "+"];
   Binop, [T "-"];
   Num, [T "0"];
   Num, [T "1"]]

let my_test_grammar = Expr, my_test_rules

let my_filter_blind_alleys_test0 =
	filter_blind_alleys my_test_grammar =
	(Expr,
 		[(Expr, [N Num; N Binop; N Num]); (Binop, [T "+"]); (Binop, [T "-"]);
 		 (Num, [T "0"]); (Num, [T "1"])])