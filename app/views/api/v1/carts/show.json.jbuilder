json.items do
  json.array! @cart.items, partial: 'api/v1/cart_items/cart_item', as: :cart_item
end
json.token @cart.token
json.is_completed @cart.is_completed?
# @tood: use AMS
if @cart.user
  json.user do
    json.id @cart.user.id
    json.username @cart.user.username
  end
else
  json.user nil
end
json.total @cart.total
json._label_total number_to_currency @cart.total, :unit => "$"