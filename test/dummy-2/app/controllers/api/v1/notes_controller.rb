class Api::V1::NotesController < ApplicationController
  before_action :load_note, only: [:show, :destroy]
  # before_action :xload_current_ma_user, only: [:destroy]

  def index
    @notes = Note.desc(:created_at).page(params[:page]).per(10)
    render json: @notes
  end

  def my
    @notes = Note.where(user_id: current_ma_user).desc(:created_at).page(params[:page]).per(10)
    render json: @notes
  end

  def show 
  end

  def edit
    @note = Note.find(params[:id])
    @page_title       = 'Edit Note'
  end

  def create
    @note = Note.new(
      title: params[:title],
      body: params[:body],
      user_id: params[:user])

    @note.save!
    render json: @note, status: :created
  end


  def update
    # $xvars["select_note"] and $xvars["edit_note"]
    # These are variables.
    # They contain everything that we get their forms select_note and edit_note
    note_id = $xvars["select_note"] ? $xvars["select_note"]["id"] : $xvars["p"]["note_id"]
    @note = Note.find(note_id)
    @note.update(title: $xvars["edit_note"]["title"],
                 body: $xvars["edit_note"]["body"])
    redirect_to @note

  end

  def delete
    # called by freemind
  # Tobe called from other controller:jinda
    @note_id = $xvars["select_note"] ? $xvars["select_note"]["id"] : $xvars["p"]["note_id"]
    @note = Note.find(@note_id)
    @note.destroy
  end

  def destroy
    # called by rails menu my
    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @note.user
      @note.destroy
    end
    redirect_to :action=>'my'
  end

  def mail
    NoteMailer.gmail(
                    $xvars["display_mail"]["body"],
                    $xvars["select_note"]["email"],
                    $xvars["display_mail"]["title"],
                    xload_current_ma_user.email)
  end

  private

  # Tobe called from other controller:jinda
  def xload_current_ma_user
    @current_ma_user = User.find($xvars["user_id"])
  end

  def load_note
    @note = Note.find(params[:id])
  end

end
