#!/usr/bin/env gimp-script-fu-interpreter-3.0

; Marvel Ultimate Alliance green normal maps to common blue normal maps
; In script-fu-interpreter-3.0, return values (vector or value) changed, as well as whether vectors or values can be used as arguments

(define (script-fu-mua-normal3 Image Drawables)
    (script-fu-use-v3)

    (let* (
        (tmp (car (plug-in-decompose 1 Image Drawables "rgba" 1)))
        (Red (gimp-image-get-layer-by-name tmp "alpha"))
        (Green (gimp-image-get-layer-by-name tmp "green"))
        (Alpha (gimp-layer-new tmp "alpha_new" (gimp-image-get-width Image) (gimp-image-get-height Image) 2 100))
    )

        (gimp-image-undo-group-start Image)

    ; Add alpha channel as layer (required for script-fu-interpreter-3.0)
    (gimp-drawable-fill Alpha FILL-WHITE)
    (gimp-image-insert-layer tmp Alpha 0 -1)

    ; Re-creating a Blue channel with script-fu fails.
    ; SQRT, however that's done, is missing. The result is worse than pure white

    ; Hide all layers:
    ; (let loop ((layers (vector->list (cadr (gimp-image-get-layers Image)))))
    ;   (unless (null? layers)
    ;     (gimp-item-set-visible (car layers) 0)
    ; (loop (cdr layers))))

    ; Define extra layers for the "math"
    ; (define GT (car (gimp-layer-copy Green TRUE)) )
    ; (gimp-item-set-name Green "GreenT")
    ; (gimp-item-set-name GT "GreenT2")
    ; (define RT (car (gimp-layer-copy Red TRUE)) )
    ; (gimp-item-set-name Red "RedT")
    ; (gimp-item-set-name RT "RedT2")

    ; Do the "math" (multiply, subtract, invert - result should be square rooted but don't know how)
    ; (gimp-image-insert-layer Image Green 0 0) fails
    ; (gimp-image-insert-layer Image GT 0 1)
    ; (gimp-layer-set-mode Green LAYER-MODE-MULTIPLY)
    ; (set! G (car (gimp-layer-new-from-visible Image Image "Green")))
    ; (gimp-image-insert-layer Image Red 0 0) fails
    ; (gimp-image-insert-layer Image RT 0 1)
    ; (gimp-layer-set-mode Red LAYER-MODE-MULTIPLY)
    ; (set! R (car (gimp-layer-new-from-visible Image Image "Red")))
    ; (gimp-image-insert-layer Image R 0 0)
    ; (gimp-image-insert-layer Image G 0 0)
    ; (gimp-layer-set-mode G LAYER-MODE-SUBTRACT)
    ; (set! Blue (car (gimp-layer-new-from-visible Image Image "Blue")) 0 0)
    ; (gimp-image-insert-layer Image Blue 0 0)
    ; (gimp-drawable-invert Blue FALSE)

    ; Compose the new narmal map from the channels as layers
    ; Note: Blue channel has very little information and is very difficult to restore
    (define tmp2 (plug-in-drawable-compose 1 tmp (vector Red) Green Alpha Alpha "rgb"))
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

    ; Copy the composed layer from the temporary image
    (define nm (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) Image))
    (gimp-item-set-name nm "Normal")
    (gimp-image-insert-layer Image nm 0 -1)
    ; might want to add an alpha channel

    ; Clean up the images
    (gimp-image-delete tmp)
    (gimp-image-delete tmp2)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register-filter "script-fu-mua-normal3"
    "MUA Normal Map Conversion Reverse"
    "Convert a DXT5nm map texture (greenish) to a normal map texture (blueish). Blue channel information is missing and not constructed (plain white). Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "April 2025"
    "RGBA"
    SF-ONE-DRAWABLE
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normal3" "<Image>/Script-Fu")