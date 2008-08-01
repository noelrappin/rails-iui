module IuiHelper
  
  def viewport_tag(options = {})
    content = ""
    content += "width = device-width, user-scalable=no" if options[:device_width]
    tag(:meta, :name => "viewport", :content => content)
  end
  
  def include_iui_files
    stylesheet_link_tag('iui') + javascript_include_tag('iui') +
    javascript_tag("function $(id) { return document.getElementById(id); }")
  end
  
  def button_link_to(name, options, html_options = {})
    html_options[:class] = "button"
    link_to(name, options, html_options)
  end
  
  def link_to_replace(name, options, html_options = {})
    html_options[:target] = "_replace"
    link_to(name, options, html_options)
  end
  
  def link_to_external(name, options, html_options = {})
    html_options[:target] = "_self"
    link_to(name, options, html_options)
  end
  
  def link_to_target(target, name, options, html_options = {})
    if target == :replace 
      link_to_replace(name, options, html_options)
    elsif target == :self or target == :external
      link_to_external(name, options, html_options)
    else
      link_to(name, options, html_options)
    end
  end
  
  def iui_toolbar(initial_caption, search_url = nil)
    back_button = button_link_to("", "#", :id => "backButton")
    header = content_tag(:h1, initial_caption, :id => "header_text")
    search_link = if search_url 
                  then button_link_to("Search", search_url, :id => "searchButton",
                      :target => "_self") 
                  else ""
                  end 
    content = [back_button, header, search_link].join("\n")
    content_tag(:div, content, :class => "toolbar")
  end
  
  def list_element(item, target=nil)
    onclick_one = "$('header_text').innerHTML='#{item.caption}'; "
    onclick_two = "$('backButton').addEventListener('click', 
        function() {$('header_text').innerHTML='Soups OnLine'; }, false);"
    link = link_to_target(target, item.caption, item.url, 
        :onclick => "#{onclick_one} " + " #{onclick_two}")
    content_tag(:li, link)
  end
  
  def append_options(list_content, options = {})
    list_content = options[:top] + list_content if options[:top]
    list_content += list_element(options[:more], :replace) if options[:more]
    list_content += options[:bottom] if options[:bottom]
    list_content
  end
  
  def iui_list(items, options = {})
    list_content = items.map {|i| list_element(i)}.join("\n")
    list_content = append_options(list_content, options)
    if options[:as_replace] 
      list_content
    else
      content_tag(:ul, list_content, :selected => "true")
    end
  end
  
  def iui_grouped_list(items, options = {}, &group_by_block)
    groups = items.group_by(&group_by_block).sort
    group_elements = groups.map do |group, members|
      group = content_tag(:li, group, :class => "group")
      member_elements = [group] + members.map { |m| list_element(m) }
    end
    content_tag(:ul, group_elements.flatten.join("\n"), :selected => "true")
  end
  
  def fieldset(&block)
    concat(content_tag(:fieldset, capture(&block)), block.binding)
  end
  
  def row(label_text="", &block)
    label = if label_text.blank? then "" else content_tag(:label, label_text) end
    block = if block_given? then capture(&block) else "" end
    div = content_tag(:div, label + block, :class => "row")
    if block_given?
      concat(div, block.binding)
    else
      div
    end
  end
  
  def row_label(&block)
    label = content_tag(:label, capture(&block))
    div = content_tag(:div, label, :class => "row")
    concat(div, block.binding)
  end
  
  def panel(&block)
    div = content_tag(:div, capture(&block), :class => "panel")
    concat(div, block.binding)
  end
  
  def dialog(&block)
    div = content_tag(:div, capture(&block), :class => "dialog")
    concat(div, block.binding)
  end
  
  def servicelink_tel(telno)
      content_tag("a",telno,:class=>"ciuServiceLink",:target => "_self",:href => "tel:#{telno}" ,:onclick => "return(navigator.userAgent.indexOf('iPhone') != -1)")
  end
  def servicelink_email(email)
      content_tag("a",email,:class=>"ciuServiceLink",:target => "_self",:href => "mailto:#{email}" ,:onclick => "return(navigator.userAgent.indexOf('iPhone') != -1)")
  end
  def servicebutton_map(gadr,caption)
        content_tag("a",caption,:class=>"ciuServiceButton",:target => "_self",:href => "http://maps.google.com/maps?q=#{gadr}" ,:onclick => "return(navigator.userAgent.indexOf('iPhone') != -1)")
  end
  
  def observe_orientation_change(url_options = {})
    remote = remote_function :url => url_options, 	
  						:with => "'position=' + String(window.orientation)"
    func = "function() { #{remote}; };"
    javascript_tag("function updateOrientation() { #{remote}; }")
  end
  
  def register_orientation_change
    'onorientationchange="updateOrientation();"'
  end
  
end

ActionView::Base.send(:include, IuiHelper)
