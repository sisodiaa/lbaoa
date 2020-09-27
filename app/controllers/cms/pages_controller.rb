module CMS
  class PagesController < ApplicationController
    def show
      if valid_page?
        render template: "cms/pages/#{sanitized_page_name}"
      else
        render file: 'public/404.html', status: :not_found
      end
    end

    def send_public_document
      if valid_file?
        send_file(
          Rails.root.join('public', 'docs', sanitized_filename),
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
          Rails.root + "app/views/cms/pages/#{sanitized_page_name}.html.erb"
        )
      )
    end

    def sanitized_page_name
      /\./i.match?(params[:page]) ? 'home' : params[:page]
    end

    def valid_file?
      File.exist?(
        Pathname.new(
          Rails.root + "public/docs/#{sanitized_filename}"
        )
      )
    end

    def sanitized_filename
      return params[:filename] unless %r{\/}.match?(params[:filename])

      'lb_aoa_certified_bye_laws_and_registration_certificate.pdf'
    end
  end
end
