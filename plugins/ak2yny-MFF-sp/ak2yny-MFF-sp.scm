#!/usr/bin/env gimp-script-fu-interpreter-3.0

; Marvel Future Fight specular map extraction
; In script-fu-interpreter-3.0, return values (vector or value) changed, as well as whether vectors or values can be used as arguments

(define (script-fu-mff-specular Image Drawables)
    (script-fu-use-v3)

    (let* ((Drawable (vector-ref Drawables 0)))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

        (let* (
            (tmp (car (plug-in-decompose 1 Image Drawables "rgba" 1)))
            (Spec (gimp-image-get-layer-by-name tmp "red"))
            (SpecAlt (gimp-image-get-layer-by-name tmp "green"))
            (AO (gimp-image-get-layer-by-name tmp "blue"))
            (Alpha (gimp-image-get-layer-by-name tmp "alpha"))
            )

        (define tmp2 (plug-in-drawable-compose 1 tmp (vector Spec) Spec Spec Alpha "rgba"))
        (define spec (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) Image))
        (gimp-item-set-name spec "Spec")
        (gimp-image-insert-layer Image spec 0 -1)

        (define tmp2 (plug-in-drawable-compose 1 tmp (vector SpecAlt) SpecAlt SpecAlt Alpha "rgba"))
        (define spec_alt (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) Image))
        (gimp-item-set-name spec_alt "SpecAlt")
        (gimp-image-insert-layer Image spec_alt 0 -1)

        (define tmp2 (plug-in-drawable-compose 1 tmp (vector AO) AO AO Alpha "rgba"))
        (define ao (gimp-layer-new-from-drawable (vector-ref (gimp-image-get-layers tmp2) 0) Image))
        (gimp-item-set-name ao "AO")
        (gimp-image-insert-layer Image ao 0 -1)

        (gimp-image-delete tmp)
        (gimp-image-delete tmp2)

        )

    (gimp-item-set-visible Drawable FALSE)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register-filter "script-fu-mff-specular"
    "MFF Split Specular Map"
    "Extract specular and ambient oclusion maps from Marvel Future Fight _sp textures."
    "ak2yny"
    "ak2yny"
    "April 2025"
    "RGB*"
    SF-ONE-DRAWABLE
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mff-specular" "<Image>/Script-Fu")