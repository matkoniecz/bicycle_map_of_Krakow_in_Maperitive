import Image

before_and_diff_image = Image.open("raw\\before.png")
after_image = Image.open("raw\\after.png")
x_image, y_image = before_and_diff_image.size
before_and_diff = before_and_diff_image.load()
after = after_image.load()

min_x = None
max_x = None
min_y = None
max_y = None

pixel_count = x_image * y_image
percentage = 0
for x in range(0, x_image):
    for y in range(0, y_image):
        while x*y*100/pixel_count > percentage:
            print str(percentage)
            percentage += 1
        change = 0
        for i in range(0, 3):
            change += abs(before_and_diff[x, y][i] - after[x, y][i])
        if change > 0:
            if min_x is None:
                min_x = x
                max_x = x
                min_y = y
                max_y = y
            min_x = min(min_x, x)
            max_x = max(max_x, x)
            min_y = min(min_y, y)
            max_y = max(max_y, y)
            before_and_diff[x, y] = (255, 0, 0)
        else:
            before_and_diff[x, y] = (255, 255, 255)

before_and_diff_image.save("raw\\diff.png")

#The box is a 4-tuple defining the left, upper, right, and lower pixel coordinate.
#The Python Imaging Library uses a Cartesian pixel coordinate system, with (0,0) in the upper left corner.
box = (max(0, min_x-10), max(0, min_y-10), min(x_image, max_x+10), min(y_image, max_y+10))

diff_image = before_and_diff_image.crop(box)
diff_image.save("diff_bb.png")
diff_image = Image.new("RGB", (1, 1), "white")
before_and_diff_image = Image.new("RGB", (1, 1), "white")

before_image = Image.open("raw\\before.png")
before_image = before_image.crop(box)
before_image.save("before_bb.png")
before_image = Image.new("RGB", (1, 1), "white")

after_image = after_image.crop(box)
after_image.save("after_bb.png")
after_image = Image.new("RGB", (1, 1), "white")

