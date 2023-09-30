<?php

use Illuminate\Routing\Router;

Admin::routes();

Route::group([
    'prefix'        => config('admin.route.prefix'),
    'namespace'     => config('admin.route.namespace'),
    'middleware'    => config('admin.route.middleware'),
    'as'            => config('admin.route.prefix') . '.',
], function (Router $router) {
    $router->resource('users', UserController::class);
    $router->resource('foods', FoodsController::class);
    $router->resource('food-types', FoodTypeController::class);
    $router->get('/', 'HomeController@index')->name('home');
    $router->resource('orders', OrderController::class);
     $router->resource('business-settings', BusinessSettingController::class);
     $router->resource('zones', ZoneController::class);
     $router->resource('delivery-men', DeliveryMenController::class);


});
