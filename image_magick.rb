require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'pry-byebug'
require 'mini_magick'

array_mini = []
array_original = []

get '/' do
	erb :index
end

post '/' do
	image = MiniMagick::Image.open(params[:file][:tempfile].path)
	my_image_tretment = ImageTreatment.new
	array_original.push(my_image_tretment.save_image(image,params["file"][:filename]))
	array_mini.push(my_image_tretment.change_image)
	@image_with_changes = array_mini
	@original_image = array_original
	erb :show_images
end

class ImageTreatment
	def initialize()
		@original_images = []
		@changed_images = []
	end
	def save_image(image,name)
		@image = image
		@name = name
		@image.write 'public/'+@name
		@original_images.push(@name)
	end
	
	def change_image
		@image.resize "40x40"
		@image.format "jpg"
		@image.write "public/output_"+@name
		@changed_images.push("output_"+@name)
	end
end

