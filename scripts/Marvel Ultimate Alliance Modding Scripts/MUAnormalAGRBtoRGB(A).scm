; Marvel Ultimate Alliance (1) normal map conversion
(define (script-fu-mua-normal-pinktoblue Image Drawable)

    (let* ((tmp 0)(tmp2 0)(BlueNormal 0)(Red 0)(Green 0)(Blue 0)(Alpha 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

    (define tmp (plug-in-decompose 1 Image Drawable "RGBA" 0))

    (set! Blue (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp) )) Image) ))
    (set! Green (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadr tmp) )) Image) ))
    (set! Alpha (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (caddr tmp) )) Image) ))
    (set! Red (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadddr tmp) )) Image) ))

    (define tmp2 (plug-in-drawable-compose 1 Image Red Green Blue Alpha "RGBA"))

    (set! BlueNormal (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name BlueNormal "Normal")
    (gimp-image-insert-layer Image BlueNormal 0 -1)

    (gimp-item-set-visible Drawable 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-normal-pinktoblue"
    "MUA Normal Map Pink to Blue"
    "Convert a (PSP?) normal map texture (pinkish) to standard (blueish), by adding the blue to the normal channel. Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "March 2023"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normal-pinktoblue" "<Image>/Script-Fu")