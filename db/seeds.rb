# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create([
    {title: 'Shopify Mug', price: 3.99, inventory_count: 10},
    {title: 'T-shirt', price: 8.99, inventory_count: 12},
    {title: 'Sticker', price: 0.99, inventory_count: 11},
    {title: 'Audi A7', price: 89000, inventory_count: 2}
               ])