; Use a green/red texture map to create a monochrome red/white specular map.
; Red is reflection/white.
(define (script-fu-gr-to-spec image layer)

    (let* ((red 0)(green 0)(gr 0)(spec 0))

        (gimp-image-undo-group-start image)

    (set! gr (aref (cadr (gimp-image-get-layers image)) 0))
    (set! red (car (gimp-layer-copy gr 0)))
    (set! green (car (gimp-layer-copy gr 0)))
    (gimp-image-insert-layer image green 0 1)
    (gimp-image-insert-layer image red 0 2)

    (gimp-layer-add-alpha red)
    (plug-in-colortoalpha RUN-NONINTERACTIVE image red '(0 255 0))
    ; red at this point can be used as a colour mask
    (gimp-drawable-desaturate red 4)

    (gimp-layer-add-alpha green)
    (plug-in-colortoalpha RUN-NONINTERACTIVE image green '(255 0 0))
    (gimp-drawable-desaturate green 2)
    ; inverting might not be correct - need more test subjects
    (gimp-drawable-invert green 0)
    ; red (or both together as spec) could use some darkness as well:
    (gimp-drawable-brightness-contrast green -1 0)
    (gimp-drawable-brightness-contrast green -1 0)

    (define spec (car (gimp-image-merge-down image green 2)))
    (gimp-layer-flatten spec)
    (gimp-item-set-name spec "Specular")
    (gimp-item-set-visible gr FALSE)

    (gimp-displays-flush)

        (gimp-image-undo-group-end image)

    )

)

; populate script registration information
(script-fu-register "script-fu-gr-to-spec"
    "Red/Green to alpha mask"
    "Use a green/red texture map to create a monochrome red/white specular map."
    "ak2yny"
    "ak2yny"
    "March 2023"
    "*"
    SF-IMAGE        "Image"       0
    SF-DRAWABLE     "Layer"       0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-gr-to-spec" "<Image>/Script-Fu")