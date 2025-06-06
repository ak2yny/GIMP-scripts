#!/usr/bin/env gimp-script-fu-interpreter-3.0

; Marvel Ultimate Alliance (1) hud quick finish
(define (script-fu-mua-colourflip image drawables)
    (script-fu-use-v3)

    (gimp-selection-none image)
    (let* (
        (hud (gimp-layer-new-from-visible image image "HUD"))
        (tmp (car (plug-in-decompose 1 image (vector hud) "rgba" 1)))
        (Red (gimp-image-get-layer-by-name tmp "blue"))
        (Green (gimp-image-get-layer-by-name tmp "green"))
        (Blue (gimp-image-get-layer-by-name tmp "red"))
        (Alpha (gimp-image-get-layer-by-name tmp "alpha"))
        (tmp2 (plug-in-drawable-compose 1 tmp (vector Red) Green Blue Alpha "rgba"))
        (hud2 (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) image))
    )
        (gimp-item-set-name hud2 "HUD")
        (gimp-image-insert-layer image hud2 0 -1)
        ; (plug-in-colors-channel-mixer RUN-NONINTERACTIVE image hud FALSE 0 0 1 0 1 0 1 0 0)
        (gimp-item-transform-flip-simple hud2 ORIENTATION-VERTICAL TRUE 0)
    )

    (gimp-displays-flush)

)

; populate script registration information
(script-fu-register-filter "script-fu-mua-colourflip"
    "MUA HUD Colorflip"
    "Flip and colour-swap (RGB>BGR) visible layers for Marvel Ultimate Alliance (HUDs and more). Creates a new layer called HUD."
    "ak2yny"
    "ak2yny"
    "Oct. 2019 - Apr. 2025"
    "RGB*"
    SF-ONE-DRAWABLE
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-colourflip" "<Image>/Script-Fu")