import os
import numpy as np
from PIL import Image, ImageDraw
from shutil import copyfile

#psd = Image.open('/Users/ipdesign/Downloads/ObjectSearch-1FC~D_F.psd')
#print (psd.image_resources)

#paths = \(rawImagePaths)
#tmpPath = \(tmpPath)
for path in paths:
    fileName = path.split("/")[-1]
    fileTitle = fileName.split(".")[0]
    fileFormat = fileName.split(".")[-1]
    if fileFormat != "psd" or fileFormat != "PSD":
        copyfile(path, tmpPath + fileName)
    else:
        im = Image.open(original_file_path)
        img.save(tmpPath + fileTitle + ".png") 
        im.close()


