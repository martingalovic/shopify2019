json.id cart_item.id
json.product do
  json.partial! 'products/product', :product => cart_item.product
end