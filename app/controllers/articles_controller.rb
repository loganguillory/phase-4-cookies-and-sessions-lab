class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    # initialize session variable
    session[:page_views] ||= 0
    # Adds 1 each time an article is accessed
    session[:page_views] += 1
    #conditional logic that stops user from seeing more than 3 articles
    if session[:page_views] > 3
      render json: {"error": "Maximum pageview limit reached"}, status: :unauthorized
    else
    article = Article.find(params[:id])
    render json: article
    
  end
end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
