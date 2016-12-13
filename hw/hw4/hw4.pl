signal_morse([],[]).  
signal_morse(L, R) :- 
	count(L, Z), 
	parse_pairs(Z, R).

parse_pairs([],[]).
parse_pairs([H|T], Z) :- s(Sym, H), Sym = [], parse_pairs(T, Z).
parse_pairs([H|T], [Sym|Z]) :- s(Sym, H), Sym \= [], parse_pairs(T, Z).

signal_message([],[]).
signal_message(L, F) :-
	signal_morse(L, PL), 
	tokenize_morse(PL, TL), 
	parse_tokens(TL, M),
	handle_errors(M, F).

tokenize_morse([],[[]]).
tokenize_morse([H|T], [[H]|[R|Z]]) :- s(H1,[0,3]), tokenize_morse(T, [[H1|R]|Z]),!.
tokenize_morse([H|T], [[H]|[[H1]|[R|Z]]]) :- s(H1,[0,7]), tokenize_morse(T, [[H1|R]|Z]),!.
tokenize_morse([H|T], [[H|L]|R]) :- tokenize_morse(T,[L|R]).

parse_tokens([],[]).
parse_tokens([[H]|T], [H|R]):- H ='#', parse_tokens(T,R).
parse_tokens([H|T],[M|R]) :- morse(M, H), parse_tokens(T,R).

handle_errors([],[]).
handle_errors([H1|T1], [H1|R]) :- handle_errors(T1, R), R = [].
handle_errors([H1|T1], [H1|[H2|T2]]) :- handle_errors(T1, [H2|T2]), H2 \= error.
handle_errors([H1|T1], [H2|T2]) :- handle_errors(T1, [H2|T2]), H1 \= '#', H2 = error.
handle_errors([H1|T1], [H1|T2]) :- handle_errors(T1, [H2|T2]), H1 = '#', H2 = error.

count([],[]).
count([X|T],[[X,C1]|R]) :- count(T,[[X,C]|R]), !, C1 is C+1.
count([X|T],[[X,1]|R]) :- count(T,R).

s([],[0,1]).
s([], [0,2]).
s(^, [0,2]).
s(^,[0,3]).
s(^,[0,4]).
s(^,[0,5]).
s(#,[0,X]) :- X>=5. 
s('.',[1,1]).
s(-,[1,2]).
s('.',[1,2]).
s(-,[1,X]) :- X>=3.

morse(a, [.,-]).           % A
morse(b, [-,.,.,.]).	   % B
morse(c, [-,.,-,.]).	   % C
morse(d, [-,.,.]).	   % D
morse(e, [.]).		   % E
morse('e''', [.,.,-,.,.]). % É (accented E)
morse(f, [.,.,-,.]).	   % F
morse(g, [-,-,.]).	   % G
morse(h, [.,.,.,.]).	   % H
morse(i, [.,.]).	   % I
morse(j, [.,-,-,-]).	   % J
morse(k, [-,.,-]).	   % K or invitation to transmit
morse(l, [.,-,.,.]).	   % L
morse(m, [-,-]).	   % M
morse(n, [-,.]).	   % N
morse(o, [-,-,-]).	   % O
morse(p, [.,-,-,.]).	   % P
morse(q, [-,-,.,-]).	   % Q
morse(r, [.,-,.]).	   % R
morse(s, [.,.,.]).	   % S
morse(t, [-]).	 	   % T
morse(u, [.,.,-]).	   % U
morse(v, [.,.,.,-]).	   % V
morse(w, [.,-,-]).	   % W
morse(x, [-,.,.,-]).	   % X or multiplication sign
morse(y, [-,.,-,-]).	   % Y
morse(z, [-,-,.,.]).	   % Z
morse(0, [-,-,-,-,-]).	   % 0
morse(1, [.,-,-,-,-]).	   % 1
morse(2, [.,.,-,-,-]).	   % 2
morse(3, [.,.,.,-,-]).	   % 3
morse(4, [.,.,.,.,-]).	   % 4
morse(5, [.,.,.,.,.]).	   % 5
morse(6, [-,.,.,.,.]).	   % 6
morse(7, [-,-,.,.,.]).	   % 7
morse(8, [-,-,-,.,.]).	   % 8
morse(9, [-,-,-,-,.]).	   % 9
morse(., [.,-,.,-,.,-]).   % . (period)
morse(',', [-,-,.,.,-,-]). % , (comma)
morse(:, [-,-,-,.,.,.]).   % : (colon or division sign)
morse(?, [.,.,-,-,.,.]).   % ? (question mark)
morse('''',[.,-,-,-,-,.]). % ' (apostrophe)
morse(-, [-,.,.,.,.,-]).   % - (hyphen or dash or subtraction sign)
morse(/, [-,.,.,-,.]).     % / (fraction bar or division sign)
morse('(', [-,.,-,-,.]).   % ( (left-hand bracket or parenthesis)
morse(')', [-,.,-,-,.,-]). % ) (right-hand bracket or parenthesis)
morse('"', [.,-,.,.,-,.]). % " (inverted commas or quotation marks)
morse(=, [-,.,.,.,-]).     % = (double hyphen)
morse(+, [.,-,.,-,.]).     % + (cross or addition sign)
morse(@, [.,-,-,.,-,.]).   % @ (commercial at)

% Error.
morse(error, [.,.,.,.,.,.,.,.]). % error - see below

% Prosigns.
morse(as, [.,-,.,.,.]).          % AS (wait A Second)
morse(ct, [-,.,-,.,-]).          % CT (starting signal, Copy This)
morse(sk, [.,.,.,-,.,-]).        % SK (end of work, Silent Key)
morse(sn, [.,.,.,-,.]).          % SN (understood, Sho' 'Nuff)