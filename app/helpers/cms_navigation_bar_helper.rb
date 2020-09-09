module CMSNavigationBarHelper
  def cms_navigation_links
    admin_signed_in? ? links_for_authenticated_cms_admin : ''
  end

  def links_for_authenticated_cms_admin
    capture { nav_items }
  end

  def nav_items
    dropdown_nav_item name: 'Create',
                      menu_items: [
                        { name: 'Post', url: new_cms_post_path },
                        { name: 'Category', url: new_cms_category_path },
                        { name: 'Tender Notice', url: new_tms_notice_path }
                      ]

    nav_item name: 'Dashboard',
             destination: management_dashboard_path

    nav_item name: 'Settings',
             destination: edit_admin_registration_path

    nav_item name: 'Logout',
             destination: destroy_admin_session_path,
             method: :delete
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

  def dropdown_nav_item(name:, menu_items:)
    concat(
      tag.li(class: 'nav-item dropdown') do
        concat dropdown_nav_link name
        concat dropdown_menu menu_items
      end
    )
  end

  def dropdown_nav_link(name)
    link_to name,
            '#',
            class: 'nav-link dropdown-toggle',
            id: 'dashboard-new-dropdown',
            role: 'button',
            data: { toggle: 'dropdown' },
            aria: { haspopup: true, expanded: false }
  end

  def dropdown_menu(menu_items)
    tag.div(
      class: 'dropdown-menu dropdown-menu-right',
      aria: { labelledby: 'dashboard-new-dropdown' }
    ) do
      menu_items.each do |menu_item|
        concat link_to menu_item[:name], menu_item[:url], class: 'dropdown-item'
      end
    end
  end
end
