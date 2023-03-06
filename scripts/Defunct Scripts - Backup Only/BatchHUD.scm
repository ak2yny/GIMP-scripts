; https://www.gimp.org/tutorials/Basic_Batch/
; Must be run from console. Code currently doesn't work from console though.

(define (batch-HUD HUDtemplate
                   size
                   pattern)

(let* ((template (car (gimp-file-load RUN-NONINTERACTIVE HUDtemplate HUDtemplate)))  (copy 0))

  (let loop ((filelist (cadr (file-glob pattern 1))))
    (unless (null? filelist)
      (let*
        (
          (filename (car filelist))
          (hud (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
        )
        (gimp-image-insert-layer template hud 0 1)
        (gimp-layer-scale hud size size 0)
        (script-fu-mua-lblueLQa template hud)
        (let*
          (
            (new-name (string-append (substring filename 0 (- (string-length filename) 4)) "-" size ".png"))
            (vis (car (gimp-layer-new-from-visible template template "export")))
          )
          (file-png-save-defaults RUN-NONINTERACTIVE template vis new-name new-name)
        )
        (gimp-image-remove-layer template hud)
        (gimp-image-remove-layer template copy)
      )
    (loop (cdr filelist))))
    (gimp-image-delete template)
))
