class PagesController < ApplicationController
  layout :choose_layout
  before_filter :require_user
  before_filter :check_authorization

  respond_to :html, :xml

  def index
    @pages = Page.all
    respond_with(@pages)
  end

  def show
    @page = Page.find(params[:id])
    respond_with(@page)
  end

  def new
    params[:type] ||= 'Noticia'
    @page = Object.const_get(params[:type]).new
    @page.sites_pages.build
    #@page = Page.new
    respond_with(@page)
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Object.const_get(params[:page][:type]).new(params[:page])
    #@page = Page.new(params[:page])
    @page.save
    redirect_to({:site => @page.site_ids , :controller => 'pages', :action => 'index'}, :notice => 'Page was successfully created.')
    #respond_with(@page)
  end

  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[@page.class.name.underscore])
    respond_with(@page)
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    respond_with(@page)
  end
end
