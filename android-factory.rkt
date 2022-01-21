#lang racket
(require 2htdp/universe 2htdp/image)
(require lang/posn)
(provide (all-defined-out))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;INTEGRANTES:
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Francisco Grimolizzi
;María Celi
;Gabriel Debuc
;Nicolas Sanchez
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                   CONSTANTES
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(define WIDTH 700)
(define HEIGHT 400)
(define TORSO-HEIGHT 120)
(define TORSO-WIDTH 100)
(define RADIUS-30 30) 

(define ANDROID-COLOR (color 151 193 60))
(define BATMAN-COLOR (color 68 85 100))
(define SUPERMAN-COLOR (color 0 96 170))
(define SKIN-COLOR (color 251 199 171))

(define BAT-BELT-WIDTH 8) 
(define BAT-BELT-DIST (* (+ BAT-BELT-WIDTH 6) 2))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                   FUNCIONES BASE
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;color: string
;head: image
;head: string -> image
;recibe 2 colores  y crea la cabeza con ese color
(define (head color1 color2)
  (overlay/xy (overlay/xy
               (underlay/xy
                (underlay/xy
                 (wedge (/ (+ TORSO-WIDTH (* RADIUS-30 2)) 2) 180 "solid" color1) ;semicirculo de la cabeza   
                 40 40
                 (circle 6 "solid" color2)) ;ojos
                110 40
                (circle 6 "solid" color2)) ;ojos
               20 -20
               (rotate 30 (above (crop 0 0 8 4(circle 4 "solid" color1)) (rectangle 8 50 "solid" color1))));antena izquierda
             110 0
             (rotate -30 (above (crop 0 0 8 4(circle 4 "solid" color1)) (rectangle 8 50 "solid" color1))))) ;antena derecha

;torso: image
;torso: string -> image
;recibe 2 colores  y dibuja el torso del android con ese color
(define (torso color1 color2)
  (above (rectangle (+ TORSO-WIDTH (* RADIUS-30 2)) (- TORSO-HEIGHT  (/ TORSO-HEIGHT 4)) "solid" color1)
        (beside (above (rectangle RADIUS-30 (/ TORSO-HEIGHT 4) "solid" color2)
                      (rotate 90 (crop 0 0 RADIUS-30 RADIUS-30 (circle RADIUS-30 "solid" color2))))
               (beside (rectangle TORSO-WIDTH (+ (/ TORSO-HEIGHT 4) RADIUS-30) "solid" color2)
                      (above (rectangle RADIUS-30 (/ TORSO-HEIGHT 4) "solid" color2)
                            (rotate 180 (crop 0 0 RADIUS-30 RADIUS-30 (circle RADIUS-30 "solid"  color2))))))))

;mano-pie: image
;mano-pie: string -> image
;recibe un color y crea las manos/pies
(define (mano-pie color)
  (rotate 180 (crop 0 0 40 20 (circle 20 "solid" color))))

;extremidad: image
;extremidad: string -> image
;recibe 2 colores y dibuja los brazos o las piernas del android
(define (extremidad color1 color2)
  (above (rotate 180 (mano-pie color1))
        (above (rectangle 40 (- TORSO-HEIGHT RADIUS-30) "solid" color1) 
              (mano-pie color2))))

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID ORIGINAL
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;draw-android: image
;draw-android: string -> image
;recibe 9 colores y dibuja el android de esos colores.
(define (draw-android headcolor eyecolor torsocolor pantscolor armcolor handcolor legcolor footcolor background)
  (place-image (head headcolor eyecolor) (/ WIDTH 2) (/ HEIGHT 5.7) ;CABEZA     
              (place-image (extremidad armcolor handcolor) (/ WIDTH 1.54) (/ HEIGHT  2.02) ;BRAZO IZQUIERDO 
                          (place-image (extremidad armcolor handcolor) (/ WIDTH 2.85) (/ HEIGHT 2.02) ;BRAZO DERECHO
                                      (place-image (torso torsocolor pantscolor) (/ WIDTH 2) (/ HEIGHT 2)  ;TORSO          
                                                  (place-image (extremidad legcolor footcolor) (/ WIDTH 1.83) (/ HEIGHT 1.49);PIERNA IZQUIERDA
                                                              (place-image (extremidad legcolor footcolor) (/ WIDTH 2.2) (/ HEIGHT 1.49);PIERNA DERECHA
                                                                          (empty-scene WIDTH HEIGHT background))))))))

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID GRUPAL
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID MONOPOLY
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;mp-saco: image
;mp-saco: string -> image
;recibe un color y dibuja el saco
(define (mp-saco color)
  (above (rectangle 60 70 "solid" color)  (crop 60 60 60 60 (circle 60 "solid" color))))

;triang-camisa: image
;triang-camisa: string -> image
;recibe un color y dibuja los triangulos de la camisa
(define (triang-camisa color)
  (beside (rotate 180 (triangle 30 "solid" color)) (rotate 180 (triangle 30 "solid" color))))

;mp-botons:  image
;mp-botons: string -> image
;recibe un color y dibuja los botones de la camisa
(define (mp-botons color)
  (overlay/xy (overlay/xy (circle 5 "solid" color) 0 20 (circle 5 "solid" color))
             0 -20
             (circle 5 "solid" color)))

