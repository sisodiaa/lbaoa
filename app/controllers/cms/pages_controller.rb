module CMS
  class PagesController < ApplicationController
    def show
      if valid_page?
        render template: "cms/pages/#{params[:page]}"
      else
        render file: 'public/404.html', status: :not_found
      end
    end

    def send_public_document
      if valid_file?
        send_file(
          Rails.root.join('public', 'docs', params[:filename]),
          type: 'application/pdf',
          disposition: 'attachment',
          x_sendfile: true
        )
      else
        redirect_to(request.referer || root_path)
      end
    end

    private

    def valid_page?
      File.exist?(
        Pathname.new(
          Rails.root + "app/views/cms/pages/#{params[:page]}.html.erb"
        )
      )
    end

    def valid_file?
      File.exist?(
        Pathname.new(
          Rails.root + "public/docs/#{params[:filename]}"
        )
      )
    end
  end
end
