class RecipesController < ApplicationController
  before_action :load_recipe, except: [:index, :new]

  def index
    # Create chefs
    $redis.hmset("chef:nguyen", :name, "Nguyen Huynh", :email, "nguyen@gmail.com")
    $redis.hmset("chef:nam", :name, "Nam Nguyen", :email, "nam@gmail.com")
    $redis.hmset("chef:hoang", :name, "Hoang Nguyen", :email, "hoang@gmail.com")

    $redis.sadd("chefs", "chef:nguyen")
    $redis.sadd("chefs", "chef:nam")
    $redis.sadd("chefs", "chef:hoang")

    # Create recipes
    $redis.hmset("recipe:flare", :title, "Control Flare", :summary, " These flame flare-ups are every griller's frenemy")
    $redis.hmset("recipe:peel", :title, "Peel Garlic", :summary, " Three Ways to Peel Garlic")
    $redis.hmset("recipe:smokerless", :title, "Smoked Chicken", :summary, "you don't even need a smoker to make it")
    $redis.hmset("recipe:grill", :title, "Grill So Food", :summary, "Season Your Grill So Food Won't Stick")
    $redis.hmset("recipe:rib", :title, "Amazing Ribs", :summary, "Amazing Ribs with Meathead, Part I: Traditional Barbecue Techniques")

    $redis.sadd("recipes", "recipe:flare")
    $redis.sadd("recipes", "recipe:peel")
    $redis.sadd("recipes", "recipe:smokerless")
    $redis.sadd("recipes", "recipe:grill")
    $redis.sadd("recipes", "recipe:rib")

    # Create relationship
    $redis.sadd("chef:nguyen:recipes", "flare")
    $redis.sadd("chef:nguyen:recipes", "peel")
    $redis.sadd("chef:nguyen:recipes", "smokerless")
    $redis.sadd("chef:nam:recipes", "grill")
    $redis.sadd("chef:nam:recipes", "rib")

  end

  def show
  end

  def new
    $redis.hmset("recipe:test", :title, "test", :summary, "Demo Description")
    $redis.sadd("recipes", "recipe:test")
    redirect_to recipes_path
  end

  def create

  end

  private
  def load_recipe
    @recipe = Recipe.find_by params[:id]
  end

  def current_recipe

  end
end
