; Marvel Ultimate Alliance (1) specular map creation from diffuse
(define (script-fu-mua-spec Image Layer)

    (let* ((grey 0))

        (gimp-image-undo-group-start Image)

    (gimp-layer-add-alpha Layer)

    (set! grey (car (gimp-layer-copy Layer 0)))
    (gimp-item-set-name grey "Specular")
    (gimp-image-insert-layer Image grey 0 -1)
    (gimp-drawable-desaturate grey 0)

    (gimp-item-set-visible Layer 0)

    (gimp-drawable-brightness-contrast grey -0.5 0.1)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)


        (gimp-image-undo-group-start Image)

    (gimp-image-scale Image 256 256)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-spec"
    "MUA Specular Helper"
    "Converts a Diffuse map texture into a dark grayscale picture to be further edited and used as a Specular map for Marvel Ultimate Alliance 2006. Adds an additional layer. Undo once to get back to the original size."
    "ak2yny"
    "ak2yny"
    "April 2020"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Layer"                        0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-spec" "<Image>/Script-Fu")