; Marvel Ultimate Alliance 2016 (1) normal map conversion
(define (script-fu-mua-normal3 Image Drawable)

    ; Some extra variables for the "math". Unused as long as marked as comments.
    (let* ((tmp 0)(tmp2 0)(map 0)(Red 0)(Green 0)(Blue 0)(Alpha 0)(GT 0)(RT 0)(G 0)(R 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

    (define tmp (plug-in-decompose 1 Image Drawable "RGBA" 0))

    (gimp-context-set-background '(255 255 255))
    (set! Red (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car (cdr (cdr (cdr tmp)))) )) Image) ))
    (set! Green (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car (cdr tmp)) )) Image) ))
    (set! Alpha (car (gimp-layer-new Image (car (gimp-image-width Image)) (car (gimp-image-height Image)) 2 "Alpha" 100 0)))
    (gimp-drawable-fill Alpha FILL-BACKGROUND)

    ; Re-creating a Blue channel with script-fu fails.
    ; SQRT, however that's done, is missing. The result is worse than pure white

    ; Hide all layers:
    ; (let loop ((layers (vector->list (cadr (gimp-image-get-layers Image)))))
    ;   (unless (null? layers)
    ;     (gimp-item-set-visible (car layers) 0)
    ; (loop (cdr layers))))

    ; Define extra layers for the "math"
    ; (set! GT (car (gimp-layer-copy Green TRUE)) )
    ; (gimp-item-set-name Green "GreenT")
    ; (gimp-item-set-name GT "GreenT2")
    ; (set! RT (car (gimp-layer-copy Red TRUE)) )
    ; (gimp-item-set-name Red "RedT")
    ; (gimp-item-set-name RT "RedT2")

    ; Do the "math" (multiply, subtract, invert - result should be square rooted but don't know how)
    ; (gimp-image-insert-layer Image Green 0 0)
    ; (gimp-image-insert-layer Image GT 0 1)
    ; (gimp-layer-set-mode Green LAYER-MODE-MULTIPLY)
    ; (set! G (car (gimp-layer-new-from-visible Image Image "Green")))
    ; (gimp-image-insert-layer Image Red 0 0)
    ; (gimp-image-insert-layer Image RT 0 1)
    ; (gimp-layer-set-mode Red LAYER-MODE-MULTIPLY)
    ; (set! R (car (gimp-layer-new-from-visible Image Image "Red")))
    ; (gimp-image-insert-layer Image R 0 0)
    ; (gimp-image-insert-layer Image G 0 0)
    ; (gimp-layer-set-mode G LAYER-MODE-SUBTRACT)
    ; (set! Blue (car (gimp-layer-new-from-visible Image Image "Blue")) 0 0)
    ; (gimp-image-insert-layer Image Blue 0 0)
    ; (gimp-drawable-invert Blue FALSE)

    (define tmp2 (plug-in-drawable-compose 1 Image Red Green Alpha Alpha "RGBA"))
    ; Use Blue channel if defined by "math"
    ; (define tmp2 (plug-in-drawable-compose 1 Image Red Green Blue Alpha "RGBA"))

    ; Remove temporary layers when "math" is done
    ; (gimp-image-remove-layer Image Red)
    ; (gimp-image-remove-layer Image Green)
    ; (gimp-image-remove-layer Image Blue)
    ; (gimp-image-remove-layer Image RT)
    ; (gimp-image-remove-layer Image GT)
    ; (gimp-image-remove-layer Image R)
    ; (gimp-image-remove-layer Image G)

    (set! map (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name map "Normal")
    (gimp-image-insert-layer Image map 0 -1)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-normal3"
    "MUA Normal Map Conversion Reverse"
    "Convert a DXT5nm map texture (greenish) to a normal map texture (blueish) for Marvel Ultimate Alliance 2016. Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "October 2022"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normal3" "<Image>/Script-Fu")