;mp-moño: image
;mp-moño string -> image;
;recibe un color y dibuja un moño.
(define (mp-moño color)
  (overlay/xy (beside (rotate -90 (triangle 25 "solid" color)) (rotate 90 (triangle 25 "solid" color)))
             1 -8
             (scene+line (rectangle 50 40 "solid" "transparent") 15 20 25 20 (make-pen color 20 "solid" "round" "round"))))

;mp-hat: image
;mp-hat: string -> image
;recibe un color y dibuja el sombrero
(define (mp-hat color)
  (overlay/xy (overlay/xy (overlay/xy (overlay/xy (rotate 45(add-curve (rectangle 100 100 "solid" "transparent")
                                                                      20 20 0 1/3
                                                                      120 120 0 1/3
                                                                      (make-pen color 4 "solid" "round" "round")))         
                                                 50 20
                                                 (rotate -40(polygon (list (make-posn 0 0)
                                                                          (make-posn 0 20) 
                                                                          (make-pulled-point 1/3 -20 60 0 1/3 20) 
                                                                          (make-posn 0 -20))
                                                                    "solid"
                                                                    color)))
                                     45 1
                                     (rectangle 100 60 "solid" color))
                         90 32
                         (rotate -30 (polygon (list (make-posn 0 0)
                                                   (make-posn 0 20) 
                                                   (make-pulled-point 1/3 -20 60 0 1/3 20) 
                                                   (make-posn 0 -20))
                                             "solid"   
                                             color)))
             130 1
             (rectangle 20 80 "solid" color)))

;draw-android: image
;draw-android: string -> image
;recibe 7 colores y dibuja el android de esos colores.
(define (android-monopoly color1 color2 color3 color4 color5 color6 color7)
  (place-image (mp-hat color1)  (/ WIDTH 2.015) (/ HEIGHT 6.6)
              (place-image (mp-moño color6) (/ WIDTH 1.98) (/ HEIGHT 2.95)
                          (place-image (mp-botons color1) (/ WIDTH 2) (/ HEIGHT 2.3)
                                      (place-image (flip-horizontal (mp-saco color1))  (/ WIDTH 1.75) (/ HEIGHT 2.11)
                                                  (place-image (mp-saco color1)  (/ WIDTH 2.333) (/ HEIGHT 2.11)
                                                              (place-image (triang-camisa color4) (/ WIDTH 2) (/ HEIGHT 1.77)                                                                                                                                                         
                                                                          (draw-android color3 color2 color4 color5 color1 color3 color5 color1 color7))))))))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     NICOLAS SANCHEZ
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID R2-D2
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;r2-recrangle-details: image
;r2-recrangle-details string ->image
;recibe 2 colores y dibuja los detalles rectangulares del android
(define (r2-recrangle-details color)
  (overlay/xy (overlay/xy (rectangle (+ RADIUS-30 TORSO-WIDTH) 10 "solid" color)
                         0 -15
                         (rectangle (+ RADIUS-30 TORSO-WIDTH) 10 "solid" color))
             0 30
             (rectangle (+ RADIUS-30 TORSO-WIDTH) 10 "solid" color)))

;r2-square-boton: image
;r2-square-boton string ->image
;recibe 2 colors y dibuja el boton del android
(define (r2-square-boton color1 color2)
  (underlay/xy (square 30 "solid" color1)
              5 5
              (square 20 "solid" color2)))

;r2-rectangle-boton: image
;r2-rectangle-boton: string ->image
;recibe 2 colores y dibuja los botones con forma rectangular
(define (r2-rectangle-boton color1 color2)
  (underlay/xy (rectangle 30 10 "solid" color1)
              5 2.5 
              (rectangle 20 5 "solid" color2)))

;r2-boton-details: image
;r2-boton-details string ->image
;recibe 2 colores y posiciona los botones del android
(define (r2-boton-details color1 color2)
  (overlay/xy (overlay/xy (r2-square-boton color1 color2)
                         0 35
                                    (r2-square-boton color1 color2))
             0 75
                        (r2-rectangle-boton color1 color2)))

;r2-head-botons: image
;r2-head-botons string ->image
;recibe un color y dibuja los detalles de la cabeza del android
(define (r2-head-botons color)
  (underlay/xy (overlay/xy (rectangle (+ TORSO-WIDTH (* RADIUS-30 2)) 7 "solid" color)
                          20 -17
                                                  (overlay/xy (overlay/xy (overlay/xy (overlay/xy (square 15 "solid" color)
                                                                                                 -18 0
                                                                                                 (square 15 "solid" color))
                                                                                     50 0
                                                                                     (rectangle 5 15 "solid" color))
                                                                         57 0
                                                                         (rectangle 20 15 "solid" color))
                                                             110 0
                                                             (rectangle 20 15 "solid" color)))
              105 -4
                                      (circle 9 "solid" "Dim Gray")))

;r2-eye: image
;r2-eye string ->image
;recibe un color y dibuja el ojo del android
(define (r2-eye color)
  (underlay/xy (square 30 "solid" color)
              5 5
                         (circle 10 "solid" "black")))

;torso-details: image
;torso-details: string -> image
;recibe colores y dibuja los accesorios del torso
(define (torso-details color1 color2)
  (overlay/xy (r2-recrangle-details color1)
             50 50
             (r2-boton-details color1 color2)))

;head-details: image
;head-details: string -> image
;recibe un color y dibuja los detalles de la cabeza
(define (head-details color1 color2)
  (underlay/xy (overlay/xy (r2-head-botons color1)
                          35 -17 
                         (rectangle 90 15 "solid" color2))
              65 -25
             (r2-eye color1)))

