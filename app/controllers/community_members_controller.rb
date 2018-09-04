class CommunityMembersController < ApplicationController
  before_action :set_community_member, only: [:show, :edit, :update, :destroy]

  # GET /community_members
  # GET /community_members.json
  def index
    @community_members = CommunityMember.all
  end

  # GET /community_members/1
  # GET /community_members/1.json
  def show
  end

  # GET /community_members/new
  def new
    @community_member = CommunityMember.new
  end

  # GET /community_members/1/edit
  def edit
  end

  # POST /community_members
  # POST /community_members.json
  def create
    @community_member = CommunityMember.new(community_member_params)

    respond_to do |format|
      if @community_member.save
        format.html { redirect_to @community_member, notice: 'Community member was successfully created.' }
        format.json { render :show, status: :created, location: @community_member }
      else
        format.html { render :new }
        format.json { render json: @community_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /community_members/1
  # PATCH/PUT /community_members/1.json
  def update
    respond_to do |format|
      if @community_member.update(community_member_params)
        format.html { redirect_to @community_member, notice: 'Community member was successfully updated.' }
        format.json { render :show, status: :ok, location: @community_member }
      else
        format.html { render :edit }
        format.json { render json: @community_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /community_members/1
  # DELETE /community_members/1.json
  def destroy
    @community_member.destroy
    respond_to do |format|
      format.html { redirect_to community_members_url, notice: 'Community member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community_member
      @community_member = CommunityMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_member_params
      params.require(:community_member).permit(:id_community, :id_user, :isAdmin)
    end
end
