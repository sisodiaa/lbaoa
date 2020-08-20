module SearchHelper
  def post_categories_options
    Category.pluck(:title).map do |title|
      [title.titleize, title]
    end.unshift(['All', 'all'])
  end
end
