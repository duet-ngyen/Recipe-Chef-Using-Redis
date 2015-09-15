class RecipesController < ApplicationController
  before_action :load_recipe, except: [:index, :new, :show, :edit]
  before_action :create_database, only: [:index]

  def index
    @count = counter
    @chefs = $redis.smembers("chefs")
  end

  def show
    @count = counter
    @recipe = "recipe:#{params[:id]}"
  end

  def new
    @count = counter
    @recipe = Recipe.new
  end

  def create
    recipe_id = $redis.scard("recipes")
    $redis.set("id", recipe_id)
    id = $redis.incr(:id)
    title = params[:recipe][:title]
    summary = params[:recipe][:summary]

    $redis.hmset("recipe:#{id}", :title, title, :summary, summary)
    $redis.sadd("recipes", "recipe:#{id}")
    redirect_to recipes_path
  end

  def edit
    @count = counter
    @recipe = "recipe:#{params[:id]}"
  end

  def update
    byebug
    id = params[:id]
    byebug
    title = params[:recipe][:title]
    summary = params[:recipe][:summary]

    $redis.hmset("recipe:#{id}", :title, title, :summary, summary)
    $redis.sadd("recipes", "recipe:#{id}")
    redirect_to recipe_path "recipe:#{id}"
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
    $redis.hmset("chef:1", :name, "Nguyen Huynh", :email, "nguyen@gmail.com")
    $redis.hmset("chef:2", :name, "Nam Nguyen", :email, "nam@gmail.com")
    $redis.hmset("chef:3", :name, "Hoang Nguyen", :email, "hoang@gmail.com")

    $redis.sadd("chefs", "chef:1")
    $redis.sadd("chefs", "chef:2")
    $redis.sadd("chefs", "chef:3")

    # Create recipes
    $redis.hmset("recipe:1", :title, "Control Flare", :summary, " These flame flare-ups are every griller's frenemy")
    $redis.hmset("recipe:2", :title, "Peel Garlic", :summary, " Three Ways to Peel Garlic")
    $redis.hmset("recipe:3", :title, "Smoked Chicken", :summary, "you don't even need a smoker to make it")
    $redis.hmset("recipe:4", :title, "Grill So Food", :summary, "Season Your Grill So Food Won't Stick")
    $redis.hmset("recipe:5", :title, "Amazing Ribs", :summary, "Amazing Ribs with Meathead, Part I: Traditional Barbecue Techniques")


    $redis.sadd("recipes", "recipe:1")
    $redis.sadd("recipes", "recipe:2")
    $redis.sadd("recipes", "recipe:3")
    $redis.sadd("recipes", "recipe:4")
    $redis.sadd("recipes", "recipe:5")

    # Create relationship
    $redis.sadd("chef:1:recipes", "1")
    $redis.sadd("chef:1:recipes", "2")
    $redis.sadd("chef:1:recipes", "3")
    $redis.sadd("chef:2:recipes", "4")
    $redis.sadd("chef:2:recipes", "5")
  end
end
