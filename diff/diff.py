import Image
import ImageChops

before = Image.open("before.png")
after = Image.open("after.png")
x_image, y_image = before.size
pixels = before.load()
compared = after.load()
for x in range(0, x_image):
	for y in range(0, y_image):
		change = 0
		for i in range(0, 3):
			change += abs(pixels[x, y][i] - compared[x, y][i])
		if change > 0:
			pixels[x,y] = (255, 0, 0)
		else:
			pixels[x,y] = (255, 255, 255)

before.save("diff.png")