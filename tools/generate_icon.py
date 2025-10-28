from PIL import Image, ImageDraw, ImageFont
import os

# Create a new image with a transparent background
size = (1024, 1024)
icon = Image.new('RGBA', size, (0, 0, 0, 0))
draw = ImageDraw.Draw(icon)

# Draw a purple circle
circle_radius = 460
circle_pos = (size[0] // 2, size[1] // 2)
circle_bbox = (circle_pos[0] - circle_radius, circle_pos[1] - circle_radius,
              circle_pos[0] + circle_radius, circle_pos[1] + circle_radius)
draw.ellipse(circle_bbox, fill='#673AB7')

# Draw a "+" symbol
plus_size = 400
line_width = 80
half_line = line_width // 2
plus_center = (size[0] // 2, size[1] // 2)

# Vertical line
draw.rectangle((plus_center[0] - half_line, plus_center[1] - plus_size//2,
               plus_center[0] + half_line, plus_center[1] + plus_size//2),
               fill='white')

# Horizontal line
draw.rectangle((plus_center[0] - plus_size//2, plus_center[1] - half_line,
               plus_center[0] + plus_size//2, plus_center[1] + half_line),
               fill='white')

# Save the icon
icon.save('app_icon.png')