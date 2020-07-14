module CMSNavigationBarHelper
  def cms_navigation_links
    cms_admin_signed_in? ? links_for_authenticated_cms_admin : ''
  end

  def links_for_authenticated_cms_admin
    capture do
      nav_item name: 'CMS',
               destination: cms_posts_path

      nav_item name: 'Settings',
               destination: edit_cms_admin_registration_path

      nav_item name: 'Logout',
               destination: destroy_cms_admin_session_path,
               method: :delete
    end
  end

  def nav_item(name:, destination:, method: :get)
    concat(
      tag.li(class: 'nav-item') do
        if method == :get
          link_to name, destination, class: 'nav-link'
        else
          link_to name, destination, class: 'nav-link', method: method
        end
      end
    )
  end
end
