class TeamsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  # before_action :correct_user,     only: :destroy

  def index
    @teams = Team.paginate(page: params[:page])
  end

  def show
    @team = Team.find(params[:id])
    @captain = User.find(@team.captain_id)
    @members = @team.members_id
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.update(captain_id: session[:user_id])
    User.find(@team.captain_id).update(team_id: @team.id)
    if @team.save
      flash[:success] = "Успешно създаден отбор."
      redirect_to "/teams/#{@team.id}"
    else
      render 'new'
    end
  end

  def send_invite
    @invite = Invite.new(invite_params)
    if @invite.save
      flash[:success] = "Успешно поканен участник."
      redirect_to User.find(params[:to_id])
    else
      redirect_to root
    end
  end

  def cancel_invite
    Invite.find_by(from_id: params[:from_id], to_id: params[:to_id]).destroy
    flash[:success] = "Успешно отменена покана."
    redirect_to User.find(params[:to_id])
  end

  def accept_invite
    @sending_user   = User.find(params[:from_id])
    @accepting_user = User.find(params[:to_id])
    @accepting_user.update(team_id: @sending_user.team_id)
    @team = Team.find(@sending_user.team_id)
    @members = @team.members_id
    @members.push(@accepting_user.id)
    @team.update(members_id: @members)
    Invite.find_by(from_id: params[:from_id], to_id: params[:to_id]).destroy
    flash[:success] = "Успешно приета покана."
    redirect_to User.find(params[:to_id])
  end

  def decline_invite
    Invite.find_by(from_id: params[:from_id], to_id: params[:to_id]).destroy
    flash[:success] = "Успешно отказана покана."
    redirect_to User.find(params[:to_id])
  end

  def leave
    @user = current_user
    @team = Team.find(params[:id])
    @user.update(team_id: nil)
    @new_members = @team.members_id - [@user.id]
    @team.update(members_id: @new_members)
    flash[:success] = "Успешно напускане на отбор."
    redirect_to @user
  end

  def destroy
    @team = Team.find(params[:id])
    User.find(@team.captain_id).update(team_id: nil)
    @members = @team.members_id
    @members.each do |id|
      User.find(id).update(team_id: nil)
    end
    @team.destroy
    flash[:success] = "Отбор изтрит."
    redirect_to teams_path
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    params[:team][:technologies] = params[:team][:technologies].split("\n")
    if @team.update_attributes(team_params)
      @team.update(technologies: params[:team][:technologies])
      flash[:success] = "Успешно обновяване на отбора."
      redirect_to "/teams/#{@team.id}"
    else
      render 'edit'
    end
  end

  private

    def team_params
      params.require(:team).permit(:name, :project_name, :project_desc,
                                   :captain_id, :members_id)
    end

    def invite_params
      params.permit(:from_id, :to_id)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Влез в профила си."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    # def correct_user
    #   @user = User.find(params[:id])
    #   redirect_to(root_url) unless @user.id == current_team.captain_id
    # end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
