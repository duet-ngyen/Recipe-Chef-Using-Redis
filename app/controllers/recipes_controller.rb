class RecipesController < ApplicationController
  before_action :load_recipe, except: [:index, :new, :show]
  before_action :create_database, only: [:index]

  def index
    @count = counter
  end

  def show
    @count = counter
    @recipe = ""
    all_recipes = $redis.smembers("recipes")
    all_recipes.each do |recipe|
      if params[:id] == $redis.hget(recipe, "id")
        @recipe = recipe
      end
    end
  end

  def new
    @count = counter
    $redis.hmset("recipe:test",:id, 6, :title, "test", :summary, "Demo Description")
    $redis.sadd("recipes", "recipe:test")
    # redirect_to recipes_path
  end

  private
  def load_recipe
    @recipe = Recipe.find_by params[:id]
  end

  # Create counter visited
  def counter
    $redis.incr(:counter)
  end

  def create_database
    # Create chefs
    $redis.hmset("chef:nguyen",:id, 1, :name, "Nguyen Huynh", :email, "nguyen@gmail.com")
    $redis.hmset("chef:nam", :id, 2, :name, "Nam Nguyen", :email, "nam@gmail.com")
    $redis.hmset("chef:hoang", :id, 3, :name, "Hoang Nguyen", :email, "hoang@gmail.com")

    $redis.sadd("chefs", "chef:nguyen")
    $redis.sadd("chefs", "chef:nam")
    $redis.sadd("chefs", "chef:hoang")

    # Create recipes
    $redis.hmset("recipe:flare",:id, 1, :title, "Control Flare", :summary, " These flame flare-ups are every griller's frenemy")
    $redis.hmset("recipe:peel",:id, 2, :title, "Peel Garlic", :summary, " Three Ways to Peel Garlic")
    $redis.hmset("recipe:smokerless", :id, 3, :title, "Smoked Chicken", :summary, "you don't even need a smoker to make it")
    $redis.hmset("recipe:grill",:id, 4, :title, "Grill So Food", :summary, "Season Your Grill So Food Won't Stick")
    $redis.hmset("recipe:rib",:id, 5, :title, "Amazing Ribs", :summary, "Amazing Ribs with Meathead, Part I: Traditional Barbecue Techniques")


    $redis.sadd("recipes", "recipe:peel")
    $redis.sadd("recipes", "recipe:smokerless")
    $redis.sadd("recipes", "recipe:grill")
    $redis.sadd("recipes", "recipe:rib")
    $redis.sadd("recipes", "recipe:flare")

    # Create relationship
    $redis.sadd("chef:nguyen:recipes", "flare")
    $redis.sadd("chef:nguyen:recipes", "peel")
    $redis.sadd("chef:nguyen:recipes", "smokerless")
    $redis.sadd("chef:nam:recipes", "grill")
    $redis.sadd("chef:nam:recipes", "rib")
  end
end
