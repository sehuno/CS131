(define (null-ld? obj)
	(and (pair? obj) (eq? (car obj) (cdr obj))))

(define (listdiff? obj) 
	(if (not (pair? obj)) 
		#f
		(cond [(eq? (car obj) (cdr obj)) #t]
            [(not(pair? (car obj))) #f]
            [(eq? '() (car obj)) #f]
            [else (listdiff? (cons (cdr (car obj)) (cdr obj)))])))   

(define (cons-ld obj listdiff)
	(if (not(listdiff? listdiff))
		'error
		(cons (cons obj (car listdiff)) (cdr listdiff))))
				
(define (car-ld listdiff)
	(if (or (not(listdiff? listdiff)) (null-ld? listdiff))
		'error
		(car (car listdiff))))

(define (cdr-ld listdiff)
	(if (or (not(listdiff? listdiff)) (null-ld? listdiff))
		'error
		(cons (cdr (car listdiff)) (cdr listdiff))))

(define (listdiff obj . args)
	(cons (cons obj args) '()))

(define (length-ld listdiff)
	(if (not (listdiff? listdiff))
		'error
		(if (null-ld? listdiff)
			0
			(+ 1 (length-ld (cdr-ld listdiff))))))

(define (get_diff ld1 ld2)
	(if (null-ld? ld1) 
		ld2
		(let ((ld (car-ld ld1)) (tail (cdr-ld ld1)))
			(cons-ld ld (get_diff tail ld2)))))

(define (append-ld listdiff . args)
	(if (not (listdiff? listdiff)) 
		'error
		(let join ((ld listdiff) (tail args))
			(if (eq? '() tail) 
				ld
				(join (get_diff ld (car tail)) (cdr tail))))))
		
(define (assq-ld obj alistdiff)
	(if (null-ld? alistdiff) 
		#f
		(let ((head (car-ld alistdiff)))
			(if (eq? obj (car head)) 
				head
				(assq-ld obj (cdr-ld alistdiff))))))
		
(define (list->listdiff l)
	(cons l '()))
		
(define (listdiff->list listdiff)
	(if (not(listdiff? listdiff)) 
		'error
		(if (null-ld? listdiff) 
			'()
			(cons (car-ld listdiff) (listdiff->list (cdr-ld listdiff))))))

(define (expr-returning listdiff) 
	(quasiquote (list ',(listdiff->list listdiff))))

; (define ils (append '(a e i o u) 'y))
; (define d1 (cons ils (cdr (cdr ils))))
; (define d2 (cons ils ils))
; (define d3 (cons ils (append '(a e i o u) 'y)))
; (define d4 (cons '() ils))
; (define d5 0)
; (define d6 (listdiff ils d1 37))
; (define d7 (append-ld d1 d2 d6))
; (define e1 (expr-returning d1))

; (listdiff? d1)                         ===>  #t
; (listdiff? d2)                         ===>  #t
; (listdiff? d3)                         ===>  #f
; (listdiff? d4)                         ===>  #f
; (listdiff? d5)                         ===>  #f
; (listdiff? d6)                         ===>  #t
; (listdiff? d7)                         ===>  #t

; (null-ld? d1)                          ===>  #f
; (null-ld? d2)                          ===>  #t
; (null-ld? d3)                          ===>  #f
; (null-ld? d6)                          ===>  #f

; (car-ld d1)                            ===>  a
; (car-ld d2)                            ===>  error
; (car-ld d3)                            ===>  error
; (car-ld d6)                            ===>  (a e i o u . y)

; (length-ld d1)                         ===>  2
; (length-ld d2)                         ===>  0
; (length-ld d3)                         ===>  error
; (length-ld d6)                         ===>  3
; (length-ld d7)                         ===>  5

; (define kv1 (cons d1 'a))
; (define kv2 (cons d2 'b))
; (define kv3 (cons d3 'c))
; (define kv4 (cons d1 'd))
; (define d8 (listdiff kv1 kv2 kv3 kv4))
; (eq? (assq-ld d1 d8) kv1)              ===>  #t
; (eq? (assq-ld d2 d8) kv2)              ===>  #t
; (eq? (assq-ld d1 d8) kv4)              ===>  #f

; (eq? (car-ld d6) ils)                  ===>  #t
; (eq? (car-ld (cdr-ld d6)) d1)          ===>  #t
; (eqv? (car-ld (cdr-ld (cdr-ld d6))) 37)===>  #t
; (equal? (listdiff->list d6)
;         (list ils d1 37))              ===>  #t
; (eq? (list-tail (car d6) 3) (cdr d6))  ===>  #t

; (listdiff->list (eval e1))             ===>  (a e)
; (equal? (listdiff->list (eval e1))
;         (listdiff->list d1))           ===>  #t

