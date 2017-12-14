# materialize error fieldz (& don't wrap fields with extra div)
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
  if html_tag =~ /<(input|label|textarea|select)/
    html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_field.children.add_class 'invalid'
     html_field.children.each do |child|
      if child.name == 'label'
        child.set_attribute 'data-error', instance.error_message.join(', ').capitalize
        #else
        # child.set_attribute 'autofocus', true
        # autofocus to show error, but causes label to float, which aesthetically is wonky. 
      end
    end
    html_field.to_s.html_safe
  else
    html_tag.html_safe
  end
end