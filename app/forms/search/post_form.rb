module Search
  class PostForm
    include ActiveModel::Model

    attr_accessor :category, :tag_list, :start_date, :end_date

    def initialize(attributes = {})
      form_attributes = attributes.fetch(:search_post_form, {})

      @category = form_attributes.fetch(:category, '')
      @tag_list = form_attributes.fetch(:tag_list, '')
      @start_date = form_attributes.fetch(:start_date, '').to_date
      @end_date = form_attributes.fetch(:end_date, '').to_date
    end

    def search
      return Post.none unless valid?
      return Post.none if empty?

      results
    end

    def results
      records = Post.finished.includes(:category, :rich_text_content, :tags, :taggings)
      records = records.published_between(start_date, end_date) if start_date.present?
      records = records.with_category(category) if category.present? && single_category?
      records = records.with_tags(tags) if tags.present?

      records
    end

    def tags
      tag_list.split(',').collect(&:strip).reject(&:empty?).collect(&:downcase).uniq
    end

    # if all attributes are nil or empty
    def empty?
      category.empty? && tag_list.empty? && start_date.nil? && end_date.nil?
    end

    # Check if a specific category is given
    def single_category?
      category != 'all'
    end

    # Validations

    validate :date_range
    validate :number_of_tags

    def date_range
      errors.add(:start_date, 'should be before end date') if start_date_after_end_date?
      errors.add(:start_date, 'is required if end date is present') if end_date_present?
    end

    def number_of_tags
      errors.add(:tags, 'should be 3 or fewer') if tags.length > 3
    end

    def start_date_after_end_date?
      start_date && end_date && (start_date > end_date)
    end

    def end_date_present?
      start_date.nil? && end_date.present?
    end
  end
end
