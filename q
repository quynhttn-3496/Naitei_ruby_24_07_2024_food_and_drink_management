
[1mFrom:[0m /home/tran.thi.nhu.quynh@sun-asterisk.com/Documents/project1/Naitei_ruby_24_07_2024_food_and_drink_management/app/controllers/admin/products_controller.rb:12 Admin::ProductsController#index:

     [1;34m6[0m: [32mdef[0m [1;34mindex[0m
     [1;34m7[0m:   @q = [1;34;4mProduct[0m.ransack(params[[33m:q[0m], [35mauth_object[0m: current_user)
     [1;34m8[0m: 
     [1;34m9[0m:   @pagy, @products = pagy @q.result, [35mlimit[0m: [1;34;4mSettings[0m.page_10
    [1;34m10[0m: 
    [1;34m11[0m:   @category_names = @categories = [1;34;4mCategory[0m.sorted_names.unshift([t([31m[1;31m"[0m[31mall[1;31m"[0m[31m[0m)])
 => [1;34m12[0m:   binding.pry
    [1;34m13[0m: 
    [1;34m14[0m:   @product = [1;34;4mProduct[0m.new
    [1;34m15[0m: [32mend[0m

