class DocsController < ApplicationController
  before_action :load_doc, only: [:destroy]
  before_action :load_doc_form, only: [:doc_update, :edit, :my]
	
  def index
    @documents = Jinda::Doc.desc(:created_at).page(params[:page]).per(10)
	end

  def edit
  end

  def my
    @page_title       = 'My Document'
  end

  def doc_update
    # $xvars["select_doc"] and $xvars["doc_form"]
		# These are variables with params when called
    # They contain everything that we get their forms select_doc and doc_form
    
    @doc = Jinda::Doc.where(:runseq_id => $xvars["doc_form"]["runseq_id"]).first
    @doc.update(description: $xvars["doc_form"]["description"],
                    category: $xvars["doc_form"]["category"],
                    keywords: $xvars["doc_form"]["keywords"],
                    user_id: $xvars["user_id"]
										)
  end

  def destroy
		# duplicated from jinda_controller
		# Expected to use in jinda_controller
    current_ma_user = User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token]

    if Rails.env.test? #Temp solution until fix test of current_ma_user
      current_ma_user = $xvars["current_ma_user"]
      #current_ma_user = @doc.user
    end

    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @doc.user
      @doc.destroy
    end
    redirect_to :action=>'my'
  end

  private

  def load_doc_form
    @docs = Jinda::Doc.all.desc(:created_at).page(params[:page]).per(10)
  end
  def load_doc
    @doc = Jinda::Doc.find(params[:doc_id])
  end
end
