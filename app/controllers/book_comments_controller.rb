class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @book_comment =BookComment.new
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save
    # redirect_to book_path(book)
  end

  def destroy
    @book = Book.find(params[:book_id])
    @Book_Comment = BookComment.find(params[:id])
    @Book_Comment.destroy
    # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
