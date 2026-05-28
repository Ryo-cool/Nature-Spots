class Api::V1::AnnouncementsController < ApplicationController
  before_action :authenticate_user

  def index
    announcements = Announcement.published
    render json: {
      announcements: announcements.map { |a| AnnouncementSerializer.new(a).as_json }
    }
  end

  def create
    announcement = Announcement.new(announcement_params.merge(
      author: current_user,
      published_at: Time.current
    ))
    authorize(announcement)

    if announcement.save
      Notifications::Announce.call(announcement)
      render json: {
        announcement: AnnouncementSerializer.new(announcement).with_author
      }, status: :created
    else
      render json: { error: announcement.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:title, :body)
  end
end
