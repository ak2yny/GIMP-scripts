; Export each layer as PNG, including visible layers.
; Adapted from scripts by Niels Giesen (2008) and alphapapa (2019)
; SF-FILENAME     "path"        "/"

(define (script-fu-save-layers-with-visible image group path)

  (gimp-image-undo-group-start image)

  (let loop ((layers (vector->list (cadr (gimp-item-get-children group)))))
    (unless (null? layers)
      (gimp-item-set-visible (car layers) 1)
      (let*
        (
          (new-name (string-append path "/" (car (gimp-item-get-name (car layers))) ".png"))
          (vis (car (gimp-layer-new-from-visible image image new-name)))
        )
          (file-png-save-defaults RUN-NONINTERACTIVE image vis new-name new-name)
        )
      (gimp-item-set-visible (car layers) 0)
      (loop (cdr layers))))

  (gimp-displays-flush)

  (gimp-image-undo-group-end image)

)

; populate script registration information
(script-fu-register "script-fu-save-layers-with-visible"
    "Export Layers, keep visible"
    "Export each layer in the group as PNG, while keeping active layers visible. Important: A layer GROUP must be selected."
    "ak2yny"
    "ak2yny"
    "October 2022"
    "*"
    SF-IMAGE        "Image"       0
    SF-DRAWABLE     "Group"       0
    SF-STRING       "Path"        "/"
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-save-layers-with-visible" "<Image>/Script-Fu")