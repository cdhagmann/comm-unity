class AnnouncementsController < ApplicationController
  before_action :mark_as_read, if: :user_signed_in?

  def index
    @pagy, @announcements = pagy(Announcement.published.order(published_at: :desc))
  end

  def show
    @announcement = Announcement.published.find(params[:id])
  end

  private

  def mark_as_read
    current_user.update(announcements_read_at: Time.current)
  end
end
