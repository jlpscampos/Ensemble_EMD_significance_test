import os
import operator
from PIL import Image
from PIL import ImageDraw

base='tmp'
#fig_list = []
images = []
for i in range(12,0,-1):
    fig_list = os.path.join(base,'%d.png'%(i))
    images.append(Image.open(fig_list))

for i in range(1,len(images)):

    shift = (0,i*600)
    if i == 1:
        blendedimage = images[0]
    
    nw, nh = map(max, map(operator.add, images[i].size, shift), blendedimage.size)
        
    newimage1 = Image.new('RGBA',size = (nw,nh), color=(0,0,0,0))
    newimage2 = Image.new('RGBA',size = (nw,nh), color=(0,0,0,0))
    
    newimage1.paste(images[i], shift)
    newimage1.paste(blendedimage, (0,0))

    newimage2.paste(blendedimage,(0,0))
    newimage2.paste(images[i], shift)
    
    blendedimage = Image.alpha_composite(newimage1, newimage2)

file = os.path.join(base,'all.png')
blendedimage.save(file)



'''
#for i in range(0,len(fig_list)):
#    images += [Image.open(x) for x in fig_list]
images.append(Image.open(fig_list[0]))
images.append(Image.open(fig_list[1]))

shift = (0,500)

nw, nh = map(max, map(operator.add, images[1].size, shift), images[0].size)

# paste img1 on top of img2
newimage1 = Image.new('RGBA',size=(nw,nh), color=(0,0,0,0))

newimage1.paste(images[1], shift)
newimage1.paste(images[0], (0,0))

# paste img2 in top of img1
newimage2 = Image.new('RGBA',size=(nw, nh), color=(0,0,0,0))
newimage2.paste(images[0],(0,0))
newimage2.paste(images[1], shift)

# Blend Images
result = Image.alpha_composite(newimage1, newimage2)
file = base+'test.png'
result.save(file)

'''