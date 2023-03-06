; MUA Quick Scale for Loadscreens
(define (script-fu-mua-scalels Image Layer)

        (gimp-image-undo-group-start Image)

    (gimp-image-scale Image 2048 1024)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

)

; populate script registration information
(script-fu-register "script-fu-mua-scalels"
    "MUA Quick Scale for Loadscreens"
    "Scale any image to 2048x1024. To be used as loadscreens for Marvel Ultimate Alliance."
    "ak2yny"
    "ak2yny"
    "2020"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Layer"                           0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-scalels" "<Image>/Script-Fu")