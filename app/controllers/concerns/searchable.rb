module Searchable
  extend ActiveSupport::Concern

  included do
    helper_method :active_search_query, :minimum_search_length, :maximum_search_length
  end

  private

  def minimum_search_length
    MIN_SEARCH_LENGTH
  end

  def maximum_search_length
    MAX_SEARCH_LENGTH
  end

  def active_search_query
    query = params[:query].to_s.strip.truncate(MAX_SEARCH_LENGTH, omission: "")
    query if query.length >= MIN_SEARCH_LENGTH
  end
end
