class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user

  def index
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 20).to_i
    offset = (page - 1) * per_page

    scoped = current_user.notifications
                         .recent
                         .includes(:actor, :notifiable)

    notifications = scoped.offset(offset).limit(per_page)

    total_count = current_user.notifications.count
    total_pages = (total_count.to_f / per_page).ceil

    render json: {
      notifications: notifications.map { |n| NotificationSerializer.new(n).as_json },
      unread_count: current_user.notifications.unread.count,
      pagination: {
        current_page: page,
        per_page: per_page,
        total_pages: total_pages,
        total_count: total_count
      }
    }
  end

  def unread_count
    render json: { unread_count: current_user.notifications.unread.count }
  end

  def read
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!
    render json: {
      notification: NotificationSerializer.new(notification).as_json,
      unread_count: current_user.notifications.unread.count
    }
  end

  def read_all
    current_user.notifications.unread.update_all(read_at: Time.current)
    render json: { unread_count: 0 }
  end
end
