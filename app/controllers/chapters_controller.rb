class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]
  # before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  load_and_authorize_resource
  require 'yomu'

  
  # GET /chapters
  # GET /chapters.json
  def index
    @book = Book.find params[:book_id]
    @chapters = Chapter.where( book_id: params[:book_id] ).order(:created_at)
  end

  # GET /chapters/1
  # GET /chapters/1.json
  def show
     
  end

  # GET /chapters/new
  def new
    @chapter = Chapter.new
  end

  # GET /chapters/1/edit
  def edit
  end

  # POST /chapters
  # POST /chapters.json
  def create
    # unless current_user.admin? == true
    #   flash[:error] = "权限错误！"
    #   redirect_to new_chapter_url
    #   return false
    # end
    yomu = Yomu.new params[:chapter][:docfile]
    text = yomu.text.gsub(/(第.*?章.*?\n)/, '@@@\0###') + '@@@'
    titles = text.scan(/@@@(.*?)\n###/)
    contents = text.scan(/###(.*?)@@@/m)
    original_count = Chapter.count
    
    titles.each_with_index do |title, key|
      @chapter = Chapter.new
      @chapter.title = title[0]
      @chapter.content = contents[key][0]
      @chapter.book_id = params[:chapter][:book_id]
      @chapter.save
    end
    
    updated_count = Chapter.count
    

    respond_to do |format|
      if original_count < updated_count
        format.html { redirect_to '/chapters' + "?book_id=#{params[:chapter][:book_id]}", notice: '成功添加章节！' }
        format.json { render :show, status: :created, location: @chapter }
      else
        format.html { render :new }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chapters/1
  # PATCH/PUT /chapters/1.json
  def update
    respond_to do |format|
      if params['chapter']['vip'] == '1'
        chapters = @chapter.book.chapters
        chapters.each do |c|
          if c.id < @chapter.id
            c.vip = nil
          end
          if c.id >= @chapter.id
            c.vip = true 
          end
          
          c.save!
        end
      end
        
      if @chapter.update(chapter_params)
        format.html { redirect_to @chapter, notice: 'Chapter was successfully updated.' }
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to "/books/#{@chapter.book_id}", notice: 'Chapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chapter_params
      params.require(:chapter).permit(:title, :content, :book_id)
    end
end
