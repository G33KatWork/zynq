#!/usr/bin/env python3

import numpy as np
import cv2

import sys

if __name__ == '__main__':
    capture = cv2.VideoCapture(0, cv2.CAP_V4L2)
    capture.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc('G', 'R', 'E', 'Y'))
    capture.set(cv2.CAP_PROP_FRAME_WIDTH, 752)
    capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

    while(True):
        r, image_data = capture.read()
        image_data = image_data[:,:,0]

        cv2.imshow('frame', image_data)
        key = cv2.waitKey(1)
        if key & 0xFF == ord('q'):
            break

    capture.release()
    cv2.destroyAllWindows()
