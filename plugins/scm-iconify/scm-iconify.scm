#!/usr/bin/env gimp-script-fu-interpreter-3.0

;Iconify.scm
;===========================
;Author...Giuseppe Bilotta
;Modified for Gimp 2.4.6+ by Ouch67
;http://www.gimptalk.com/forum/broken-scripts-t33501.html
;Resubmission to Gimp Plugin Registry & GimpTalk by Gargy
;Modified for Gimp 2.8 by Roland Clobus
;Modified for Gimp 3.0 by ak2yny + to add support up to 1024
;------------
;Description...: Iconify plug-in converts a single layer of a single image into a multi-layered image ready to be saved as a Windows icon.
;The new image will contain all standard sizes (16x16, 32x32, 48x48) at all standard bit depths (16 colors, 256 colors, 32-bit RGBA), with transparency support.
;The new image will also contain a big version (256x256 32-bit RGBA)
;===========================
;
; Note: This script has been modified accordingly with the changes stated here: http://www.aqua-soft.org/forum/topic/40999-iconify-plug-in-for-the-gimp/
;
; It converts an image into a Windows/Macintosh icon
(define (script-fu-iconify img drawables)
(script-fu-use-v3)
; Create a new image. It's also easy to add
; 128x128 Macintosh icons, or other sizes
(let* (
    (new-img (gimp-image-new 256 256 0))
    (work-layer 0)
    (big-layer 0)
    (layer-x 0)
    (layer-y 0)
    (max-dim 0)
    (temp-layer 0)

    (temp-img 0)
    (layers 0)
    (layernum 0)
    (layers-array 0)
    (layer 0)
    (eigth-bit 0)
    (four-bit 0)
    )
(gimp-item-set-name new-img (gimp-image-get-name img))

; Create a new layer
(set! work-layer (gimp-layer-new-from-drawable (vector-ref drawables 0) new-img))

; Give it a name
(gimp-item-set-name work-layer "Work layer")

; Add the new layer to the new image
(gimp-image-insert-layer new-img work-layer 0)

; Autocrop the layer
(gimp-image-autocrop new-img work-layer)
; (plug-in-zealouscrop 1 new-img work-layer)

; Now, resize the layer so that it is square,
; by making the shorter dimension the same as
; the longer one. The layer content is centered.
(set! layer-x (gimp-drawable-get-width work-layer))
(set! layer-y (gimp-drawable-get-height work-layer))
(set! max-dim (max layer-x layer-y))
(gimp-layer-resize work-layer max-dim max-dim (/ (- max-dim layer-x) 2) (/ (- max-dim layer-y) 2))

; Move the layer to the origin of the image
(gimp-layer-set-offsets work-layer 0 0)

; Now, we create as many layers as needed, resizing to
; 16x16, 32x32, 48x48, 128x128, 256x256, 512x512, 1024x1024

(define (resize-to-dim dim)
    (unless (< max-dim dim)
        (set! temp-layer (gimp-layer-copy work-layer 0))
        (gimp-item-set-name temp-layer "icon")
        (gimp-image-insert-layer new-img temp-layer 0)
        (gimp-item-transform-scale temp-layer 0 0 dim dim)
        ))

(for-each (lambda (dim) (resize-to-dim dim)) '(16 32 48 64 72 96 128 256 512 1024))

; Create the big layer, but do not add it yet
; (set! big-layer (gimp-layer-copy work-layer 0))
; (gimp-item-set-name big-layer "Big")

; We can now get rid of the working layer and fit the image to the layers
(gimp-image-remove-layer new-img work-layer)
(gimp-image-resize-to-layers new-img)

; We add the 256 layer
; (gimp-image-insert-layer new-img big-layer 0)
; (gimp-drawable-transform-scale big-layer 0 0 256 256 0 2 1 3 0)

; These two functions allow us to create new layers which are
; clones of the existing ones but at different color depths.
; We have to use two functions and pass through intermediate
; images because otherwise the second color reduction would dupe
; the layers, thus giving an unneeded extra set of layers
; TODO a potential study should be done on whether it's better
; to go straight to the lowest number of color (as we do), or
; passing through intermediate number of colors.
; Observe that no dithering is done. This is intentional, since
; it gives the best results.
; (define (palettize-image num)
;   (set! temp-img (gimp-image-duplicate new-img))
;   (gimp-image-convert-indexed temp-img 0 0 num TRUE TRUE "")
;   temp-img)
; (define (plop-image temp-img)
;   (set! layers (gimp-image-get-layers temp-img))
;   (set! layernum (car layers))
;   (set! layers-array (cadr layers))
;   (while (> layernum 0)
;       (set! layer
;           (gimp-layer-new-from-drawable
;               (aref layers-array (- layernum 1))
;               new-img))
;       (gimp-image-insert-layer new-img layer 0)
;       (set! layernum (- layernum 1)))
;   (gimp-image-delete temp-img))

; The 256 color image
; (set! eigth-bit (palettize-image 256))
; RC: Use 15 instead of 16 for the transparency
; (set! four-bit (palettize-image 15))

; Now we put the new layers back in the original image
; (plop-image eigth-bit)
; (plop-image four-bit)

; We display the new image
(gimp-display-new new-img)

; We save the icon
(file-ico-export RUN-NONINTERACTIVE new-img (string-append (gimp-image-get-file img) ".ico"))

; And we flush the display
(gimp-displays-flush)
))

; TODO the plugin currently only works with truecolor images
; it could be extended to work with palettized images, thus only creating
; layers for depths up to the current image depth
(script-fu-register-filter "script-fu-iconify"
    "Iconify"
    "Use the current layer of the current image to create a multi-sized, multi-depth Windows icon file"
    "Giuseppe Bilotta, Roland Clobus for gimp 2.8+, ak2yny for gimp 3"
    "Giuseppe Bilotta, Roland Clobus for gimp 2.8+, ak2yny for gimp 3"
    "20250720"
    "*"
    SF-ONE-DRAWABLE
)

; register the script within gimp menu
(script-fu-menu-register "script-fu-iconify" "<Image>/Script-Fu")