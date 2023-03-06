; Marvel Ultimate Alliance (1) normal map conversion
(define (script-fu-mua-normal Image Drawable)

    (let* ((tmp 0)(tmp2 0)(map 0)(Green 0)(Black 0)(Alpha 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

    (define tmp (plug-in-decompose 1 Image Drawable "RGBA" 0))

    (set! Black (car (gimp-layer-new Image (car (gimp-image-width Image)) (car (gimp-image-height Image)) 2 "Red&Blue" 100 0)))
    (set! Green (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadr tmp) )) Image) ))
    (set! Alpha (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp) )) Image) ))

    (define tmp2 (plug-in-drawable-compose 1 Image Black Green Black Alpha "RGBA"))

    (set! map (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name map "DXT5nm")
    (gimp-image-insert-layer Image map 0 -1)

    (gimp-item-set-visible Drawable 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-normal"
    "MUA Normal Map Conversion"
    "Convert a normal map texture (blueish) to DXT5nm (greenish) for Marvel Ultimate Alliance 2006. Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "April 2020"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normal" "<Image>/Script-Fu")