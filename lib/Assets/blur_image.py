from PIL import Image, ImageFilter

# Load the original image
original_image = Image.open("Images/2.jpg")

# Apply a blur filter
blurred_image = original_image.filter(ImageFilter.BLUR)

# Save the blurred image
blurred_image.save("Images/3.png")

# Print a success message
print("The image has been blurred and saved as your_blurred_image_filename.png")