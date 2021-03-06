class CommentsController < ApplicationController
	include SessionsHelper
	# a 'question' refers to a top level comment asked by a user
	# a 'reply' refers to a response to a question by a mentor

	def create #test this
		if current_user  && current_user.activated?
			comment = Comment.create params[:comment]
			current_user.comments << comment
			comment.attempt_upvote_from current_user
			if comment.comment_type == "question" #top level question
				render partial: "show", locals: {question: comment, ama: comment.ama} and return
			elsif comment.comment_type == "reply" #reply from mentor
				# UserMailer.comment(comment.root.user, current_user, comment).deliver
				render partial: "reply", locals: {reply: comment} and return
			else #response to the reply from mentor
				render partial: 'comment', locals: {comment: comment} and return
			end
		else
			# need implementation
			render "not activated yet"
		end
	end

	def upvote
		comment = Comment.find params[:id]
		comment.attempt_upvote_from current_user
		render json: {score: comment.score}
	end

	def edit
		@comment = Comment.find params[:id]
	end

	def update
		@comment = Comment.find params[:id]
		@comment.update_attributes params[:comment]
		redirect_to ama_path(@comment.ama)
	end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		render nothing: true
	end

end