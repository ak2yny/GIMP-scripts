; Use a green/magenta image to create an alpha channel on a normal coloured image.
; Magenta is alpha.
; Green/magenta must be top layer, Normal coloured must be second layer.
(define (script-fu-gm-alpha-mask image layer)

    (let* ((magenta 0)(green 0)(mask 0)(pic 0)(pic2 0))

        (gimp-image-undo-group-start image)

    (set! mask (aref (cadr (gimp-image-get-layers image)) 0))
    (set! pic (aref (cadr (gimp-image-get-layers image)) 1))
    (gimp-layer-add-alpha pic)
    (set! pic2 (car (gimp-layer-copy pic 0)))
    (gimp-image-insert-layer image pic2 0 1)
    (set! magenta (car (gimp-layer-copy mask 0)))
    (set! green (car (gimp-layer-copy mask 0)))
    (gimp-image-insert-layer image magenta 0 3)
    (gimp-image-insert-layer image green 0 4)
    (plug-in-colortoalpha RUN-NONINTERACTIVE image magenta '(255 0 255))
    (gimp-image-select-item image 2 magenta)
    (gimp-selection-invert image)
    (gimp-drawable-edit-clear pic)
    (gimp-selection-none image)
    (plug-in-colortoalpha RUN-NONINTERACTIVE image green '(0 255 0))
    (gimp-image-select-item image 2 green)
    (gimp-drawable-edit-clear pic2)
    (gimp-image-remove-layer image magenta)
    (gimp-image-remove-layer image green)
    (gimp-selection-none image)
    (gimp-image-merge-down image pic2 2)
    (gimp-item-set-visible mask FALSE)

    (gimp-displays-flush)

        (gimp-image-undo-group-end image)

    )

)

; populate script registration information
(script-fu-register "script-fu-gm-alpha-mask"
    "Magenta/Green to alpha mask"
    "Use a green/magenta image to create an alpha channel on a normal coloured image. Magenta is alpha. Magenta/Green must be top layer, Normal coloured must be second layer."
    "ak2yny"
    "ak2yny"
    "May 2022"
    "*"
    SF-IMAGE        "Image"       0
    SF-DRAWABLE     "Layer"       0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-gm-alpha-mask" "<Image>/Script-Fu")