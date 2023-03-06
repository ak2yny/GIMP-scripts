; Marvel Ultimate Alliance (1) hud light blue outline
(define (script-fu-mua-lblueLQa image layer)

(let* ((copy 0))

    (gimp-image-undo-group-start image)

    (gimp-image-select-item image 0 layer)
    (set! copy (car (gimp-layer-copy layer TRUE)))
    (gimp-image-insert-layer image copy 0 -1)
    (gimp-selection-grow image 2)
    (gimp-selection-feather image 7)
    (gimp-context-set-foreground '(120 210 255))
    (gimp-drawable-edit-fill layer FILL-FOREGROUND)
    (gimp-selection-none image)

    (gimp-image-undo-group-end image)

    (gimp-displays-flush)
))

; populate script registration information
(script-fu-register "script-fu-mua-lblueLQa"
    "MUA HUD outline 128 alpha"
    "Create a light blue outline around an image with a transparent background."
    "ak2yny"
    "ak2yny"
    "June 2021"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Layer"                           0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-lblueLQa" "<Image>/Script-Fu")

