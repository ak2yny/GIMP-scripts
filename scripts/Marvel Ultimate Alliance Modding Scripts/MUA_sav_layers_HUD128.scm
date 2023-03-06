; Export each layer as PNG, including visible layers.
; Adapted from scripts by Niels Giesen (2008) and alphapapa (2019)
; SF-FILENAME     "path"        "/"

(define (script-fu-save-layers-hud128 image group path)

(let* ((outline 0))

  (gimp-image-undo-group-start image)

  (let loop ((layers (vector->list (cadr (gimp-item-get-children group)))))
    (unless (null? layers)
      (gimp-item-set-visible (car layers) 1)
      
      (gimp-image-select-item image 0 (car layers))
      (set! outline (car (gimp-layer-copy (car layers) TRUE)))
      (gimp-image-insert-layer image outline 0 (+ (car (gimp-image-get-item-position image group)) 1))
      (gimp-selection-grow image 2)
      (gimp-selection-feather image 7)
      (gimp-context-set-foreground '(120 210 255))
      (gimp-drawable-edit-fill outline FILL-FOREGROUND)
      (gimp-selection-none image)
      
      (let*
        (
          (new-name (string-append path "/" (car (gimp-item-get-name (car layers))) ".png"))
          (vis (car (gimp-layer-new-from-visible image image new-name)))
        )
          (file-png-save-defaults RUN-NONINTERACTIVE image vis new-name new-name)
        )
      (gimp-image-remove-layer image outline)
      (gimp-item-set-visible (car layers) 0)
      (loop (cdr layers))))

  (gimp-displays-flush)

  (gimp-image-undo-group-end image)

))

; populate script registration information
(script-fu-register "script-fu-save-layers-hud128"
    "Export Layers, HUD 128"
    "Export each layer in the group as PNG, while keeping active layers visible. Important: A layer GROUP must be selected."
    "ak2yny"
    "ak2yny"
    "November 2022"
    "*"
    SF-IMAGE        "Image"       0
    SF-DRAWABLE     "Group"       0
    SF-STRING       "Path"        "/"
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-save-layers-hud128" "<Image>/Script-Fu")