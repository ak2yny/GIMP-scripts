; Marvel Ultimate Alliance (1) hud blue glow
(define (script-fu-mua-glow-a image layer)

(let* ((copy 0))

    (gimp-image-undo-group-start image)

    (gimp-image-select-item image 0 layer)
    (set! copy (car (gimp-layer-copy layer TRUE)))
    (gimp-image-insert-layer image copy 0 -1)
    (gimp-selection-grow image 2)
    (gimp-selection-feather image 8)
    (gimp-context-set-foreground '(50 208 255))
    (gimp-drawable-edit-fill layer FILL-FOREGROUND)
    (gimp-selection-shrink image 1)
    (gimp-context-set-foreground '(255 255 255))
    (gimp-drawable-edit-fill layer FILL-FOREGROUND)
    (gimp-selection-none image)

    (gimp-image-undo-group-end image)

    (gimp-displays-flush)
))

; populate script registration information
(script-fu-register "script-fu-mua-glow-a"
    "MUA HUD glow 256 alpha"
    "Create a blue glow around an image with a transparent background."
    "ak2yny"
    "ak2yny"
    "June 2021"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Layer"                           0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-glow-a" "<Image>/Script-Fu")

