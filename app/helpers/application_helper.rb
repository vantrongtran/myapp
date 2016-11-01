module ApplicationHelper

  def link_to_remove_fields name, f
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object,
      child_index: "new_#{association}") do |builder|
        render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to_function name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"
  end

  def link_to_function name, *args, &block
    html_options = args.extract_options!.symbolize_keys
    function = block_given? ? update_page(&block) : args[0] || ""
    onclick = "#{"#{html_options[:onclick]};
      " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || "#"
    content_tag(:a, name, html_options.merge(href: href, onclick: onclick))
  end

  def load_target activity
    if activity.create_lesson? || activity.finish_lesson?
      @lesson = Lesson.find_by id: activity.target_id
    else
      User.find_by id: activity.target_id
    end
  end

  def load_activity activity
    case activity.action_type
      when "follow_user"
        t "follow_user"
      when "unfollow_user"
        t "unfollow_user"
      when "create_lesson"
        t "create_lesson"
      when "finish_lesson"
        t "finish_lesson"
    end
  end
end
