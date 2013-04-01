class NotesController < ApplicationController

	def new
    
  end

  def index
  	
  end

  def show
    # puts "NotesController show: #{params}"
    # @note = Note.find_by_id(params[:id])
    # render "_form"
  end

  def create
  	# puts "NotesController create: #{params[:note][:content]} - #{params[:meeting_id]} - #{current_user.id}"
    @note = Note.new(content: params[:content], 
    								 user_id: current_user.id, 
    								 meeting_id: params[:meeting_id])
		
    if @note.save
	    respond_to do |format|
	      format.js
	    end
	  else
	  	# redirect_to 'meetings/new'
    end
  end

  def destroy
    @note = Note.destroy(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
