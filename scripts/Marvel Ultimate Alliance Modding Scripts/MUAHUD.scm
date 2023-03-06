; Marvel Ultimate Alliance (1) hud quick finish
(define (script-fu-mua-export image layer)
  (gimp-selection-none image)
  (let* 
    ( (hud (car (gimp-layer-new-from-visible image image "HUD"))))
    (gimp-image-add-layer image hud 0)
  )
  (set! layer (car (gimp-image-get-active-layer image)))
  (plug-in-colors-channel-mixer RUN-NONINTERACTIVE image layer FALSE 0 0 1 0 1 0 1 0 0)
  (gimp-item-transform-flip-simple layer ORIENTATION-VERTICAL TRUE 0)
  (gimp-displays-flush)
)

; populate script registration information
(script-fu-register "script-fu-mua-export"
    "MUA HUD Colorflip"
    "Flip and colour-swap (RGB>BGR) visible layers for Marvel Ultimate Alliance (HUDs and more). Creates a new layer called HUD."
    "ak2yny"
    "ak2yny"
    "October 2019"
    "*"
    SF-IMAGE        "Image"       0
    SF-DRAWABLE     "Layer"       0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-export" "<Image>/Script-Fu")