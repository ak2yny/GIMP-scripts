; Normal map to diffuse injector for PNG (keeps layers)
(define (normal-diffuse-combine Image Drawable)

    (let* ((tmp 0)(tmp2 0)(highlight 0)(shadow 0)(Red 0)(Green 0)(Blue 0)(Alpha 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)
    (define tmp (plug-in-decompose 1 Image Drawable "RGBA" 0))

    (set! Red (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp) )) Image) ))
    (set! Green (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadr tmp) )) Image) ))
    (set! Blue (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (caddr tmp) )) Image) ))
    (set! Alpha (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadddr tmp) )) Image) ))
    (gimp-image-insert-layer Image Red 0 -1)
    (gimp-image-insert-layer Image Green 0 -1)
    (gimp-drawable-invert Red 0)
    (gimp-drawable-invert Green 0)

    (define tmp2 (plug-in-drawable-compose 1 Image Red Green Blue Alpha "RGBA"))
    (gimp-image-remove-layer Image Red)
    (gimp-image-remove-layer Image Green)

    ; Layer group where modes are different. Didn't look good.
    ; (set! shade (car (gimp-layer-group-new Image)))
    ; (gimp-item-set-name shade "Shade")
    ; (gimp-image-insert-layer Image shade 0 -1)

    (set! highlight (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-image-insert-layer Image highlight 0 -1)
    (plug-in-colors-channel-mixer 1 Image highlight 1 0.5 0 0 0 0.5 0 0 0 0)
    (plug-in-autostretch-hsv 1 Image highlight)

    (set! shadow (car (gimp-layer-copy highlight 0)))
    (gimp-image-insert-layer Image shadow 0 -1)

    (gimp-item-set-name highlight "Highlight")
    (gimp-drawable-levels highlight 0 0.5 1 0 1.00 0 1 0)
    (gimp-layer-set-mode highlight 33)
    (gimp-item-set-name shadow "Shadow")
    (gimp-drawable-levels shadow 0 0 0.5 0 1.00 0 1 0)
    (gimp-layer-set-mode shadow 30)

    ; desaturate modes 0,1, 3,4
    (gimp-drawable-desaturate Drawable 1)
    (plug-in-autostretch-hsv 1 Image Drawable)
    (gimp-drawable-levels Drawable 0 0 0.6 0 1.50 0 1 0)
    (gimp-layer-set-mode Drawable 30)

    (gimp-item-set-visible highlight 0)
    (gimp-item-set-visible shadow 0)
    ; (gimp-item-set-visible Drawable 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "normal-diffuse-combine"
    "Normal Map to Diffuse Injector"
    "Injects a Normal map texture (blueish) with a Diffuse texture (combines them), keeping the new as a separate layer. Removes the Normal map layer. Adds two extra layers to add extra shadows and highlights. After edits are usually required (50% opacity eraser with soft brush recommended)."
    "ak2yny"
    "ak2yny"
    "March 2023"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "normal-diffuse-combine" "<Image>/Script-Fu")