;draw-r2d2: image
;draw-r2d2: string -> image
;recibe 4 colores y dibuja el android de esos colores.
(define (draw-r2d2 color1 color2 color3 color4)
  (place-image (head-details color3 color2) (/ WIDTH 2) (/ HEIGHT 4.5)
              (place-image (torso-details color3 color2) (/ WIDTH 2) (/ HEIGHT 2)
                          (draw-android color2 color1 color1 color1 color1 color1 color1 color1 color4))))

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID FRANKESTEIN
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;manga: string -> image
;recibe un color y dibuja la manga
(define (manga color)
  (above (rotate 180 (mano-pie color))
        (beside (beside (rotate 180(triangle 13.3 "solid" color))
                     (rotate 180(triangle 13.3"solid" color)))
             (rotate 180(triangle 13.3 "solid" color)))))

;ears: image
;ears: string -> image
;recibe un color y dibuja la oreja
(define (ears color)
  (beside (rectangle 12 10 "solid" color) (rectangle 10 20 "solid" color)))

;draw-frank: image
;draw-frank: string ->image
;recibe 5 colores y dibuja el android con esos colores
(define (draw-frank color1 color2 color3 color4 color5)
  (place-image (rotate 10 (ears color1)) (/ WIDTH 1.61) (/ HEIGHT 4.6)
              (place-image (rotate 170 (ears color1)) (/ WIDTH 2.64) (/ HEIGHT 4.6)
                          (place-image (manga color4) (/ WIDTH 1.54) (/ HEIGHT 2.694) 
                                      (place-image (manga color4) (/ WIDTH 2.85) (/ HEIGHT 2.694)
                                                  (draw-android color3 color2 color4 color1 color3 color3 color1 color1 color5))))))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID BATMAN
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;bat: image
;bat: string -> image
;recibe un color y dibuja el murciélago del logo de batman 
(define  (bat color)
  (underlay/xy (underlay/xy (underlay/xy (rectangle 10 30 "solid" color)
                                                   -10 9
                                                   (rectangle 30 12 "solid" color))
                                      -12 2
                                      (rotate 90 (wedge 12 180 "solid" color)))
                         42 2
                         (rotate -90 (wedge 12 180 "solid" color))))

;bat-logo: image
;bat-logo: string -> image
;recibe 2 colores y dibuja el logo de batman
(define (bat-logo color1 color2)
  (underlay/xy   (ellipse 62 42 "solid" color1) 
             4 6
             (bat color2)))

;belt-rectangles: image
;belt-rectangles: color -> image
;recibe un color y dibuja 2 rectangulos del cinturon
(define (belt-rec color)
  (underlay/xy (rectangle BAT-BELT-WIDTH 20 "solid" color)
                         (+ BAT-BELT-WIDTH 6) 0
                         (rectangle BAT-BELT-WIDTH 20 "solid" color)))

;bat-belt: image
;bat-belt: string -> image
;recibe un color y posiciona los diferentes belt-rectangles, para formar el cinturon
(define (bat-belt color)
  (underlay/xy (underlay/xy (underlay/xy (underlay/xy (underlay/xy (belt-rec color)
                                                                  BAT-BELT-DIST 0
                                                                  (belt-rec color))
                                                     (* BAT-BELT-DIST 2) 0
                                                     (belt-rec color))
                                        (* BAT-BELT-DIST 3) 0
                                        (belt-rec color))
                           (* BAT-BELT-DIST 4) 0
                           (belt-rec color)) 
              (* BAT-BELT-DIST 5) 0 
              (belt-rec color)))

;bat-eye: image
;bat-eye: string ->image
;recibe un color y dibuja los ojos de batman
(define (bat-eye color)
  (underlay/xy (circle 10 "solid" color)
              70 0
              (circle 10 "solid" color)))

;bat-face: image
;bat-face: string -> image
;recibe 2 colores y dibuja la mascara de batman
(define (bat-face color1 color2)
  (underlay/xy (rectangle (+ TORSO-WIDTH (* RADIUS-30 2)) 10 "solid" color1)
              35 -35
              (bat-eye color2)))   

;draw-batman: image
;draw-batman: string -> image
;recibe 5 colores y posiciona los detalles de batman en la escena
(define (draw-batman color1 color2 color3 color4 color5)
  (place-image (bat-face color4 color2) (/ WIDTH 2) (/ HEIGHT 4) 
              (place-image (bat-belt color3) (/ WIDTH 2) (/ HEIGHT 1.78)
                          (place-image (bat-logo color3 color2) (/ WIDTH 2) (/ HEIGHT 2.5)  
                                      (draw-android color1 color2 color1 color2 color1 color1 color1 color1 color5)))))

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     GABRIEL DEBUC
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID FALLOUT
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;pechera: image
;pechera: string -> image
;recibe un color y dibuja las lineas de la pechera

(define (pechera color)
 (underlay/xy (overlay/xy (rectangle (+ (* RADIUS-30 2) TORSO-WIDTH) 20 "solid" color)
                         (- (/ (+ (* RADIUS-30 2) TORSO-WIDTH) 2) 7.5) -70
                         (rectangle 15 70 "solid" color))
             (- (/ (+ (* RADIUS-30 2) TORSO-WIDTH) 2) 50) -24
             (crop/align "center" "bottom" 100 25 (ellipse 100 50 "solid" color))))

