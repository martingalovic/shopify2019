json.id cart_item.id
json.qty cart_item.qty
json.product do
  json.partial! 'products/product', :product => cart_item.product
end