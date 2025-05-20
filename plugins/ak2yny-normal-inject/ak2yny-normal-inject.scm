#!/usr/bin/env gimp-script-fu-interpreter-3.0

; Normal map to diffuse injector for PNG (keeps layers)
; In script-fu-interpreter-3.0, return values (vector or value) changed, as well as whether vectors or values can be used as arguments

(define (script-fu-mua-combine Image Drawables)
    (script-fu-use-v3)

    (let* ((Drawable (vector-ref Drawables 0)))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

        (let* (
            (tmp (car (plug-in-decompose 1 Image Drawables "rgba" 1)))
            (Red (gimp-image-get-layer-by-name tmp "red"))
            (Green (gimp-image-get-layer-by-name tmp "green"))
            (Blue (gimp-image-get-layer-by-name tmp "blue"))
            (Alpha (gimp-image-get-layer-by-name tmp "alpha"))
            )

        (gimp-drawable-invert Red 0)
        (gimp-drawable-invert Green 0)

        (define tmp2 (plug-in-drawable-compose 1 tmp (vector Red) Green Blue Alpha "rgba"))

        ; Layer group where modes are different. Didn't look good.
        ; (set! shade (car (gimp-layer-group-new Image)))
        ; (gimp-item-set-name shade "Shade")
        ; (gimp-image-insert-layer Image shade 0 -1)

        ; Create the highlight and shadow layers
        (define highlight (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) Image))
        (gimp-image-insert-layer Image highlight 0 -1)
        (plug-in-colors-channel-mixer 1 Image highlight 1 0.5 0 0 0 0.5 0 0 0 0)
        (plug-in-autostretch-hsv 1 Image highlight)
        (define shadow (car (gimp-layer-copy highlight 0)))
        (gimp-image-insert-layer Image shadow 0 -1)

        ; Set-up the highlight layer
        (gimp-item-set-name highlight "Highlight")
        (gimp-drawable-levels highlight 0 0.5 1 0 1.00 0 1 0)
        (gimp-layer-set-mode highlight 33)
        ; Set-up the shadow layer
        (gimp-item-set-name shadow "Shadow")
        (gimp-drawable-levels shadow 0 0 0.5 0 1.00 0 1 0)
        (gimp-layer-set-mode shadow 30)

        ; Create details from dark colours
        ; desaturate modes 0,1, 3,4
        (gimp-drawable-desaturate Drawable 1)
        (plug-in-autostretch-hsv 1 Image Drawable)
        (gimp-drawable-levels Drawable 0 0 0.6 0 1.50 0 1 0)
        (gimp-layer-set-mode Drawable 30)

        ; Clean up the images
        (gimp-image-delete tmp)
        (gimp-image-delete tmp2)
        (gimp-item-set-visible highlight FALSE)
        (gimp-item-set-visible shadow FALSE)
        ; (gimp-item-set-visible Drawable FALSE)

        )

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register-filter "script-fu-mua-combine"
    "Normal Map to Diffuse Injector"
    "Injects a Normal map texture (blueish) with a Diffuse texture (combines them). Normal must be selected and will be replaced. Adds two extra layers to add extra shadows and highlights. After edits are usually required (50% opacity eraser with soft brush recommended)."
    "ak2yny"
    "ak2yny"
    "April 2025"
    "RGB*"
    SF-ONE-DRAWABLE
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-combine" "<Image>/Script-Fu")