;draw-fallout: image
;draw-fallout: string -> image
;recibe 5 colores y dibuja el android de fallout

(define (draw-fallout color1 color2 color3 color4 color5 color6)
  (place-image (pechera color5) (/ WIDTH 2) (/ HEIGHT 2.2)
              (draw-android color1 color2 color4 color4 color4 color1 color4 color3 color6))) 

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID NINJA
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;faja-1: image
;faja-1: string -> image
;recibe un color y dibuja la faja en diagonal
(define (faja-1 color)
  (overlay/xy (rectangle (- (+ (* RADIUS-30 2) TORSO-WIDTH) 8) 2 "solid" color)
             0 6 
             (rectangle (- (+ (* RADIUS-30 2) TORSO-WIDTH) 4) 2 "solid" color)))

;faja-2: image
;faja-2: string -> image
;recibe un color y dibuja la faja horizontal
(define (faja-2 color)
  (overlay/xy (rectangle (+ (* RADIUS-30 2) TORSO-WIDTH) 2 "solid" color)
             0 6
             (rectangle (+ (* RADIUS-30 2) TORSO-WIDTH) 2 "solid" color)))

;faja-3: image
;faja-3: string -> image
;recibe un color y dibuja la faja mas pequeña
(define (faja-3 color)
  (overlay/xy (rectangle 40 2  "solid" color)
             0 6
             (rectangle 35 2  "solid" color)))

;cintas: image
;cintas: string -> image
;recibe un color y posiciona las fajas
(define (cintas color)
  (overlay/xy (overlay/xy (rotate 47 (faja-1 color))
                         0 111
                         (faja-2 color))
             50 0
             (rotate 140 (faja-3 color))))

;moño: image
;moño: string -> image
;recibe un color y dibuja el moño de la cabeza
(define (moño color)
  (overlay/xy (rotate 45 (rhombus 19 19 "solid" color))
             -9.5 20
             (rotate 90 (rhombus 19 19 "solid" color))))

;mascara: image
;mascara: string -> image
;recibe 2 colores y dibuja la mascara del ninja
(define (mascara color color1)
  (underlay/xy (underlay/xy (crop/align "center" "center" 135 30 (ellipse 150 30 "solid" color))
                           40 10
                           (circle 6  "solid" color1))
              95 10
              (circle 6  "solid" color1)))

;espada: image 
;espada: string -> image
;recibe un color y dibuja la espada
(define (espada color)
  (rotate 49(overlay/xy (overlay/xy (rectangle 40 8 "solid" color)
                                   -6 -10
                                   (rectangle 6 30 "solid" color))
                       -15 12.5
                       (rectangle 15 3.5 "solid" color))))

;draw-ninja: image
;draw-ninja: string -> image
;recibe 4 colores y posiciona los detalles del ninja
(define (draw-ninja color1 color2 color3 color4)
  (place-image (espada color1) (/ WIDTH 1.57) (/ HEIGHT 5.8)
              (place-image (mascara color3 color4) (/ WIDTH 2) (/ HEIGHT 4.8)
                          (place-image (moño color1) (/ WIDTH 2.6) (/ HEIGHT 6.5)
                                      (place-image (cintas color4) (/ WIDTH 2) (/ HEIGHT 2.17)                                                 
                                                  (draw-android color1 color4 color1 color1 color1 color1 color1 color1 color4))))))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID BOB ESPONJA
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;bob-eye: image
;bob-eye: string ->image
;recibe 3 colores y dibuja el ojo

(define (bob-eye color1 color2 color3)
  (underlay/xy (underlay/xy (underlay/xy (circle 30 "solid" color1)
                                      15 9
                                      (circle 18 "solid" color3))
                         18 12
                         ( circle 14 "solid" color2))
            23 25
            (circle 6 "solid" color1)))

;bob-medias: image
;bob-medias: string ->image
;recibe 3 colores y dibuja las medias.
(define (bob-medias color1 color2 color3)
  (underlay/xy (underlay/xy (rectangle 40 15 "solid" color1)
                           0 2
                           (rectangle 40 2 "solid" color2))
              0 -2
              (rectangle 40 2 "solid" color3)))

;bob-smile: image
;bob-smile: string -> image
;recibe 2 colores y dibuja la sonrisa
(define (bob-smile color1 color2)
  (overlay/xy (overlay/xy (crop/align "center" "bottom" 130 10 (ellipse 130 20 "outline" color2))
                         47.5 10
                         (rectangle 12 15 "solid"  color1))
             67.5 10
             (rectangle 12 15 "solid"  color1))) 

;bob-face: image
;bob-face: string -> image
;recibe 4 colores y posiciona las demas funciones para hacer la cara.
(define (bob-face color1 color2 color3 color4 )
  (underlay/xy (overlay/xy (underlay/xy (bob-eye color1 color2 color3)
                                       65 0
                                       (bob-eye color1 color2 color3))
                          -15 50
                          (rectangle (+ TORSO-WIDTH (* RADIUS-30 2)) 10 "solid" color4))
              15 65
              (bob-smile color1 color2)))

