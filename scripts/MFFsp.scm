; Marvel Future Fight specular map extraction
(define (script-fu-mff-specular Image Drawable)

    (let* ((tmp 0)(tmp2 0)(maps 0)(Spec 0)(SpecAlt 0)(AO 0)(Alpha 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

    (define tmp (plug-in-decompose 1 Image Drawable "RGBA" 0))

    ; Red
    (set! Spec (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp) )) Image) ))
    ; Green
    (set! SpecAlt (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadr tmp) )) Image) ))
    ; Blue
    (set! AO (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (caddr tmp) )) Image) ))
    (set! Alpha (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (cadddr tmp) )) Image) ))

    (define tmp2 (plug-in-drawable-compose 1 Image Spec Spec Spec Alpha "RGBA"))
    (set! maps (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name maps "Spec")
    (gimp-image-insert-layer Image maps 0 -1)

    (define tmp2 (plug-in-drawable-compose 1 Image SpecAlt SpecAlt SpecAlt Alpha "RGBA"))
    (set! maps (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name maps "SpecAlt")
    (gimp-image-insert-layer Image maps 0 -1)

    (define tmp2 (plug-in-drawable-compose 1 Image AO AO AO Alpha "RGBA"))
    (set! maps (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name maps "AO")
    (gimp-image-insert-layer Image maps 0 -1)

    (gimp-item-set-visible Drawable 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mff-specular"
    "MFF Split Specular Map"
    "Extract specular and ambient oclusion maps from Marvel Future Fight _sp textures."
    "ak2yny"
    "ak2yny"
    "July 2024"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mff-specular" "<Image>/Script-Fu")