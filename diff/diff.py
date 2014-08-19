import Image
import sys

def load_images():
    global before_image
    global after_image
    global diff_image
    global before
    global after
    global diff
    global x_image
    global y_image
    before_image = Image.open("raw\\before.png")
    after_image = Image.open("raw\\after.png")
    before = before_image.load()
    after = after_image.load()
    x_image, y_image = before_image.size
    diff_image = Image.new("RGB", (x_image, y_image), "white")
    diff = diff_image.load()


def iterate():
    global before_image
    global after_image
    global diff_image
    global before
    global after
    global diff
    global l
    print '.'*100
    l = []
    pixel_count = x_image * y_image
    percentage = 0
    for x in range(0, x_image):
        for y in range(0, y_image):
            while 100*x*y/pixel_count > percentage:
                sys.stdout.write('.')
                percentage += 1
            change = 0
            for i in range(0, 3):
                change += abs(before[x, y][i] - after[x, y][i])
            if change > 0:
                diff[x, y] = (255, 0, 0)
                l = add_pixel(l, x, y)


def add_pixel(l, x, y):
    margin = 10
    opt = None
    index = None
    for i, bb in enumerate(l):
        x_min, y_min, x_max, y_max = bb
        expansion = 0
        expansion += max(0, x_min - x + margin)
        expansion += max(0, x + margin - x_max)
        expansion += max(0, y_min - y + margin)
        expansion += max(0, y + margin - y_max)
        if opt is None or opt > expansion:
            opt = expansion
            index = i
    if opt is None or opt > 50:
        l.append((x-margin, y-margin, x+margin, y+margin))
    else:
        bb = l[index]
        x_min, y_min, x_max, y_max = bb
        l[index] = (min(x - margin, x_min), min(y - margin, y_min), max(x + margin, x_max), max(y + margin, y_max))
    return l


def save():
    global before_image
    global after_image
    global diff_image
    global before
    global after
    global diff
    global l
    diff_image.save("raw\\diff.png")

    print ""
    for i, bb in enumerate(l):
        margin = 75
        x_min, y_min, x_max, y_max = bb
        #The box is a 4-tuple defining the left, upper, right, and lower pixel coordinate.
        #The Python Imaging Library uses a Cartesian pixel coordinate system, with (0,0) in the upper left corner.
        box = (max(0, x_min-margin), max(0, y_min-margin), min(x_image, x_max+margin), min(y_image, y_max+margin))
        diff_image_cropped = diff_image.crop(box)
        diff_image_cropped.save(str(i) + " diff_bb.png")

        before_image_cropped = before_image.crop(box)
        before_image_cropped.save(str(i) + " before_bb.png")

        after_image_cropped = after_image.crop(box)
        after_image_cropped.save(str(i) + " after_bb.png")

        print str(i)
        print (x_min + x_max)/2, (y_min + y_max)/2
        print str(100*(x_min + x_max)/2/x_image) + "%, " + str(100*(y_min + y_max)/2/y_image) + "%"
        print ""

load_images()
iterate()
save()
