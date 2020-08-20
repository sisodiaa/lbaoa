module SearchHelper
  def post_categories_options
    Category.pluck(:title).map do |title|
      [title.titleize, title]
    end.unshift(['All', 'all'])
  end

  def search_post_link(value, attrib, klass = '')
    link_to(
      value,
      search_posts_path(search_post_form: { attrib.to_sym => value }),
      class: klass
    )
  end
end
