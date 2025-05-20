#!/usr/bin/env gimp-script-fu-interpreter-3.0

; Marvel Ultimate Alliance normal map conversion Green to Yellow
; In script-fu-interpreter-3.0, return values (vector or value) changed, as well as whether vectors or values can be used as arguments

(define (script-fu-mua-normalg2y Image Drawables)
    (script-fu-use-v3)

    (let* (
        (tmp (car (plug-in-decompose 1 Image Drawables "rgba" 1)))
        (Red (gimp-image-get-layer-by-name tmp "green"))
        (Green (gimp-image-get-layer-by-name tmp "alpha"))
        (Black (gimp-layer-new tmp "black" (gimp-image-get-width Image) (gimp-image-get-height Image) 2 100))
    )

        (gimp-image-undo-group-start Image)

    ; Add blue channel as layer (required for script-fu-interpreter-3.0)
    (gimp-image-insert-layer tmp Black 0 -1)

    ; Compose the new narmal map from the channels as layers
    (define tmp2 (plug-in-drawable-compose 1 tmp (vector Red) Green Black Black "rgb"))

    ; Copy the composed layer from the temporary image
    (define nm (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) Image))
    (gimp-item-set-name nm "DXT5nm")
    (gimp-image-insert-layer Image nm 0 -1)
    (gimp-layer-add-alpha nm) ; or not

    ; Clean up the images
    (gimp-item-set-visible (vector-ref Drawables 0) FALSE)
    (gimp-image-delete tmp)
    (gimp-image-delete tmp2)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register-filter "script-fu-mua-normalg2y"
    "MUA Normal Map Conversion (Green to Yellow)"
    "Convert a MUA 2006 normal map texture (greenish) to DXN (yellowish) for Marvel Ultimate Alliance 2016 (Steam). Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "April 2025"
    "RGBA"
    SF-ONE-DRAWABLE
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normalg2y" "<Image>/Script-Fu")