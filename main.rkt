#lang racket
(require racket/base)
(require 2htdp/universe 2htdp/image)
(require test-engine/racket-tests)
(require "android-factory.rkt")
(require "estado.rkt")

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                   CONSTANTES
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Color del fondo de la escena
(define BACKGRUND-COLOR "transparent")
(define IMAGEN-TRANSPARENTE (rectangle 20 40 "solid" BACKGRUND-COLOR))

;Androids a utilizar:
(define R2 (scale .5 (draw-r2d2 "White" "Gray" "Navy" BACKGRUND-COLOR)))
(define FRANK (scale .5 (draw-frank "Dim Gray" "Black" "Forest Green" "Indigo" BACKGRUND-COLOR)))
(define BATMAN (scale .5 (draw-batman BATMAN-COLOR "Black" "Gold" SKIN-COLOR BACKGRUND-COLOR)))
(define INVERNAL (scale .5 (draw-invernal "red" "black" "cyan" "orange" "white" BACKGRUND-COLOR)))
(define PORRISTA(scale .5 (draw-porrista "deep pink" "white" "brown" "light pink"BACKGRUND-COLOR)))
(define ROBOT (scale .5 (draw-robot "black" "yellow" "magenta" "light green" "white" "cyan" BACKGRUND-COLOR)))

(define R2-SCALED (scale .5 R2))
(define FRANK-SCALED (scale .5 FRANK))
(define BATMAN-SCALED (scale .5 BATMAN))
(define INVERNAL-SCALED (scale .5 INVERNAL))
(define PORRISTA-SCALED (scale .5 PORRISTA))
(define ROBOT-SCALED (scale .5 ROBOT))

;imagen:
(define RESET (scale .07(bitmap "img/refresh.png")))
(define FLECHA (rotate -90 (scale .15 (bitmap "img/flecha.png"))))
(define BACKGROUND-IMAGE (bitmap "img/background.jpg"))

;escena MAIN-MENU
(define HEIGHT (* (image-height R2) 3)) ;La altura de la pantalla esta definida el alto de la imagen del android multiplcada por 3. HEIGHT=600
(define WIDTH (* (image-width R2) 3)) ;El ancho de la pantalla esta definido por el ancho de la imagen del android multiplicado por 3
                                                             ;(cantidad de androids posicionados en fila) WIDTH = 1050

;escena para tabla de apuestas
(define BET-WIDTH (image-width R2));350
(define BET-HEIGHT (image-height R2));200
(define BET-BACKGROUND (empty-scene BET-WIDTH BET-HEIGHT BACKGRUND-COLOR))