;bob-camisa: image
;bob-camisa: string -> image
;recibe 2 colores y dibuja la camisa
(define (bob-camisa color1 color2)
  (underlay/xy (rectangle  (+ TORSO-WIDTH (* RADIUS-30 2)) 30 "solid" color1)
              (- (/ (+ TORSO-WIDTH (* RADIUS-30 2)) 2) (/ 25 2)) 0 
              (above (rotate 180 (triangle 25 "solid" color2)) (rhombus 25 50 "solid" color2))))

;draw-bob: image
;draw-bob: string -> image
;recibe 7 colores y dibuja a bob esponja
(define (draw-bob color1 color2 color3 color4 color5 color6 color7)
  (place-image (rotate 180 (mano-pie color2)) (/ WIDTH 2.85) (/ HEIGHT 2.8) 
              (place-image (rotate 180 (mano-pie color2))  (/ WIDTH 1.54) (/ HEIGHT 2.8) 
                          (place-image (bob-camisa color2 color4) (/ WIDTH 2) (/ HEIGHT 1.68)
                                      (place-image (bob-medias color2 color4 color5) (/ WIDTH 2.2) (/ HEIGHT 1.31)
                                                  (place-image (bob-medias color2 color4 color5) (/ WIDTH 1.83) (/ HEIGHT 1.31)
                                                              (place-image (bob-face color2 color6 color5 color1) (/ WIDTH 2) (/ HEIGHT 3.5)
                                                                          (draw-android color1 color1 color1 color3 color1 color1 color1 color6 color7))))))))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     MARIA CELI
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID PORRISTA
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;musculosa: image
;musculosa: string -> image
;La función musculosa toma un color y dibuja la musculosa
(define (musculosa color)
  (underlay/xy (underlay/xy (crop 40 60 40 60 (ellipse 75 110 "solid" color))
                           46 0
                           (rotate 180 (wedge 35 180 "solid" color)))
              125 0 
              (flip-horizontal  (crop 40 60 40 60 (ellipse 75 110 "solid" color)))))

;porras: image
;porras: string -> image
;La función porras toma un color y dibuja las porras del android
(define (porras color)
  (underlay/xy (radial-star 32 30 50 "solid" color)
               210 00 
 (radial-star 32 30 50 "solid" color) ))

;draw-porrista: image
;draw-porrista: string -> image
;La función draw-porrista toma 5 colores y dibuja el android evaluando los colores en las funciones correspondientes
(define (draw-porrista color1 color2 color3 color4 color5)
  (place-image (musculosa color3) (/ WIDTH 2) (/ HEIGHT 2.58)
              (place-image (porras color1) (/ WIDTH 2) (/ HEIGHT 1.7)
                          (place-image (rectangle 160 15 "solid" color3)  (/ WIDTH 2) (/ HEIGHT 1.8)
                                      (draw-android color3 color2 color1 color4 color3 color3 color3 color3 color5)))))

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID INVERNAL
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;hat: image
;hat: string -> image
;La función hat toma un color y dibuja el sombrero del android
(define (hat color)
  (underlay/xy (underlay/xy (rectangle 40 50 "solid" color)
                           00 17
                           (rectangle 40 7 "solid" "red" ))
              -17 24
              (ellipse 75 30 "solid" color)))

;botones: image
;botones: string -> image
;La función botones toma un coolor y dibuja los botones del android
(define (botones color)
  (overlay/xy (overlay/xy (circle 7.5 "solid" color) 0 30 (circle 7.5 "solid" color))
             0 -30
             (circle 7.5 "solid" color)))

;sombras: image
;sombras: string -> image
;La función sombras toma un color y dibuja las sombras del android
(define (sombras color)
  (underlay/xy (underlay/xy (line 0 (- TORSO-HEIGHT RADIUS-30) (pen color 6 "solid" "round" "round"))
                           210 0
                           (line 0 (- TORSO-HEIGHT RADIUS-30) (pen color 6 "solid" "round" "round")))
              165 20
              (line 0 (- TORSO-HEIGHT RADIUS-30) (pen color 6 "solid" "round" "round"))))

;bufanda: image
;bufanda: string -> image
;La función bufanda toma un color y dibuja la bufanda del android
(define (bufanda color)
  (underlay/xy  (underlay/xy (rectangle 160 20 "solid" "red")
                     20 20
                     (rotate 90 (rectangle 58 18 "solid" "red")))
                     38 18
                           (rotate 90 (rectangle 30 18 "solid" "red"))))

;draw-invernal: image
;draw-invernal: string string string string string string  -> image
;La función draw-invernal toma 6 colores y dibuja al android invernal mediante las funciones prehechas
(define (draw-invernal color1 color2 color3 color4 color5 color6)
  (place-image (hat color2) (/ WIDTH 2) (/ HEIGHT 11.8)
              (place-image (bufanda color1) (/ WIDTH 2) (/ HEIGHT 2.44)
                          (place-image (sombras color3)  (/ WIDTH 1.93) (/ HEIGHT 1.98)
                                      (place-image (botones color2)  (/ WIDTH 2) (/ HEIGHT 2)
                                                  (place-image (rotate 140 (wedge 27 40 "solid" color4)) (/ WIDTH 1.966) (/ HEIGHT 3.88)
                                                                          (draw-android color5 color2 color5 color5 color5 color5 color5 color5 color6)))))))

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID ROBOT
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;cinturón: image
;cinturón: string -> image
;La función cinturón recibe n color y dibujae l cinturón de mi android
(define (cinturón color1 color2)
  (underlay/xy (rectangle 160 13 "solid" color1)
              68 00
               (rectangle 20 13 "solid" color2)))

