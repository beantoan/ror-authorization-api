json.total_pages @pagy.pages
json.total_elements @pagy.count
json.next_page @pagy.next
json.prev_page @pagy.prev
json.entries @users do |user|
  json.id user.id
  json.name user.name
  json.email user.email
  json.status user.status
  json.status_name user.status_i18n
  json.last_sign_in_at user.last_sign_in_at
  json.role user.role, :id, :title, :name
end