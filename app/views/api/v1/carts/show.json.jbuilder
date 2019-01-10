json.products do
  json.array! @cart.items, partial: 'cart_items/cart_item', as: :cart_sitem
end
json.token @cart.token
json.total @cart.total