;hand-foot: image
;hand-foot: string-> image
;Recibe un color y dibuja los manos o pies
(define (hand-foot color)
  (underlay/xy (rotate 180 (crop 0 0 40 20 (circle 20 "solid" color)))
              00 -20
              (crop 0 0 40 20 (circle 20 "solid" color))))

;cinturón: image
;cinturón: string-> image
;La función ojos1 recibe un color y dibuja los del android
(define (ojos1 color)
  (underlay/xy (line 0 15 (pen color 15 "solid" "round" "round"))
              60 0 
              (line 0 15 (pen color 15 "solid" "round" "round")) ))

;draw-robot: image
;draw-robot: string  -> image
;La función draw-robot toma 7 colores y dibuja al android robot mediante las funciones prehechas
(define (draw-robot color1 color2 color3 color4 color5 color6 color7)
  (place-image (cinturón color1 color2) (/ WIDTH 2) (/ HEIGHT 1.7)
              (place-image (hand-foot color3) (/ WIDTH 2.85) (/ HEIGHT 1.63)
                          (place-image (hand-foot color3)  (/ WIDTH 1.54) (/ HEIGHT 1.63)
                                         (place-image (hand-foot color3)  (/ WIDTH 1.83) (/ HEIGHT 1.25)
                                                     (place-image (hand-foot color3) (/ WIDTH 2.2) (/ HEIGHT 1.25)
                                                                   (place-image (ojos1 color1) (/ WIDTH 2) (/ HEIGHT 4.6)
                                                                                (place-image (rectangle 100 50 "solid" "light green") (/ WIDTH 2) (/ HEIGHT 4.6)
                                                                                             (draw-android color5 color1 color6 color6 color5 color3 color5 color3 color7)))))))))

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     FRANCISCO GRIMOLIZZI
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID IRON-MAN
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;ironman-core: image
;ironman-core: string -> image
;Ésta función toma un color y dibuja el núcleo del android
(define (ironman-core color)
  (circle 25 "solid" color))

;ojos-ironman: image
;ojos-ironman: string -> image
;La función ojos toma un color y dibuja los ojos del android                                                                         
(define (ojos-ironman color)
  (rectangle 28 12 "solid" color))

;boca-ironman: image
;boca-ironman: string -> image
;Toma un color y dibuja la boca del android
(define (boca-ironman color)
  (rectangle 36 8 "solid" color))

;junta-casco: image
;junta-casco: string -> image
;La función junta-casco toma un color y dibuja la junta que se encuentra arriba en la cabeza del android
(define (junta-casco color)
  (rectangle 22 8 "solid" color))

;draw-ironman: image
;draw-ironman: string ->image
;recibe 5 colores y dibuja el android con los colores dados
(define (draw-ironman color1 color2 color3 color4 color5)
  (place-image (ojos-ironman color3) (/ WIDTH 2.2) (/ HEIGHT 4.66)
              (place-image (ojos-ironman color3) (/ WIDTH 1.8) (/ HEIGHT 4.65)
                          (place-image (boca-ironman color4) (/ WIDTH 2) (/ HEIGHT 3.9)           
                                      (place-image (junta-casco color1) (/ WIDTH 2) (/ HEIGHT 9.01)
                                                  (place-image (ironman-core color3)(/ WIDTH 2)(/ HEIGHT 2.35)
                                                              (draw-android color2 color2 color1 color1 color1 color1 color1 color1  color5)))))))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID DRÁCULA
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;colmillos: image
;colmillos: string -> image
;La función colmillos toma un color y dibuja los colmillos del android
(define (colmillos color)
  (rotate 180 (triangle 25 "solid" color)))

;cinturon: image
;cinturon: string -> image
;La función cinturon toma un color y dibuja el cinturon 
(define (cinturon color)
  (rectangle 160 15 "solid" color))

;hair: image
;hair: string -> image
;La función hair toma un color y dibuja el pelo del android
(define (hair color)
  (rotate 180 (triangle 20 "solid" color)))

;draw-dracula: image
;draw-dracula: string ->image
;recibe 4 colores y dibuja el android con los colores dados
(define (draw-dracula color1 color2 color3 color4)
  (place-image(colmillos color1)(/ WIDTH 2.2)(/ HEIGHT 3.1)
              (place-image(colmillos color1)(/ WIDTH 1.83)(/ HEIGHT 3.1)
                          (place-image (hair color2) (/ WIDTH 2) (/ HEIGHT 8.2)
                                      (place-image (cinturon color3) (/ WIDTH 2) (/ HEIGHT 1.8)
                                                  (draw-android color1 color3 color2 color2 color2 color2 color2 color2 color4))))))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     ANDROID SUPERMAN
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;hair-superman: image
;hair-superman: string ->image
;recibe un color y dibuja el pelo del android superman
(define (hair-superman color)
  (rotate 100(crop 0 0 13 60(circle 30 "solid" color))))

;symbol: image
;symbol: string ->image
;recibe un color y dibuja el símbolo del superman
(define (symbol color)
  (rhombus 30 60 "solid" color))

;symbol-inside:image
;symbol-inside: string ->image
;recibe un color y dibuja la parte interior del símbolo de superman
(define(symbol-inside color)
  (rhombus 15 50 "solid" color))

