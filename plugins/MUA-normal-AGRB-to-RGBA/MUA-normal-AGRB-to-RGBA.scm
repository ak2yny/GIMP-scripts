#!/usr/bin/env gimp-script-fu-interpreter-3.0

; Marvel Ultimate Alliance (1) normal map conversion
; In script-fu-interpreter-3.0, return values (vector or value) changed, as well as whether vectors or values can be used as arguments

(define (script-fu-mua-normal-pinktoblue Image Drawables)
    (script-fu-use-v3)

    (let* (
        (tmp (car (plug-in-decompose 1 Image Drawables "rgba" 1)))
        (Red (gimp-image-get-layer-by-name tmp "alpha"))
        (Green (gimp-image-get-layer-by-name tmp "green"))
        (Alpha (gimp-image-get-layer-by-name tmp "blue")) ; should be white
        (Blue (gimp-image-get-layer-by-name tmp "red"))
    )

        (gimp-image-undo-group-start Image)

    ; Compose the new narmal map from the channels as layers
    (define tmp2 (plug-in-drawable-compose 1 tmp (vector Red) Green Blue Alpha "rgba"))

    ; Copy the composed layer from the temporary image
    (define nm (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) Image))
    (gimp-item-set-name nm "Normal")
    (gimp-image-insert-layer Image nm 0 -1)

    ; Clean up the images
    (gimp-item-set-visible (vector-ref Drawables 0) FALSE)
    (gimp-image-delete tmp)
    (gimp-image-delete tmp2)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register-filter "script-fu-mua-normal-pinktoblue"
    "MUA Normal Map Pink to Blue"
    "Convert a pink normal map texture to standard (blueish), by collecting the appropriate info from the appropriate channels. Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "April 2025"
    "RGBA"
    SF-ONE-DRAWABLE
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normal-pinktoblue" "<Image>/Script-Fu")