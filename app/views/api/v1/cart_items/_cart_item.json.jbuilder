json.id cart_item.id
json.product do
  json.partial! 'api/v1/products/product', :product => cart_item.product
end