;draw-superman: image
;draw-superman: string ->image
;recibe 6 colores y dibuja el android con los colores dados
(define (draw-superman color1 color2 color3 color4 color5 color6 )
  (place-image (hair-superman color5)(/ WIDTH 2.14) (/ HEIGHT 8.2)
              (place-image (symbol-inside color6) (/ WIDTH 2) (/ HEIGHT 2.4)
                          (place-image (symbol color3) (/ WIDTH 2) (/ HEIGHT 2.4)
                                      (draw-android color1 color2 color2 color3 color2 color2 color2 color3 color4)))))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     LISTA CON LAS VARIANTES DE ANDROID 
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(define ANDROID (draw-android ANDROID-COLOR
                             "White"
                             ANDROID-COLOR
                             ANDROID-COLOR
                             ANDROID-COLOR
                             ANDROID-COLOR
                             ANDROID-COLOR
                             ANDROID-COLOR
                             "white"))

(define ANDROID-MP  (android-monopoly "Black" "Black" SKIN-COLOR "White" "Grey" "Red" "Dark Blue") )
(define ANDROID-R2D2 (draw-r2d2 "White" "Gray" "Navy" "Black"))
(define ANDROID-FRANK (draw-frank "Dim Gray" "Black" "Forest Green" "Indigo" "White"))
(define ANDROID-BATMAN (draw-batman BATMAN-COLOR "Black" "Gold" SKIN-COLOR "CornflowerBlue"))
(define ANDROID-FALLOUT (draw-fallout ANDROID-COLOR "White" "saddle brown" "royal blue" "gold" "White"))
(define ANDROID-NINJA (draw-ninja "black" "grey" ANDROID-COLOR  "light sea green" ))
(define ANDROID-ESPONJA (draw-bob "Yellow" "White" "Saddle Brown" "Red" "Deep Sky Blue" "Black" "Royal Blue"))
(define ANDROID-PORRISTA (draw-porrista "deep pink" "white" "brown" "light pink" "light green"))
(define ANDROID-INVERNAL (draw-invernal "red" "black" "cyan" "orange" "white" "pink"))
(define ANDROID-ROBOT (draw-robot "black" "yellow" "magenta" "light green" "white" "cyan" "dark pink" ))
(define ANDROID-IRONMAN (draw-ironman "red" "dark orange" "white" "black" "white"))
(define ANDROID-DRACULA (draw-dracula "white" "black" "red" "gray"))
(define ANDROID-SUPERMAN (draw-superman SKIN-COLOR SUPERMAN-COLOR "red" "white" "black" "yellow"))

