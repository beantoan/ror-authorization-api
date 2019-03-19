json.extract! @role, :id, :name, :title, :description
json.is_admin @role.admin?

json.the_roles do
  @role.to_hash.each do |section, rules|
    json.array! rules do |rule, value|
      if value
        json.section section
        json.rule rule
        json.enabled value
      end
    end
  end
end
