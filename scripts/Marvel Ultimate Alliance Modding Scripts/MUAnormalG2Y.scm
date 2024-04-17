; Marvel Ultimate Alliance normal map conversion Green to Yellow
(define (script-fu-mua-normalg2y Image Drawable)

    (let* ((tmp 0)(tmp2 0)(nmap 0)(Red 0)(Green 0)(Black 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

    (define tmp (plug-in-decompose 1 Image Drawable "RGBA" 0))

    ; Green
    (set! Red (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadr tmp) )) Image) ))
    ; Alpha
    (set! Green (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadddr tmp) )) Image) ))
    (set! Black (car (gimp-layer-new Image (car (gimp-image-width Image)) (car (gimp-image-height Image)) 2 "Blue" 100 0)))

    (define tmp2 (plug-in-drawable-compose 1 Image Red Green Black Black "RGB"))

    (set! nmap (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name nmap "DXT5nm")
    (gimp-image-insert-layer Image nmap 0 -1)
    (gimp-layer-add-alpha nmap)

    (gimp-item-set-visible Drawable 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-normalg2y"
    "MUA Normal Map Conversion (Green to Yellow)"
    "Convert a MUA 2006 normal map texture (greenish) to DXN (yellowish) for Marvel Ultimate Alliance 2016 (Steam). Adds it on a new Layer."
    "ak2yny"
    "ak2yny"
    "April 2024"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-normalg2y" "<Image>/Script-Fu")