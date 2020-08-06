module ApplicationHelper
  include Pagy::Frontend

  def active_nav_item(path)
    current_page?(path) ? 'active' : ''
  end

  def flash_messages
    return if flash.empty?

    toast_wrapper
  end

  def toast_wrapper
    tag.div(
      id: 'toast-wrapper',
      class: 'position-absolute w-100 d-flex flex-column p-2'
    ) do
      flash.each do |type, message|
        concat(toast(type, message))
      end
    end
  end

  def toast(type, message)
    tag.div(class: "toast mx-auto w-25 #{bootstrap_class_for(type)}",
            data: { delay: 1500 }) do
      concat(toast_header(type))
      concat(toast_body(message))
    end
  end

  def bootstrap_class_for(flash_type)
    {
      success: 'bg-success text-white',
      error: 'bg-danger text-white',
      alert: 'bg-warning text-dark',
      notice: 'bg-info text-white'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def toast_body(message)
    tag.div message, class: 'toast-body'
  end

  def toast_header(type)
    tag.div class: 'toast-header' do
      concat(header_text(type))
      concat(close_button)
    end
  end

  def header_text(type)
    tag.strong type.to_s.titleize, class: 'mr-auto'
  end

  def close_button
    tag.button(
      close_span,
      class: 'ml-2 mb-1 close',
      data: { dismiss: 'toast' },
      aria: { label: 'Close' }
    )
  end

  def close_span
    tag.span '&times;'.html_safe, aria: { hidden: 'true' }
  end
end
