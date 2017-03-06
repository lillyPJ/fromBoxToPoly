
import glob
import numpy as np
import cv2
#from pylab import *
import os

import matplotlib.pyplot as plt

def displayBoxes(boxes, color = 'r', lineWidth = 2):
    currentAxis = plt.gca()
    for each in boxes:
        coords = (each[0], each[1]), each[2], each[3]
        currentAxis.add_patch(plt.Rectangle(*coords, fill=False, edgecolor=color, linewidth = lineWidth))

def displayMinAreaBoxes(minBoxes, img):
    for each in minBoxes:
        box = cv2.cv.BoxPoints(each)
        box = np.int0(box)
        cv2.drawContours(img, [box], 0, (255,0,0), 4)
    plt.imshow(img)

dataBaseDir = '/home/lili/codes/ssd/caffe-ssd/data/MSRATD500'
sourceDtDir = '{}/test_bb_big'.format(dataBaseDir)
destDtDir = '{}/test_poly'.format(dataBaseDir)
imgDir = '/home/lili/datasets/MSRATD500/img/test'

imgFiles = glob.glob('{}/*.jpg'.format(imgDir))
for eachImg in imgFiles:
    print eachImg
    # -------files-------
    fileName = os.path.splitext(os.path.basename(eachImg))[0]
    sourceDtFile = '{}/res_{}.txt'.format(sourceDtDir, fileName)
    with open(sourceDtFile, 'r') as f:
        sourceDtBox = f.readlines()
    # -------read boxes from sourceDtBox-------
    points = []
    rectBoxes = [] # x, y, w, h
    minAreaBoxes = [] # (x1, y1), (x2, y2), angle
    for eachBox in sourceDtBox:
        eachItem = eachBox.split(',') # x1, y1, x2, y2, score
        point4 = np.array([int(x) for x in eachItem[0:4]])
        # [x1, y1, x2, y2] --> [x1, y1, x1, y2, x2, y2, x2, y1]
        point8 = np.array([point4[0], point4[1], point4[0], point4[3],
                           point4[2], point4[3], point4[2], point4[1]])
        point8 = point8.reshape([4, 1, 2])
        #points.append(point4)
        tempbox = cv2.boundingRect(point8)
        # if not tempbox:
        #     tempbox[:, 2] = tempbox[:, 2] - tempbox[:, 0]
        #     tempbox[:, 3] = tempbox[:, 3] - tempbox[:, 1]
        rectBoxes.append(tempbox)
        tempbox = cv2.minAreaRect(point8)
        minAreaBoxes.append(tempbox)
    # show image, boxes
    img = cv2.imread(eachImg)

    # -------display image and rectBox-------
    # plt.imshow(img)
    # displayBoxes(rectBoxes)
    # plt.show()

    # -------display minAreaBox and image-------
    #displayMinAreaBoxes(minAreaBoxes, img)

    # -------crop patch, find contour, draw minAreaBox of contour-------
    for eachBox in rectBoxes:
        box = list(eachBox)
        box[2] = box[2] + box[0]
        box[3] = box[3] + box[1]
        # crop image
        cropImg = img[box[1]:box[3], box[0]:box[2]]
        # gray, bw
        grayImg = cv2.cvtColor(cropImg, cv2.COLOR_BGR2GRAY)
        ret, binaryImg = cv2.threshold(grayImg, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)

        plt.imshow(binaryImg)
        plt.show()

        # morphologyEx, dialate
        kernel = np.ones((3, 3), np.uint8)
        openingImg = cv2.morphologyEx(binaryImg, cv2.MORPH_CLOSE, kernel, iterations=3)
        # dialateImg = cv2.dilate(openingImg, kernel, iterations=5)

        plt.imshow(openingImg)
        plt.show()

        # find contours
        contours, hierarchy = cv2.findContours(binaryImg, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        cnt = contours[0]

        # draw rotated rectangle
        rect = cv2.minAreaRect(cnt)

        box = cv2.cv.BoxPoints(rect)
        box = np.int0(box)
        cv2.drawContours(cropImg, [box], 0, (255, 0, 0), 4)
        plt.imshow(cropImg)
        plt.show()
        print 'ok'

    # cv2.imshow('crop_img', crop_img)
    #cv2.imshow(crop_img)
    # NOTE: its img[y: y + h, x: x + w] and *not* img[x: x + w, y: y + h]







