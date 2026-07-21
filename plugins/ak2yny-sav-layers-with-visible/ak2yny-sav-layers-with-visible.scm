#!/usr/bin/env gimp-script-fu-interpreter-3.0

; Export each layer as PNG, including visible layers.
; Adapted from scripts by Niels Giesen (2008) and alphapapa (2019)
; SF-FILENAME     "path"        "/"

(define (script-fu-save-layers-with-visible image drawables path)
    (script-fu-use-v3)

    (let ((group (vector-ref drawables 0)))

    (gimp-image-undo-group-start image)

    (let loop ((layers (vector->list (gimp-item-get-children group))))
        (unless (null? layers)
        (gimp-item-set-visible (car layers) 1)
        (let*(
            (file-path (string-append path "/" (gimp-item-get-name (car layers)) ".png"))
            (vis (gimp-layer-new-from-visible image image file-path))
            )
            (file-png-export RUN-NONINTERACTIVE image file-path)
        )
        (gimp-item-set-visible (car layers) 0)
        (loop (cdr layers))))

    (gimp-displays-flush)

    (gimp-image-undo-group-end image)

    )
)

; populate script registration information
(script-fu-register-filter "script-fu-save-layers-with-visible"
    "Export Layers, keep visible"
    "Export each layer in the group as PNG, while keeping active layers visible. Important: A layer GROUP must be selected."
    "ak2yny"
    "ak2yny"
    "October 2022 - September 2025"
    "*"
    SF-ONE-DRAWABLE
    SF-STRING       "Path"        "/"
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-save-layers-with-visible" "<Image>/Script-Fu")