;textos:
(define ANDROID-CHOICE (text/font "¿QUIEN GANARÁ?" 42 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define TEXTO-FINAL (text/font "PERDISTE TODO TU SALDO!!" 42 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define BET-CHOICE (text/font "ES MOMENTO DE APOSTAR!" 42 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define ANDROID-PRESS (text/font "PRESIONE SOBRE UN ANDROID PARA ELEGIRLO." 21 "white"
                       "Gill Sans" 'swiss 'normal 'normal #f))

(define RULETA-START (text/font "PRESIONE SOBRE LA FLECHA PARA COMENZAR." 38 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define ANDROID-WINNER (text/font "GANADOR" 38 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define SELECCION-FINAL (text/font "TU SELECCION" 38 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define WINNER (text/font "SU ANDROID GANO!" 38 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define LOSER (text/font "SU ANDROID PERDIO!" 38 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define APUESTA-GANADA (text/font "CANTIDAD GANADA" 38 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define APUESTA-PERDIDA (text/font "CANTIDAD PERDIDA" 38 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define APOSTADO (text/font "APOSTADO: " 22 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define BET-PRESS (text/font "Forme el monto que desea apostar y presione ESPACIO para continuar" 18 "white"
                       "Gill Sans" 'swiss 'normal 'normal #f))

(define ARROW-PRESS (text/font "Presione sobre la flecha para comenzar" 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define CONTINUAR (text/font " Presione ESPACIO para volver a jugar." 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define VOLVER (text/font "o BORRAR para volver a seleccionar." 18 "white"
                       "Gill Sans" 'swiss 'normal 'normal #f))

(define BET-SALDO (text/font "SALDO: " 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define BET-APUESTA (text/font "APOSTAR : " 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define SELECCION (text/font "TU SELECCION" 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

(define MAX-BET (text/font "MAX" 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

;textos de apuestas:
(define DIEZ (place-image (text/font "10" 42 "white"
                                    "Gill Sans" 'swiss 'normal 'bold #f)  (/ BET-WIDTH 2) (/ BET-HEIGHT 2) BET-BACKGROUND))

(define CIENCUENTA (place-image (text/font "50" 42 "white"
                                          "Gill Sans" 'swiss 'normal 'bold #f)  (/ BET-WIDTH 2) (/ BET-HEIGHT 2) BET-BACKGROUND))

(define CIEN (place-image (text/font "100" 42 "white"
                                    "Gill Sans" 'swiss 'normal 'bold #f)  (/ BET-WIDTH 2) (/ BET-HEIGHT 2) BET-BACKGROUND))

(define QUINIENTOS (place-image (text/font "500" 42 "white"
                                          "Gill Sans" 'swiss 'normal 'bold #f)  (/ BET-WIDTH 2) (/ BET-HEIGHT 2) BET-BACKGROUND))

(define MIL (place-image (text/font "1000" 42 "white"
                                   "Gill Sans" 'swiss 'normal 'bold #f)  (/ BET-WIDTH 2) (/ BET-HEIGHT 2) BET-BACKGROUND))

(define DIEZ-MIL (place-image (text/font "10000" 42 "white"
                                        "Gill Sans" 'swiss 'normal 'bold #f)  (/ BET-WIDTH 2) (/ BET-HEIGHT 2) BET-BACKGROUND))

;Filas para la ruleta
(define ROW-1 (beside (beside R2-SCALED FRANK-SCALED) BATMAN-SCALED))
(define ROW-2 (beside (beside INVERNAL-SCALED PORRISTA-SCALED) ROBOT-SCALED))
(define ANDROIDS-ROW (beside ROW-1 ROW-2))

;contantes numericas:
(define CENTRO-WIDTH (/ WIDTH 2)) ;525
(define CENTRO-HEIGHT (/ HEIGHT 2));300
(define TERCEO-HEIGHT(/ HEIGHT 3));200
(define DOSTERCEOS-HEIGHT(* (/ HEIGHT 3) 2));400
(define TERCEO-WIDTH (/ WIDTH 3));350
(define RESET-WIDTH (image-width RESET));23
(define RESET-HEIGHT (image-height RESET));26
(define ANDROID-SCALED (image-width R2-SCALED));175
(define VELOCIDAD 175)

;ubicacion incial de la flecha:
(define CENTRO-ARROW (- (image-width ROW-1) (/ ANDROID-SCALED 2)))

;limites del boton de reset de la apuesta:
(define RESET-COORD-X-INICIAL (- (/ WIDTH 1.12) (/ RESET-WIDTH 2)))
(define RESET-COORD-X-FINAL (+ (/ WIDTH 1.12) (/ RESET-WIDTH 2)))
(define RESET-COORD-Y-INICIAL (- (/ HEIGHT 3.5) (/ RESET-HEIGHT 2)))
(define RESET-COORD-Y-FINAL (+ (/ HEIGHT 3.5) (/ RESET-HEIGHT 2)))

;limites del boton de apostar el maximo:
(define MAX-BET-WIDTH (image-width MAX-BET))
(define MAX-BET-HEIGHT (image-height MAX-BET))
(define MAX-COORD-X-INICIAL (- (/ WIDTH 1.06) (/ MAX-BET-WIDTH 2)))
(define MAX-COORD-X-FINAL (+ (/ WIDTH 1.06) (/ MAX-BET-WIDTH 2)))
(define MAX-COORD-Y-INICIAL (- (/ HEIGHT 3.5) (/ MAX-BET-HEIGHT 2)))
(define MAX-COORD-Y-FINAL  (+ (/ HEIGHT 3.5) (/ MAX-BET-HEIGHT 2)))

;limites de la flecha:
(define ARROW-WIDTH  (image-width FLECHA))
(define ARROW-HEIGHT (image-height FLECHA))
(define ARROW-COORD-X-INICIAL (- CENTRO-ARROW (/ ARROW-WIDTH 2)))
(define ARROW-COORD-X-FINAL (+ CENTRO-ARROW (/ ARROW-WIDTH 2)))
(define ARROW-COORD-Y-INICIAL (- (/ HEIGHT 1.7) (/ ARROW-HEIGHT 2)))
(define ARROW-COORD-Y-FINAL (+ (/ HEIGHT 1.7) (/ ARROW-HEIGHT 2)))

;extremos de la pantalla:
(define EXT-DER (- WIDTH ARROW-WIDTH))
(define EXT-IZQ (+ 0 ARROW-WIDTH))

;tabla de androids a elegir:
(define ANDROIDS-TABLE
  (above (beside(beside R2 FRANK) BATMAN)
             (beside(beside INVERNAL PORRISTA) ROBOT)))

;tabla de apuestas:
(define BETS-TABLE
  (above (beside (beside DIEZ CIENCUENTA) CIEN)
             (beside (beside QUINIENTOS MIL) DIEZ-MIL)))

;MAIN MENU
(define MAIN-MENU
  (place-image ANDROID-PRESS  CENTRO-WIDTH (/ HEIGHT 4)
  (place-image ANDROID-CHOICE  CENTRO-WIDTH (/ HEIGHT 10)
  (place-image ANDROIDS-TABLE CENTRO-WIDTH (/ HEIGHT 1.5) BACKGROUND-IMAGE))))

;Tiempo de oscilacion:
(define SEGUNDOS 8)
(define TIEMPO (* 28 SEGUNDOS))

;Saldo inicial:
(define SALDO-INCIAL 11660)

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                ESTADO INCIAL
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(define INICIAL (make-Estado -1              ;selección ( -1 significa que no hay android seleccionado)
                                          SALDO-INCIAL ;saldo
                                          0                     ;apuesta (comienza en 0)
                                          CENTRO-ARROW;guía
                                          0                     ;velocidad de oscilacion
                                          (random TIEMPO)           ;tiempo-guia
                                          -1                    ;ganador(-1 significa que no hay android ganador)
                                          0))                  ;etapa(siendo 0 la id del primer menu. hasta 3)
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                               PREDICADOS REGIONES
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;button-region-r2: Estado -> Boolean
;predicado para que marca la region del android R2
(define (button-region-0 coord-x coord-y)
  (and (< coord-x TERCEO-WIDTH)  
                           (and (>= coord-y TERCEO-HEIGHT) 
                                   (< coord-y DOSTERCEOS-HEIGHT))))
;test:
(check-expect  (button-region-0  500 200) #f)
(check-expect  (button-region-0  200 200) #t)

;button-region-frank: number number -> Boolean
;predicado para que marca la region del android frank
(define (button-region-1 coord-x coord-y)
  (and (and (> coord-x TERCEO-WIDTH)
                  (<= coord-x (* TERCEO-WIDTH 2))) 
                           (and (>= coord-y TERCEO-HEIGHT)  
                                   (< coord-y DOSTERCEOS-HEIGHT))))
;test:
(check-expect  (button-region-1  500 200) #t)
(check-expect  (button-region-1  200 200) #f)


;button-region-batman: number number -> Boolean
;predicado para que marca la region del android batman
(define (button-region-2 coord-x coord-y)
  (and (and (> coord-x (* TERCEO-WIDTH 2))
                  (<= coord-x (* TERCEO-WIDTH 3))) 
                           (and (>= coord-y TERCEO-HEIGHT)  
                                   (< coord-y DOSTERCEOS-HEIGHT))))

;test:
(check-expect  (button-region-2  800 200) #t)
(check-expect  (button-region-2  500 200) #f)

;button-region-invernal: number number -> Boolean
;predicado para que marca la region del android batman
(define (button-region-3 coord-x coord-y)
  (and (< coord-x TERCEO-WIDTH)  
                           (and (> coord-y TERCEO-HEIGHT) 
                                   (< coord-y HEIGHT))))
;test:
(check-expect  (button-region-3  200 300) #t)
(check-expect  (button-region-3  500 300) #f)

;button-region-invernal: number number -> Boolean
;predicado para que marca la region del android batman
(define (button-region-4 coord-x coord-y)
  (and (and (> coord-x TERCEO-WIDTH)
                  (<= coord-x (* TERCEO-WIDTH 2)))  
                           (and (> coord-y TERCEO-HEIGHT) 
                                   (< coord-y HEIGHT))))
;test:
(check-expect  (button-region-4  500 300) #t)
(check-expect  (button-region-4  800 300) #f)

;button-region-invernal: number number -> Boolean
;predicado para que marca la region del android batman
(define (button-region-5 coord-x coord-y)
  (and (and (> coord-x (* TERCEO-WIDTH 2))
                  (<= coord-x (* TERCEO-WIDTH 3)))  
                           (and (> coord-y TERCEO-HEIGHT) 
                                   (< coord-y HEIGHT))))
;test:
(check-expect  (button-region-5  1040 300) #t)
(check-expect  (button-region-5 200 300) #f)

;reset-region: number number -> boolean
;region del boton reset de apuesta:
(define (reset-region coord-x coord-y)
  (and (and (> coord-x RESET-COORD-X-INICIAL)
                  (< coord-x RESET-COORD-X-FINAL))
      
          (and (> coord-y RESET-COORD-Y-INICIAL)
                  (< coord-y RESET-COORD-Y-FINAL))))
;test
(check-expect (reset-region 950 160) #t)
(check-expect (reset-region 10 175) #f)

;max-bet-region: number number -> boolean
;region del boton de apuesta maxima
(define (max-bet-region coord-x coord-y)
  (and (and (> coord-x MAX-COORD-X-INICIAL)
                  (< coord-x MAX-COORD-X-FINAL))
      
          (and (> coord-y MAX-COORD-Y-INICIAL)
                  (< coord-y MAX-COORD-Y-FINAL))))

(check-expect  (max-bet-region  500 300) #f)
(check-expect  (max-bet-region  1000 170) #t)

;arrow-region: number number ->boolean
;marca la region de la flecha.
(define (arrow-region coord-x coord-y)
  (and (and (>= coord-x ARROW-COORD-X-INICIAL) ;400
                  (<= coord-x ARROW-COORD-X-FINAL)) ;475
      
          (and (>= coord-y ARROW-COORD-Y-INICIAL);260
                  (<= coord-y ARROW-COORD-Y-FINAL)))); 444

(check-expect  (arrow-region  425 400) #t)
(check-expect  (arrow-region  500 300) #f)

;winner-region-0: number number ->boolean
(define (winner-region-0 estado)
  (and (> (Estado-guia estado) 0)
         (< (Estado-guia estado) ANDROID-SCALED)))

(check-expect  (winner-region-0  INICIAL) #f)
(check-expect  (winner-region-0  (make-Estado -1 11600 0 100 0 114 -1 0)) #t)

;winner-region-1: number number ->boolean
(define (winner-region-1 estado)
  (and (> (Estado-guia estado) ANDROID-SCALED)
         (< (Estado-guia estado) (* ANDROID-SCALED 2))))


;winner-region-2: number number ->boolean
(define (winner-region-2 estado)
  (and (> (Estado-guia estado) (* ANDROID-SCALED 2))
         (< (Estado-guia estado) CENTRO-WIDTH)))

;winner-region-3: number number ->boolean
(define (winner-region-3 estado)
  (and (> (Estado-guia estado) CENTRO-WIDTH)
         (< (Estado-guia estado) (* ANDROID-SCALED 4))))


;winner-region-4: number number ->boolean
(define (winner-region-4 estado)
  (and (> (Estado-guia estado) (* ANDROID-SCALED 4))
         (< (Estado-guia estado) (* ANDROID-SCALED 5))))

;winner-region-5: number number ->boolean
(define (winner-region-5 estado)
  (and (> (Estado-guia estado) (* ANDROID-SCALED 5))
         (< (Estado-guia estado) WIDTH)))


;hit-right-wall: Estado -> boolean.
;pregunta si la flecha choco la pared derecha.
(define (hit-right-wall? estado)
  (> (Estado-guia estado) EXT-DER))

;hit-left-wall: Estado -> boolean.
;pregunta si la flecha choco la pared izquierda.
(define (hit-left-wall? estado)
  (< (Estado-guia estado) EXT-IZQ))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                               FUNCIONES
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;winner: Estado -> Estado
;Asigna el ganador dependiendo de donde quedo la flecha.
(define (winner estado)
  (cond [(winner-region-0 estado) (set-ganador estado 0)]
           [(winner-region-1 estado) (set-ganador estado 1)]
           [(winner-region-2 estado) (set-ganador estado 2)]
           [(winner-region-3 estado) (set-ganador estado 3)]
           [(winner-region-4 estado) (set-ganador estado 4)]
           [(winner-region-5 estado) (set-ganador estado 5)]
           [else estado]))

(check-expect (winner INICIAL) (make-Estado -1 11660 0 437.5 0 204 2 0))

;bet-won: Estado -> Estado
;dependiendo de si gano o perdio, actualiza el saldo, restando lo perdido o sumando lo ganado.
(define (bet-won estado)
  (if (equal? (Estado-seleccion estado) (Estado-ganador estado))
     (set-saldo estado (+ (Estado-saldo estado) (* (Estado-apuesta estado) 3)))
     (set-saldo estado (- (Estado-saldo estado) (Estado-apuesta estado)))))

(check-expect (bet-won (make-Estado 2 11660 50 437.5 0 204 2 0)) (make-Estado -1 11810 0 437.5 0 204 2 0))

;winner-result: Estado -> image
;muestra si gano o perdio en la pantalla
(define (winner-result estado)
  (if (equal? (Estado-seleccion estado) (Estado-ganador estado))
     WINNER
     LOSER))

;bet-result-text: Estado -> image
;muestra el texto de apuesta dependiendo si gano o perdio
(define (bet-result-text estado)
  (if (equal? (Estado-seleccion estado) (Estado-ganador estado))
     APUESTA-GANADA
     APUESTA-PERDIDA))

;bet-result: Estado -> image
;muestra el monto que gano o perdio
(define (bet-result estado)
  (if (equal? (Estado-seleccion estado) (Estado-ganador estado))
     (text/font (number->string (* (Estado-apuesta estado) 3)) 38 "white" "Gill Sans" 'swiss 'normal 'bold #f) 
     (text/font (number->string (Estado-apuesta estado)) 38 "white" "Gill Sans" 'swiss 'normal 'bold #f)))

;update-estado: Estado -> Estado.
;una vez finalizado el ciclo de juego actualiza el estado.
(define (update-estado estado)
  (set-etapa
   (set-guia
    (set-vel-guia
     (set-tiempo-guia
      (set-ganador
       (set-seleccion
        (set-apuesta
         (bet-won estado) 0) -1) -1) (random  TIEMPO)) 0) CENTRO-ARROW) 0))

;start-again: Estado String -> Estado
(define (start-again estado key)
  (cond [(key=? key " ") (update-estado estado)]
           [else estado]))

;time-controller: Estado -> Estado
;frena la ruleta cuando se termina el tiempo
(define (time-controller estado)
  (if (<= (Estado-tiempo-guia estado) 0)
     (set-etapa (winner (set-vel-guia estado 0)) 3)
     estado))

;roullete: Estado -> Estado
;Comienza a mover la ruleta y a contar regresivamente el tiempo
(define (roullete estado)
   (change-direction (set-tiempo-guia (move-arrow estado)
                                                        (- (Estado-tiempo-guia estado) 1))))

;change-direction: Estado -> Estado
;si choca con la paredes, cambia la direccion del movimiento
(define (change-direction estado)
  (cond [(and (not (hit-right-wall? estado))
                     (not (hit-left-wall? estado))) estado]
       
           [(hit-right-wall? estado) (set-vel-guia (set-guia estado EXT-DER) (* (Estado-vel-guia estado) -1))]
           
           [(hit-left-wall? estado) (set-vel-guia (set-guia estado EXT-IZQ) (* (Estado-vel-guia estado) -1))]
           
           [else (set-guia estado CENTRO-ARROW)]))

;move-arrow:
(define (move-arrow estado)
  (set-guia estado (+ (Estado-guia estado) (Estado-vel-guia estado))))

;add-bet: Estado number -> number
;aumenta la apuesta dependiendo cuanto se apueste.
(define (add-bet estado valor)
  (if (<= valor (- (Estado-saldo estado) (Estado-apuesta estado)))
   (+ (Estado-apuesta estado) valor)
   (Estado-apuesta estado)))

;test:
(check-expect (add-bet INICIAL 10) 10)
(check-expect (add-bet (make-Estado -1 11600 10 CENTRO-WIDTH TIEMPO -10) 1000) 1010)


;selection-controller: Estado number number -> Estado
;controla las regiones de cada android, y asigna el valor correspondiente.
(define (selection-controller estado coord-x coord-y)
  (cond [(button-region-0 coord-x coord-y) (set-etapa (set-seleccion estado 0) 1)]
           [(button-region-1 coord-x coord-y) (set-etapa (set-seleccion estado 1) 1)]
           [(button-region-2 coord-x coord-y) (set-etapa (set-seleccion estado 2) 1)]
           [(button-region-3 coord-x coord-y) (set-etapa (set-seleccion estado 3) 1)]
           [(button-region-4 coord-x coord-y) (set-etapa (set-seleccion estado 4) 1)]
           [(button-region-5 coord-x coord-y) (set-etapa (set-seleccion estado 5) 1)]
           [else estado]))

;test:
(check-expect (selection-controller INICIAL 200 200) (make-Estado 0
                                                                                                    11660
                                                                                                    0
                                                                                                    CENTRO-WIDTH
                                                                                                    6
                                                                                                    TIEMPO
                                                                                                    -1
                                                                                                    1))

(check-expect (selection-controller INICIAL 500 200) (make-Estado 1
                                                                                                    11660
                                                                                                    0
                                                                                                    CENTRO-WIDTH
                                                                                                    6
                                                                                                    TIEMPO
                                                                                                    -1
                                                                                                    1))

;bet-controller: Estado number number -> Estado
;controla las regiones de las apuestas, y asigna el valor correspondiente a la apuesta
(define (bet-controller estado coord-x coord-y)
  (cond [(button-region-0 coord-x coord-y) (set-apuesta estado (add-bet estado 10))]
           [(button-region-1 coord-x coord-y) (set-apuesta estado (add-bet estado 50))]
           [(button-region-2 coord-x coord-y) (set-apuesta estado (add-bet estado 100))]
           [(button-region-3 coord-x coord-y) (set-apuesta estado (add-bet estado 500))]
           [(button-region-4 coord-x coord-y) (set-apuesta estado (add-bet estado 1000))]
           [(button-region-5 coord-x coord-y) (set-apuesta estado (add-bet estado 10000))]
           [(max-bet-region coord-x coord-y) (set-apuesta estado (Estado-saldo estado))]
           [(reset-region coord-x coord-y) (set-apuesta estado 0)]
           [else estado]))

;test:
(check-expect (bet-controller INICIAL 200 200) (make-Estado -1
                                                                                              11660
                                                                                              10
                                                                                              CENTRO-WIDTH
                                                                                              6
                                                                                              TIEMPO
                                                                                              -1
                                                                                              0))

(check-expect (bet-controller INICIAL 800 450) (make-Estado -1
                                                                                             11660
                                                                                             10000
                                                                                             CENTRO-WIDTH
                                                                                             6
                                                                                             TIEMPO
                                                                                             -1
                                                                                             0))
;arrow-controller: Estado number number -> Estado
;controla las region de la flecha, si las coordenadas son correctas, empieza a mover la flecha.
(define (arrow-controller estado coord-x coord-y)
 (cond [(arrow-region coord-x coord-y) (set-etapa (set-vel-guia estado VELOCIDAD) 4)]
          [else estado]))

;key-manager: Estado String -> Estado
;recibe el estado y la tecla presionada y cambia la etapa de la partida
(define (key-manager estado key)
  (cond [(key=? key " ") (set-etapa estado 2)]
           [(key=? key "\b") (set-etapa estado 0)]
           [else estado]))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                               CONTROLADORES
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;show-selection: Estado -> Image
;Muestra el android seleccionado en la pantalla de apuesta
(define (show-selection estado)
  (cond [(equal? (Estado-seleccion estado) 0) R2-SCALED]
           [(equal? (Estado-seleccion estado) 1) FRANK-SCALED]
           [(equal? (Estado-seleccion estado) 2) BATMAN-SCALED]
           [(equal? (Estado-seleccion estado) 3) INVERNAL-SCALED]
           [(equal? (Estado-seleccion estado) 4) PORRISTA-SCALED]
           [(equal? (Estado-seleccion estado) 5) ROBOT-SCALED]
           [else IMAGEN-TRANSPARENTE]))

;show-selection: Estado -> Image
;Muestra el android ganador en la pantalla de ganadores
(define (show-winner estado)
  (cond [(equal? (Estado-ganador estado) 0) R2]
           [(equal? (Estado-ganador estado) 1) FRANK]
           [(equal? (Estado-ganador estado) 2) BATMAN]
           [(equal? (Estado-ganador estado) 3) INVERNAL]
           [(equal? (Estado-ganador estado) 4) PORRISTA]
           [(equal? (Estado-ganador estado) 5) ROBOT]
           [else IMAGEN-TRANSPARENTE]))

;draw-saldo: Estado -> Image
;Toma un Estado y retorna la imagen con el saldo restante
(define (draw-saldo estado) (text/font (number->string (Estado-saldo estado)) 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))

;draw-apuesta: Estado-> Image
;Toma un Estado y retorna la imagen de la cantidad apostada.
(define (draw-apuesta estado) (text/font (number->string (Estado-apuesta estado)) 18 "white"
                       "Gill Sans" 'swiss 'normal 'bold #f))


;draw-bet: Estado -> Image
;recibe un Estado y devuelve la pantalla de apuestas
(define (draw-bet-menu estado) 
  (place-image (show-selection estado) (/ WIDTH 12) (/ HEIGHT 4)
  (place-image (draw-apuesta estado) (/ WIDTH 1.18) (/ HEIGHT 3.5)
  (place-image (draw-saldo estado) (/ WIDTH 1.18) (/ HEIGHT 4)
  (place-image RESET (/ WIDTH 1.12) (/ HEIGHT 3.5)
  (place-image MAX-BET (/ WIDTH 1.06) (/ HEIGHT 3.5)
  (place-image SELECCION (/ WIDTH 12) (/ HEIGHT 7)
  (place-image BET-APUESTA  (/ WIDTH 1.3) (/ HEIGHT 3.5)
  (place-image BET-SALDO  (/ WIDTH 1.3) (/ HEIGHT 4)
  (place-image VOLVER CENTRO-WIDTH (/ HEIGHT 4.5)
  (place-image BET-PRESS  CENTRO-WIDTH (/ HEIGHT 5.5)
  (place-image BET-CHOICE  CENTRO-WIDTH (/ HEIGHT 10)
  (place-image BETS-TABLE CENTRO-WIDTH (/ HEIGHT 1.5) BACKGROUND-IMAGE)))))))))))))

;draw-roullete: Estado -> image
;recibe el estado y dibuja la ruleta.
(define (draw-roullete estado)
  (place-image (show-selection estado) (/ WIDTH 1.2) (/ HEIGHT 3)
  (place-image (draw-apuesta estado)  (/ WIDTH 3.8) (/ HEIGHT 5) 
  (place-image SELECCION  (/ WIDTH 1.2) (/ HEIGHT 5)
  (place-image APOSTADO (/ WIDTH 6) (/ HEIGHT 5)
  (place-image FLECHA (Estado-guia estado) (/ HEIGHT 1.7)
  (place-image RULETA-START CENTRO-WIDTH (/ HEIGHT 10)
  (place-image ANDROIDS-ROW CENTRO-WIDTH (/ HEIGHT 1.15) BACKGROUND-IMAGE))))))))

;draw-winner: Estado -> image
;pantalla que muestra al ganador
(define (draw-winner estado)
  (place-image (bet-result-text estado) CENTRO-WIDTH (/ HEIGHT 2.5) 
  (place-image (bet-result estado) CENTRO-WIDTH CENTRO-HEIGHT
  (place-image CONTINUAR CENTRO-WIDTH (/ HEIGHT 1.01)
  (place-image ANDROID-WINNER (/ WIDTH 1.2) (/ HEIGHT 4)
  (place-image SELECCION-FINAL  (/ WIDTH 6) (/ HEIGHT 4)
  (place-image (winner-result estado) CENTRO-WIDTH (/ HEIGHT 10)
  (place-image (scale 2 (show-winner estado)) (/ WIDTH 1.2) (/ HEIGHT 1.5)
  (place-image (scale 4 (show-selection estado)) (/ WIDTH 6) (/ HEIGHT 1.5) BACKGROUND-IMAGE)))))))))


;controlador-pantalla: estado -> Image
;Se encarga de mostrar el estado del sistema. 
(define (controlador-pantalla estado)
  (cond [(equal? (Estado-etapa estado) 0) MAIN-MENU]
           [(equal? (Estado-etapa estado) 1) (draw-bet-menu estado)]
           [(or (equal? (Estado-etapa estado) 2)
                  (equal? (Estado-etapa estado) 4)) (draw-roullete estado)]
           [(equal? (Estado-etapa estado) 3) (draw-winner estado)]
           [else MAIN-MENU]))

;controlador-mouse: Estado number number MouseEvent -> Estado
;recibe un estado, dos coordenadas X e Y y un evento de mouse.
;si el evento del mouse fue en un lugar especifico designado a algun android
;al funcion devovera el estado con la id del android actualizada.
(define (controlador-mouse estado coord-x coord-y mouse-event)
  (cond [(and (equal? mouse-event "button-down")
                     (equal? (Estado-etapa estado) 0)) (selection-controller estado coord-x coord-y)]
       
           [(and (equal? mouse-event "button-down")
                     (equal? (Estado-etapa estado) 1)) (bet-controller estado coord-x coord-y)]
           
           [(and (equal? mouse-event "button-down")
                     (equal? (Estado-etapa estado) 2)) (arrow-controller estado coord-x coord-y)]
           
           [else estado]))

;test:
(check-expect (controlador-mouse INICIAL 200 200 "button-down") (make-Estado 0
                                                                                                    11660
                                                                                                    0
                                                                                                    CENTRO-WIDTH
                                                                                                    6
                                                                                                    TIEMPO
                                                                                                    -1
                                                                                                    1))

(check-expect (controlador-mouse INICIAL 200 200 "button-up") INICIAL)

;controlador-teclado: Estado string -> Estado
;recibe el estado y la tecla presionada dependiendo en que etapa este, el controlador del teclado va a estar activo o no
(define (controlador-teclado estado key)
  (cond [(equal? (Estado-etapa estado) 1) (key-manager estado key)]
       [(equal? (Estado-etapa estado) 3) (start-again estado key)]
           [else estado]))

;controlador-tiempo: Estado -> Estado
(define (controlador-tiempo estado)
  (cond [(equal? (Estado-etapa estado) 4) (time-controller (roullete estado))]
           [else estado]))

;stop?: Estado -> boolean
(define (stop? estado)
  (equal? (Estado-saldo estado) 0))

(check-expect (stop? (make-Estado 2 0 0 437.5 0 204 2 0)) #t)

;Texto que aparece cuando perdes todo tu saldo.
(define (ULOST s)
  (place-image TEXTO-FINAL CENTRO-WIDTH CENTRO-HEIGHT BACKGROUND-IMAGE))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                               BIG-BANG
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(big-bang INICIAL
  [to-draw controlador-pantalla]
  [on-mouse controlador-mouse]
  [on-key controlador-teclado]
  [on-tick controlador-tiempo]
  [stop-when stop? ULOST])

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------