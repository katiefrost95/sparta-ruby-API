class PostsController < Sinatra::Base

  # Sets root as the parent-directory of the current file
  set :root, File.join(File.dirname(__FILE__), '..')

  # Sets the view directory correctly
  set :views, Proc.new { File.join(root, "views") }

  # Enables the reloader so we dont need to keep restarting the server
  configure :development do
      register Sinatra::Reloader
  end

  # A get request to the / route will respond with our index template with all the posts from the model
  get '/api/posts' do
    @posts = Post.all
    content_type :json
    # @posts.each do |post| #|post| is i in the for loop
    #   puts post.title
    #   puts post.body
    #   puts "-----------------------"
    # end
    json = []
    @posts.each do |post|
      json.push ({
        id: post.id,
        title: post.title,
        body: post.body
      })
    end
    p json.to_json
  end


  # A get request to /:id will respond with a the show template with the requested post
  get '/api/posts/:id' do
    id = params[:id].to_i
    @post = Post.find(id)
    content_type :json
    @post.to_json
  end

  # Using this to create posts in database without using front end
  post '/api/posts' do
    new_post = {
      title: params[:title],
      body: params[:body]
    }
    post = Post.create(new_post)
    content_type :json
    new_post.to_json
  end


  # A put request to the /:id will will update an existing post
  put '/:id'  do

    # The id of the post we want to update, we pulled this information from request params
    id = params[:id].to_i

    # We use the find Class method to get us the post we need to update
    post = Post.find(id)

    # Manipulate the the intance variables to the new data the user entered
    post.id = params[:id]
    post.title = params[:title]
    post.body = params[:body]

    # Use the instance method save to update the post
    post.save

    # Redirect to / to show all the posts
    redirect '/'

  end

  # A delete request to /:id will delete the specified post from the db
  delete '/:id'  do

    # The id of the post we want to delete, we pulled this information from request params
    id = params[:id].to_i

    # We can use the Class method destroy to remove the post from the db
    Post.destroy(id)

    # Redirect to / to show all the posts
    redirect "/"

  end

  # A request to /:id/edit will respond with a the edit template with the post data of the post we can want to update
  get '/:id/edit'  do

    # The id of the post we want to update, we pulled this information from request params
    id = params[:id].to_i

    # Use the find Class method in post to retrieve the post we need and assign it to an instance variable post
    @post = Post.find(id)

    # Render the edit template
    erb :'posts/edit'

  end

end
