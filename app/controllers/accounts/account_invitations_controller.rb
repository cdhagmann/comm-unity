class Accounts::AccountInvitationsController < Accounts::BaseController
  before_action :authenticate_user!
  before_action :set_account
  before_action :require_account_admin
  before_action :set_account_invitation, only: [:edit, :update, :destroy, :resend]

  def new
    @account_invitation = AccountInvitation.new
  end

  def create
    @account_invitation = AccountInvitation.new(invitation_params)
    if @account_invitation.save_and_send_invite
      redirect_to @account, notice: t(".sent", email: @account_invitation.email)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account_invitation.update(invitation_params)
      redirect_to @account, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account_invitation.destroy
    redirect_to @account, status: :see_other, notice: t(".destroyed")
  end

  def resend
    @account_invitation.send_invite
    redirect_to @account, status: :see_other, notice: t(".sent", email: @account_invitation.email)
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:account_id])
  end

  def set_account_invitation
    @account_invitation = @account.account_invitations.find_by!(token: params[:id])
  end

  def invitation_params
    params.expect(account_invitation: [:name, :email, *AccountUser::ROLES]).merge(account: @account, invited_by: current_user)
  end
end
