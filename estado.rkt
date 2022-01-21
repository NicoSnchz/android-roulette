#lang racket
(require lang/htdp-advanced)
(provide (all-defined-out))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                   ESTRUCTURA
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(define-struct Estado [seleccion saldo apuesta guia vel-guia tiempo-guia ganador etapa])
;(make-Estado: number, number, number, number, number, number, number) representa el estado del juego.
;Donde:
;selección: Corresponde al ID del android.
;saldo: Corresponde a la cantidad de puntos que tiene para apostar.
;apuesta: Corresponde a la cantidad de puntos que va a apostar.
;guía: Corresponde la posición de la ruleta.
;tiempo-guia: Corresponde al tiempo que dura el movimiento de la ruleta.
;ganador: Corresponde al ID del android seleccionado como ganador.
;etapa: Corresponde al momento en el que se está de la partida. 

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                   CONSTANTES
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Constantes para testing:
;Estado-1
(define ETD-1 (make-Estado 4 
                                            11100
                                            500
                                            30
                                            6
                                            8
                                            0
                                            3))
;Estado-2
(define ETD-2 (make-Estado 5
                                            200
                                            0
                                            250
                                            6
                                            8
                                            1
                                            2))
;Estado-3
(define ETD-3 (make-Estado 1 
                                            10900
                                            700
                                            30
                                            6
                                            8
                                            0
                                            3))
;Estado-4
(define ETD-4 (make-Estado 4 
                                            11100
                                            500
                                            30
                                            6
                                            8
                                            0
                                            1))
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                                                   SETEADORES
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;set-seleccion: estado number - estado
;Actualizar el campo selección de la estructura Estado dada.

(define (set-seleccion estado seleccion)
  (make-Estado seleccion
               (Estado-saldo estado)
               (Estado-apuesta estado)
               (Estado-guia estado)
               (Estado-vel-guia estado)
               (Estado-tiempo-guia estado)
               (Estado-ganador estado)
               (Estado-etapa estado)))
;Testing:
(check-expect (set-seleccion ETD-1 5)  (make-Estado 5 
                                                                                 11100
                                                                                 500
                                                                                 30
                                                                                 6
                                                                                 8
                                                                                 0
                                                                                 3))
;set-saldo: estado number - estado
;Actualizar el campo saldo de la estructura Estado dada.

(define (set-saldo estado saldo)
  (make-Estado (Estado-seleccion estado)
               saldo
               (Estado-apuesta estado)
               (Estado-guia estado)
               (Estado-vel-guia estado)
               (Estado-tiempo-guia estado)
               (Estado-ganador estado)
               (Estado-etapa estado)
               ))
;test:
(check-expect (set-saldo ETD-2 500) (make-Estado 5
                                                                              500
                                                                              0
                                                                              250
                                                                              6
                                                                              8
                                                                              1
                                                                              2))


;set-apuesta: estado number - estado
;Actualizar el campo apuesta de la estructura Estado dada.

(define (set-apuesta estado apuesta)
  (make-Estado (Estado-seleccion estado)
               (Estado-saldo estado)
                apuesta
               (Estado-guia estado)
               (Estado-vel-guia estado)
               (Estado-tiempo-guia estado)
               (Estado-ganador estado)
               (Estado-etapa estado)))

;set-guia: Estado number -> Estado
;recibe la posicion de la guia y la actualiza en el estado

(define (set-guia estado posicion)
  (make-Estado (Estado-seleccion estado)
                        (Estado-saldo estado)
                        (Estado-apuesta estado)
                        posicion
                        (Estado-vel-guia estado)
                        (Estado-tiempo-guia estado)
                        (Estado-ganador estado)
                        (Estado-etapa estado)))

(define (set-vel-guia estado vel)
  (make-Estado (Estado-seleccion estado)
                        (Estado-saldo estado)
                        (Estado-apuesta estado)
                        (Estado-guia estado)
                        vel
                        (Estado-tiempo-guia estado)
                        (Estado-ganador estado)
                        (Estado-etapa estado)))

;set-tiempo-guia: Estado number -> Estado
;Recibe el tiempo de duracion de la guia y lo actualiza

(define (set-tiempo-guia estado tiempo)
  (make-Estado (Estado-seleccion estado)
                        (Estado-saldo estado)
                        (Estado-apuesta estado)
                        (Estado-guia estado)
                        (Estado-vel-guia estado)
                        tiempo
                        (Estado-ganador estado)
                        (Estado-etapa estado)))

;set-ganador: Estado number -> Estado
;Actualiza el ganador de la ruleta

(define (set-ganador estado ganador)
  (make-Estado (Estado-seleccion estado)
                        (Estado-saldo estado)
                        (Estado-apuesta estado)
                        (Estado-guia estado)
                        (Estado-vel-guia estado)
                        (Estado-tiempo-guia estado)
                        ganador
                        (Estado-etapa estado)))

;set-etapa: Estado etapa -> Estado
;Actualiza la etapa del juego

(define (set-etapa estado etapa)
  (make-Estado (Estado-seleccion estado)
                        (Estado-saldo estado)
                        (Estado-apuesta estado)
                        (Estado-guia estado)
                        (Estado-vel-guia estado)
                        (Estado-tiempo-guia estado)
                        (Estado-ganador estado)
                        etapa))