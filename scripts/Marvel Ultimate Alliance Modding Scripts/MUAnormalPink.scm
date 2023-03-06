; Marvel Ultimate Alliance (1) normal map conversion
(define (script-fu-mua-normal-pink Image Drawable)

    (let* ((tmp 0)(tmp2 0)(map 0)(Red 0)(Green 0)(Blue 0)(Alpha 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

    (define tmp (plug-in-decompose 1 Image Drawable "RGBA" 0))

    (set! Alpha (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp) )) Image) ))
    (set! Green (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadr tmp) )) Image) ))
    (set! Red (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (caddr tmp) )) Image) ))
    ; The Alpha layer shoul be white from add alpha, but we force this to be white. Alpha is moved to Blue channel
    (set! Blue (car (gimp-layer-new Image (car (gimp-image-width Image)) (car (gimp-image-height Image)) 2 "Red&Blue" 100 0)))
    (gimp-context-set-foreground '(0 0 0))
    (gimp-context-set-background '(255 255 255))
    (gimp-drawable-fill Blue 1)

    (define tmp2 (plug-in-drawable-compose 1 Image Red Green Blue Alpha "RGBA"))

    (set! map (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name map "Normal_Pink")
    (gimp-image-insert-layer Image map 0 -1)

    (gimp-item-set-visible Drawable 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-normal-pink"
    "MUA Normal Map Conversion Pink"
    "Convert a normal map texture (blueish) to an alternate 3 channel normal texture that MUA understands (pinkish) for Marvel Ultimate Alliance 2006. Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "March 2023"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normal-pink" "<Image>/Script-Fu")