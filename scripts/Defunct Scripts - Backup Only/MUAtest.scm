; Test Codes
(define (script-fu-mua-test Image Layer)

    (let* ((Norm1 0)(Norm2 0)(Norm3 0)(Norm4 0)(grey 0)(tmp 0)(tmp2 0)(map 0)(Green 0)(Black 0)(Alpha 0))

        (gimp-image-undo-group-start Image)

    (set! grey (car (gimp-layer-copy Layer 0)))
    (gimp-item-set-name grey "Specular")
    (gimp-image-insert-layer Image grey 0 -1)
    (gimp-drawable-desaturate grey 0)

    (gimp-item-set-visible Layer 0)

    (set! Norm1 (car (gimp-layer-copy grey 0)))
    (gimp-item-set-name Norm1 "Normal")
    (gimp-image-insert-layer Image Norm1 0 -1)
    (plug-in-normalmap 1 Image Norm1 0 0.0 1.0 0 0 0 1 0 0 0 0 0.0 Norm1)

    (set! Norm2 (car (gimp-layer-copy grey 0)))
    (gimp-item-set-name Norm2 "Normal2")
    (gimp-image-insert-layer Image Norm2 0 -1)
    (plug-in-normalmap 1 Image Norm2 0 0.0 3.0 0 0 0 1 0 0 0 0 0.0 Norm2)
    (gimp-layer-set-mode Norm2 23)

    (set! Norm3 (car (gimp-layer-copy grey 0)))
    (gimp-item-set-name Norm3 "Normal3")
    (gimp-image-insert-layer Image Norm3 0 -1)
    (plug-in-normalmap 1 Image Norm3 0 0.0 6.0 0 0 0 1 0 0 0 0 0.0 Norm3)
    (gimp-layer-set-mode Norm3 23)

    (set! Norm4 (car (gimp-layer-copy grey 0)))
    (gimp-item-set-name Norm4 "Normal4")
    (gimp-image-insert-layer Image Norm4 0 -1)
    (plug-in-normalmap 1 Image Norm4 0 0.0 9.0 0 0 0 1 0 0 0 0 0.0 Norm4)
    (gimp-layer-set-mode Norm4 23)

    (gimp-item-set-visible grey 0)

    (set! Norm1 (car (gimp-image-merge-visible-layers Image 0)))

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)


        (gimp-image-undo-group-start Image)

    (define tmp (plug-in-decompose 1 Image Norm1 "RGBA" 0))

    (gimp-context-set-foreground '(0 0 0))
    (set! Black (car (gimp-layer-new Image (car (gimp-image-width Image)) (car (gimp-image-height Image)) 2 "Red&Blue" 100 0)))
    (set! Green (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car (cdr tmp)) )) Image) ))
    (set! Alpha (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp) )) Image) ))

    (define tmp2 (plug-in-drawable-compose 1 Image Black Green Black Alpha "RGBA"))

    (set! map (car (gimp-layer-new-from-drawable (car ( gimp-image-get-active-layer (car tmp2) )) Image) ))
    (gimp-item-set-name map "MUA-Normal")
    (gimp-image-insert-layer Image map 0 -1)

    (gimp-item-set-visible Norm1 0)

    (gimp-displays-flush)

        (gimp-image-undo-group-end Image)

    )

)

; populate script registration information
(script-fu-register "script-fu-mua-test"
    "Test Codes"
    "For testing only."
    "ak2yny"
    "ak2yny"
    "2020"
    "*"
    SF-IMAGE        "Image"                           0
    SF-DRAWABLE     "Layer"                           0
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-mua-test" "<Image>/Script-Fu")