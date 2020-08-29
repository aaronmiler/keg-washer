module ApplicationHelper
  def react(name, id, data = {})
    code = "mountReactComponent(#{name.to_json}, #{id.to_json}, #{data.to_json});"
    content_tag 'script', code.html_safe
  end
end