(define ANDROID-LIST 
  (list
   (draw-android ANDROID-COLOR  "White" ANDROID-COLOR ANDROID-COLOR ANDROID-COLOR ANDROID-COLOR ANDROID-COLOR ANDROID-COLOR "white")
   (draw-android "Deep Pink" "White"  "Firebrick" "Firebrick" "Dark Olive Green"  "Dark Olive Green" "Dark Olive Green" "Dark Olive Green" "Gold") 
   (draw-android "Salmon" "White"  "Royal Blue" "Royal Blue" "Royal Blue" "Royal Blue" "Dark Magenta" "Dark Magenta" "Spring Green") 
   (draw-android "Light Sea Green" "White"  "Violet Red" "Violet Red" "Light Sea Green" "Light Sea Green" "Crimson" "Crimson"  "Powder Blue")
   (draw-android "Dark Blue" "White"  "Dark Blue" "Dark Blue" SKIN-COLOR SKIN-COLOR  "Dark Orange" "Dark Orange" "Cyan")
   
   (android-monopoly "Black" "Black" SKIN-COLOR "White" "Grey" "Red" "Dark Blue") 
   (android-monopoly "Brown" "Black" "Dodger Blue" "Magenta" "Midnight Blue" "Dark Orange" "Lime Green")
   (android-monopoly "Royal Blue" "Black" "Dark Magenta" "Gold" "Dark Orchid" "Medium Violet Red" "Indigo")
   (android-monopoly "Dark Blue" "Black" "Coral" "CornflowerBlue" "Violet Red" "Navy" "Light Sea Green")
   (android-monopoly "Crimson" "Black" "Gold" "Mint Cream" "Cornflower Blue" "Firebrick" "Dodger Blue")
   
   (draw-r2d2 "White" "Gray" "Navy" "Black")
   (draw-r2d2 "Aquamarine" "Royal Blue" "Magenta" "Medium Blue" )
   (draw-r2d2 "Gold" "Dodger Blue" "Indigo" "Violet Red")
   (draw-r2d2 "Orange Red" "Olive Drab" "Salmon" "Goldenrod")
   (draw-r2d2 "Fuchsia" "Midnight Blue" "Deep Sky Blue" "Spring Green")

   (draw-frank "Dim Gray" "Black" "Forest Green" "Indigo" "White")
   (draw-frank "Violet Red" "Black" "Steel Blue" "Dark Orange" "Crimson")
   (draw-frank "Royal Blue" "Black" "Gold" "Firebrick" "Aqua")
   (draw-frank "Purple" "Black" "Midnight Blue" "Light Sea Green" "Yellow Green")
   (draw-frank "Medium Violet Red" "Black" "Navy" "Aqua" "Violet")

   (draw-batman BATMAN-COLOR "Black" "Gold" SKIN-COLOR "CornflowerBlue")
   (draw-batman "Dark Blue" "Sky Blue" "Crimson" "Sky Blue" "Tomato") 
   (draw-batman "Deep Pink" "Royal Blue" "Dark Violet" "Light Pink" "Indigo")
   (draw-batman "Sea Green" "Dark Green" "Medium Orchid" "Tan" "Dark Magenta")
   (draw-batman "Royal Blue" "Dark Blue" "Dark Magenta" "Aqua" "Firebrick")
   
   (draw-fallout ANDROID-COLOR "White" "saddle brown" "royal blue" "gold" "White")
   (draw-fallout "gold" "White" "green" "black" "salmon" "deep pink")
   (draw-fallout "Pale Turquoise" "White" "orange red" "olive" "salmon" "brown")
   (draw-fallout "orchid" "gold" "White" "white" "medium sea green" "black")
   (draw-fallout "dark orange" "White"  "corn flower blue" "light green" "red" "yellow")

   (draw-ninja "black" "grey" ANDROID-COLOR  "light sea green" )
   (draw-ninja "green" "blue" "pink"  "yellow" )
   (draw-ninja "dark khaki" "grey" "black"  "light pink" )
   (draw-ninja "turquoise" "grey" "gainsboro"  "fuchsia" )
   (draw-ninja "hot pink" "grey" "dark violet"  "black" )

   (draw-bob "Yellow" "White" "Saddle Brown" "Red" "Deep Sky Blue" "Black" "Royal Blue")
   (draw-bob "green" "white" "pink" "royal blue" "Deep Sky Blue" "black" "fuchsia")
   (draw-bob "violet" "white" "lawn green" "sandy brown" "Deep Sky Blue" "black" "firebrick")
   (draw-bob "sienna" "white" "silver" "sandy brown" "Deep Sky Blue" "Cornflower Blue" "lime")
   (draw-bob "dodger blue" "white" "silver" "olive" "Deep Sky Blue" "Cornflower Blue" "yellow")

   (draw-porrista "deep pink" "white" "brown" "light pink" "light green")
   (draw-porrista "Aquamarine" "Royal Blue" "Magenta" "Medium Blue" "yellow")
   (draw-porrista "Orange Red" "Olive Drab" "Salmon" "Goldenrod" "pink")
   (draw-porrista "purple" "white" "Fuchsia" "Midnight Blue" "Deep Sky Blue")
   (draw-porrista "Royal Blue" "Black" "Dark Magenta" "Gold" "Dark Orchid" )

   (draw-invernal "red" "black" "cyan" "orange" "white" "pink")
   (draw-invernal "yellow" "magenta" "light blue" "Brown" "Aquamarine" "light purple")
   (draw-invernal "dark pink" "Dark Orange" "Lime Green" "Royal Blue" "Dark Magenta" "Gold")
   (draw-invernal "Dark Blue" "Coral" "CornflowerBlue" "Violet Red" "Purple"  "Yellow")
   (draw-invernal "Crimson" "Gold" "Mint Cream" "Cornflower Blue" "Firebrick" "Dodger Blue")

   (draw-robot "black" "yellow" "magenta" "light green" "white" "cyan" "dark pink" )
   (draw-robot"Royal Blue" "Black" "cyan" "Dark Magenta" "Gold" "Dark Orchid" "Medium Violet Red" )
   (draw-robot "cyan" "orchid" "gold" "White" "dark pink" "medium sea green" "black" )
   (draw-robot"Deep Pink" "cyan" "Royal Blue" "Dark Violet" "Light Pink" "Indigo" "orange")
   (draw-robot"magenta" "White" "orange red" "olive" "salmon" "brown" "cyan" )

   (draw-ironman "red" "dark orange" "white" "black" "white")                           
   (draw-ironman "orange" "red" "white" "black" "Slate Blue")
   (draw-ironman "Olive Drab" "Blue Violet" "Medium Aquamarine" "black" "Silver")
   (draw-ironman "Medium Sea Green" "Powder Blue" "Thistle" "Lime" "Light Sky Blue")
   (draw-ironman "Midnight Blue" "Violet Red" "Yellow Green" "Aqua" "Indian Red")
   (draw-ironman "Plum" "CornflowerBlue" "Olive" "black" "Chartreuse")
   
   (draw-dracula "white" "black" "red" "gray")
   (draw-dracula "Olive Drab" "Royal Blue" "Indigo" "Linen")
   (draw-dracula "Indian Red" "Sienna" "Light Yellow" "Turquoise")
   (draw-dracula "Tomato" "Indigo" "Maroon" "Cornflower Blue")
   (draw-dracula "Deep Sky Blue" "Violet" "Dim Gray" "Hot Pink")

   (draw-superman SKIN-COLOR SUPERMAN-COLOR "red" "white" "black" "yellow")
   (draw-superman "Violet Red" "Peru" "red" "Medium Sea Green" "Dark Slate Blue" "Green")
   (draw-superman "Teal" "Coral" "Goldenrod" "Orange Red" "Orchid" "Light Steel Blue")
   (draw-superman "Dark Magenta" "Dark Khaki" "Deep Pink" "CadetBlue" "Chocolate" "Dark Slate Gray")
   (draw-superman "Dark Sea Green" "Navy" "Rosy Brown" "Thistle" "Sandy Brown" "Lawn Green")))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                     RUN-MOVIE DE LOS ANDROID
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;(run-movie 1.5 ANDROID-LIST)
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------