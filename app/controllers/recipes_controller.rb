class RecipesController < ApplicationController
	before_action :find_recipe, only: [:show,:edit,:update,:destroy]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@recipes = Recipe.all.order('created_at DESC')		
		@recipes = Recipe.all
	end
	def show
		@recipe = Recipe.find(params[:id])
		@recipes = Recipe.all
		@ingredients = Ingredient.all
		@directions = Direction.all
		# @description = Description.all
	end


	def new
		@recipe = current_user.recipes.build
		@ingredient = @recipe.ingredients.build
		@direction = @recipe.directions.build		
	end

	def create
		@recipe = current_user.recipes.build(recipe_params)
		if @recipe.save
			redirect_to @recipe  
			 flash[:notice] = "Successfully created new recipe!"
		else
			render 'new'
		end
	end

	

	def edit
		@recipe = Recipe.find(params[:id])
	end

	def update
		puts "PARAMS!!!!"
		puts recipe_params
		if @recipe.update(recipe_params)
			redirect_to @recipe
			puts "UPDATED!!!!!"
		else
			render 'edit'
		end
	end

	def destroy
		@recipe.destroy
		flash[:notice] = "recipe successfully deleted"
		redirect_to root_path  
	end

	def mail
		puts "EMAIL HERE"
		puts params
		recipe = Recipe.find(params[:recipe_id])
		from = params[:email_from]
		to = params[:email_to]
		subject = params[:subject]

		html = "<html><h1>Hi <strong> #{to} </strong>, how are you? check this recipe out</h1> <br/> <ul>"
			html+= "<li> <h4>INGREDIENTS</h4></li>"
		recipe.ingredients.each do | i |
			html+= "<li> #{i.name} </li>"
		end

		html+= "</ul><br/><ul>"
		html+= "<li><h4>DIRECTIONS</h4></li>"
		recipe.directions.each do | d |
			html+= "<li> #{d.step} </li>"
		end
	
		
		html+= "</ul><br/> <h1> Enjoy Cooking!</h1></html>"
		img= recipe.image.path
			f = File.read(img)
			@enc_image = Base64.encode64(f)

		require 'mandrill'
		msg = Mandrill::API.new
		message = {
			:subject=> subject,
			:from_name=> from,
			:text=> params[:directions],
			:to=> [{:email=> to }],
			:html=> html,
			:attachments => [{"content" => @enc_image, "type" => "image/jpg", "name" => "recipe"}],
			:from_email=> from
		}
		sending = msg.messages.send message 
		puts sending
		redirect_to root_path
	end

private
	
	def recipe_params
		params.require(:recipe).permit(:title, :description, :image, ingredients_attributes: [:id, :name, :_destroy],
						directions_attributes: [:id, :step, :_destroy])				
	end

	def find_recipe
		@recipe = Recipe.find(params[:id])
	end

end
