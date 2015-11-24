module SortableFilterHelper

  def acts_as_filterable options = {}
    cattr_accessor :order
    cattr_accessor :direction
    self.order = options[:default_order] || 'id'
    self.direction = options[:default_direction] || 'ASC'
  end

  def filter filters = {}
    searches = filters[:search] || {}
    order = filters[:order] || self.order
    direction = filters[:direction] || self.direction
    page = filters[:page]
    tags = filters[:tagged_with]

    returns = where(nil)
    returns = returns.order("#{order} #{direction}")

    if searches.any?
      searches.each do |s, v|
        if self.columns_hash[s.to_s] and ! v.blank?
          use_col = "#{self.table_name}.#{s}"
          case self.columns_hash[s.to_s].type
          when :string
            returns = search_text(returns, use_col,v)
          when :text
            returns = search_text(returns, use_col,v)
          when :integer
            returns = search_number(returns, use_col,v, 'int')
          when :float
            returns = search_number(returns, use_col,v, 'float')
          when :boolean
            returns = search_boolean(returns, use_col,v)
          when :date
            returns = search_time(returns, use_col,v)
          when :datetime
            returns = search_time(returns, use_col,v)
          when :jsonb
            if s == "magic_fields"
              v.each do |mfk, mfv|
                returns = search_magic_field(returns, mfk, mfv) unless mfv.blank?
              end
            end
          end
        end
      end
    end

    returns = search_tags(returns, tags) if tags

    returns.page(page)
  end

  def column_sorter title, column, url = nil, user_options = {}
      url ||= request.path
      sort_icon = 'sort'
      current_column = params[:order] == column.to_s
      direction = (params[:order] == column.to_s) ? (params[:direction] == 'asc' ? 'desc':'asc') : 'asc'
      sort_icon = "sort-#{direction}" if current_column
      default_options = {}
      options = default_options.merge user_options
      url = "#{url}?#{params.except(:controller, :action).merge(order: column, direction: direction, page: 1).to_query}"
      link_to "#{fa_icon sort_icon} #{title}".html_safe, url, options
  end

  def filter_form(url = nil, user_options = {}, &block)
    url ||= request.original_url
    default_options = {method: :get, class: "form-inline filter-bar", role: "form"}
    options = default_options.merge user_options
    content_tag :div, class: "well well-sm" do
      form_tag url, options do
        capture &block
      end
    end
  end

  def filter_form_reset form_identifier
    reset_string = ""
    if params[:reset]
      reset_string += "$('#{form_identifier}').trigger('reset');"
      reset_string += "$('#{form_identifier} .select2').select2('val', '');"
    end

    reset_string.html_safe
  end

  def filter_text_field field_name, user_options = {}
    default_options = {class: "form-control"}
    options = default_options.merge user_options
    field_name = field_name.to_sym

    content_tag :div, class: "form-group" do
      text_field_tag  "search[#{field_name}]",
                      (params.try :dig, [:search, field_name]),
                      options
    end
  end

  def filter_magic_fields_field field_name, user_options = {}
    default_options = {class: "form-control"}
    options = default_options.merge user_options
    field_name = field_name.to_sym

    content_tag :div, class: "form-group" do
      text_field_tag  "search[magic_fields][#{field_name}]",
                      (params.try :dig, [:search, :magic_fields, field_name]),
                      options
    end
  end


  def filter_magic_fields_select_field field_name, select_options, user_options
    default_options = {class: "form-control select2"}
    options = default_options.merge user_options
    field_name = field_name.to_sym

    content_tag :div, class: "form-group" do
      select_tag  "search[magic_fields][#{field_name}]",
                  options_for_select(select_options.split(","), (params.try :dig, [:search, :magic_fields, field_name])),
                  options
    end
  end

  def filter_magic_fields_relation_field field_name, select_options, user_options
    default_options = {class: "form-control select2"}
    options = default_options.merge user_options
    field_name = field_name.to_sym

    content_tag :div, class: "form-group" do
      select_tag  "search[magic_fields][#{field_name}]",
                  options_from_collection_for_select(select_options, :id, :to_s, (params.try :dig, [:search, :magic_fields, field_name])),
                  options
    end
  end

  def filter_magic_fields_boolean_field field_name, user_options = {}
    default_options = {class: "form-control select2"}
    options = default_options.merge user_options
    field_name = field_name.to_sym

    content_tag :div, class: "form-group" do
      select_tag  "search[magic_fields][#{field_name}]",
                  options_for_select([[t("true"), "1"],[t("false"), "0"]], (params.try :dig, [:search, :magic_fields, field_name])),
                  options
    end
  end


  def filter_hidden_field field_name, field_value, user_options = {}
    default_options = {}
    options = default_options.merge user_options

    field_name = field_name.to_sym

    hidden_field_tag  "search[#{field_name}]",
                      field_value,
                      options
  end


  def filter_select field_name, select_options, user_options = {}
    default_options = {class: "select2"}
    options = default_options.merge user_options

    field_name = field_name.to_sym

    content_tag :div, class: "form-group" do
      select_tag  "search[#{field_name}]",
                  options_for_select(select_options, (params[:search][field_name] if params[:search] && params[:search][field_name])),
                  options
    end
  end

  def filter_collection_select field_name, collection, value_method, text_method, user_options = {}
    default_options = {class: "select2"}
    options = default_options.merge user_options

    field_name = field_name.to_sym

    content_tag :div, class: "form-group" do
      select_tag  "search[#{field_name}]",
                  options_from_collection_for_select(collection, value_method, text_method, (params[:search][field_name] if params[:search] && params[:search][field_name])),
                  options
    end
  end

  def filter_buttons url = nil, button = "Buscar"
    url ||= request.path
    url += (url.include?("?") ? "&reset=true" : "? reset=true")
    options = {class: "btn btn-default"}

    content_tag :div, class: "form-group" do
      concat hidden_field_tag :direction, params[:direction]
      concat hidden_field_tag :order, params[:order]
      concat button_tag "Importar", class: "btn btn-primary"
      concat " "
      concat link_to "Reset", url, options
    end
  end


  private

    def search_text(returns, s, v)
      if v.is_a? String
        returns.where("#{s} ILIKE ?", "%#{v}%")
      else
        rule = v[:rule]
        search_string = v[:value]
        if rule == "exact"
          returns.where("#{s} = ?", search_string)
        end
      end
    end

    def search_number(returns, s, v, number_type)
      if v.is_a? Hash
        min_value = v[:min_value]
        max_value = v[:max_value]
        returns = returns.where("#{s} >= ?", min_value.to_f) unless min_value.blank?
        returns = returns.where("#{s} <= ?", max_value.to_f) unless max_value.blank?
      else
        returns = returns.where("#{s} = ?", v.to_f) unless v.blank?
      end

      returns
    end

    def search_boolean(returns, s, v)
      returns.where("#{s} = ?", v)
    end

    def search_time(returns, s, v)
      start_time = v[:start]
      end_time = v[:end]

      returns = returns.where("#{s} >= ?", start_time) unless start_time.blank?
      returns = returns.where("#{s} <= ?", end_time) unless end_time.blank?
      returns
    end

    def search_magic_field returns, s, v
      returns = returns.where("magic_fields ->> ? ILIKE ?", s, "%#{v}%")
    end

    def search_tags returns, tags
      returns.tagged_with tags
    end

end
