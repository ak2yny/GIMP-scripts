; Normal map conversion from diffuse map
(define (script-fu-mua-norm2 Image Drawable)

    (let* ((Norm1 0)(Norm2 0)(grey 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Drawable)

    (set! grey (car (gimp-layer-copy Drawable 0)))
    (gimp-item-set-name grey "Specular")
    (gimp-image-insert-layer Image grey 0 -1)
    (gimp-drawable-desaturate grey 0)

    (gimp-item-set-visible Drawable 0)

    (set! Norm1 (car (gimp-layer-copy grey 0)))
    (gimp-item-set-name Norm1 "Normal")
    (gimp-image-insert-layer Image Norm1 0 -1)
    (plug-in-normalmap 1 Image Norm1 0 0.0 3.0 0 0 0 0 0 0 0 0 0.0 Norm1)

    (set! Norm2 (car (gimp-layer-copy grey 0)))
    (gimp-item-set-name Norm2 "Normal2")
    (gimp-image-insert-layer Image Norm2 0 -1)
    (plug-in-normalmap 1 Image Norm2 0 0.0 3.0 0 0 0 0 0 0 0 0 0.0 Norm2)
    (gimp-layer-set-mode Norm2 23)

    (gimp-item-set-visible grey 0)

    (set! Norm1 (car (gimp-image-merge-visible-layers Image 0)))

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)


        (gimp-image-undo-group-start Image)

    (gimp-drawable-brightness-contrast grey -0.5 0.1)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-norm2"
    "Normal Map for Editing 2"
    "Convert a diffuse map to a normal map. Adds it on a new layer and adds a suggested specular map."
    "ak2yny"
    "ak2yny"
    "May 2020"
    "RGB*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Drawable"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-norm2" "<Image>/Script-Fu")