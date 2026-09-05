#!/usr/bin/env python3
"""Regenerates assets/icon/*.png — the Hitch Post placeholder mark:
a trail signpost over a ball hitch on forest green #2F5D3A.
Run from the repo root, then `dart run flutter_launcher_icons`."""
from PIL import Image, ImageDraw

GREEN = (47, 93, 58, 255)
WHITE = (255, 255, 255, 255)
CREAM = (240, 236, 224, 255)

def draw_glyph(d, s, ox=0, oy=0):
    def R(x0, y0, x1, y1, r, fill):
        d.rounded_rectangle([ox+x0*s, oy+y0*s, ox+x1*s, oy+y1*s], radius=r*s, fill=fill)
    R(0.47, 0.16, 0.53, 0.74, 0.02, WHITE)
    d.polygon([(ox+0.28*s, oy+0.24*s), (ox+0.66*s, oy+0.24*s),
               (ox+0.74*s, oy+0.30*s), (ox+0.66*s, oy+0.36*s),
               (ox+0.28*s, oy+0.36*s)], fill=WHITE)
    d.polygon([(ox+0.72*s, oy+0.42*s), (ox+0.34*s, oy+0.42*s),
               (ox+0.26*s, oy+0.48*s), (ox+0.34*s, oy+0.54*s),
               (ox+0.72*s, oy+0.54*s)], fill=CREAM)
    d.ellipse([ox+0.42*s, oy+0.70*s, ox+0.58*s, oy+0.86*s], fill=WHITE)
    R(0.38, 0.84, 0.62, 0.88, 0.02, WHITE)

img = Image.new('RGBA', (1024, 1024), GREEN)
draw_glyph(ImageDraw.Draw(img), 1024)
img.save('assets/icon/icon.png')

fg = Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))
draw_glyph(ImageDraw.Draw(fg), 640, ox=192, oy=192)
fg.save('assets/icon/icon_foreground.png')
print('icons written')
