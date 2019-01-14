At first I created a database scheme, simple relations, composite and partial keys

Then I made controllers that permit only the use of needed actions (for example `products_controller` should only list and
show a detail of product so no update or destroy method is needed)

Then I started implementing functionality to controllers and models, made scopes and model methods which will be probably
used repeatidly (or are just multiline methods / logics, that I don't want to write directly inside controllers, but rather do it MVC way).

As I started implemeting those, I was always trying to be cautious about missuse of this API so I made sure no raw queries
with unsanitized user input are being execued or other unwanted scenarios could happen (eg. like increasing product inventory by negative number).

I was also thinking about adding `quantity` column to `cart_items` as thats pretty usual function of cart, but I decided to stick to documentation on google docs and
chose “only one same product in cart” option.

Queries should be efficient and fast. So when we complete the cart every product `inventory_count` column should decrease by 1.
Application executes one query which updates `inventory_count = inventory_count - 1` for all products related to the
cart (this would also work with quantity item as we may simply join cart_items table and instead of `... inventory_count - 1` use `... inventory_count - cart_items.quantity`).

Then I needed to efficiently solve a problem with calculating price. 
I didn't want to calculate and update price every time a product was added to the cart so I made two methods in the `Cart model` - `calculate_total` and getter override `total` - this override checks if the cart is completed, if yes, then total column of cart is used, otherwise method `calculate_total` is called and returns sum of prices of all products in cart. 
After completing the cart `total` column is updated to value of `calculate_total` method. This solves a possible race condition problem with displaying price and proceeding to a payment gateway with a different price.

Cart should be available for both guests and logged in users, so for identification of cart I used a cart `token` (random 32bytes string) and `user_id` for logged in users. 
If a cart is created by user, then valid cart token user JWT token belonging to cart user is required to access or modify (add / delete products, ...) the cart. 
If a cart is created by a guest user then only token is required.

Another problem with cart might be that someone wants to modify or add product to an already completed cart or add a product which is out if stock. 
We don't want already completed carts to be manipulated in any way (maybe because of accounting, or statistical purposes).

I made sure to check for these edge cases and show appropriate errors.
While ruby have exceptions (errors) I took advantage of them and made a `ErrorHandler` which renders json response with the error code (string) and sends appropriate http status code if it's raised. For example I needed to display an error in case someone wants to add product to an already completed cart, so I made `Error::Cart::AlreadyCompletedError` which extends `Error::ShopifyError` (base error class) but modifies it's initializer for custom error code (`cart_already_completed`) and message (`Cart has been already completed`).

To make sure that all parts work as expected I wrote tests with as much coverage as I could think of.