; Flame Helper (prepare image first)
(define (script-fu-flame-helper Image Drawable)

    (let* ((cld 0)(plsm 0))

        (gimp-image-undo-group-start Image)

    (gimp-drawable-color-balance Drawable 0 TRUE 100 25 -25)
    (gimp-drawable-color-balance Drawable 1 TRUE 100 25 -25)
    (gimp-drawable-color-balance Drawable 2 TRUE 100 0 -100)

    (gimp-context-set-foreground '(255 255 255))

    (set! cld (car (gimp-layer-new Image (car (gimp-image-width Image)) (car (gimp-image-height Image)) 1 "Cloud" 100 23)))
    (gimp-image-insert-layer Image cld 0 -1)
    (plug-in-solid-noise 1 Image cld FALSE FALSE 0 1 13 7)

    (set! plsm (car (gimp-layer-new Image (car (gimp-image-width Image)) (car (gimp-image-height Image)) 1 "Plasma" 100 23)))
    (gimp-image-insert-layer Image plsm 0 -1)
    (plug-in-plasma 1 Image plsm 0 1)
    (gimp-drawable-desaturate plsm 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)


        (gimp-image-undo-group-start Image)

    (set! plsm (car (gimp-image-merge-visible-layers Image 0)))

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-flame-helper"
    "Flame Helper (prepare image first)"
    "Before applying: Draw two white lines on a black background, approx. 50 px apart and parallel. Choose the smudge tool. Click the button next to 'Brush Dynamics'. Check the boxes under 'Pressure Rate' and 'Velocity Rate'. Click on the bottom stripe and draw your mouse up past the second stripe until the white stripes are no longer visible. - Chron.com"
    "ak2yny"
    "ak2yny"
    "October 2020"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-flame-helper" "<Image>/Script-Fu")