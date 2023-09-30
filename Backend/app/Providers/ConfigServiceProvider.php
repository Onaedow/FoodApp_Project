<?php

namespace App\Providers;

use App\Models\BusinessSetting;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\ServiceProvider;
use Carbon\Carbon;
use phpDocumentor\Reflection\Types\Boolean;

Carbon::setWeekStartsAt(Carbon::MONDAY);
Carbon::setWeekEndsAt(Carbon::SUNDAY);
class ConfigServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        $mode = env('APP_MODE');

        try {

            $data = BusinessSetting::where(['key' => 'paypal'])->first();
          //  dump($data->value);
            //$paypal = json_decode($data->value, true);
            $paypal = $data->value;
            if ($paypal) {

                if ($mode == 'live') {
                    $paypal_mode = "live";
                } else {
                    $paypal_mode = "sandbox";
                }

                $config = array(
                    'client_id' => $paypal['paypal_client_id'], // values : (local | production)
                    'secret' => $paypal['paypal_secret_id'],
                    'settings' => array(
                        'mode' => env('PAYPAL_MODE', $paypal_mode), //live||sandbox
                        'http.ConnectionTimeOut' => 30,
                        'log.LogEnabled' => true,
                        'log.FileName' => storage_path() . '/logs/paypal.log',
                        'log.LogLevel' => 'ERROR'
                    ),
                );
                Config::set('paypal', $config);
            }


            $odv = BusinessSetting::where(['key' => 'order_delivery_verification'])->first();
            if ($odv) {
                Config::set('order_delivery_verification', ($odv->value)["content"]);
            } else {
                Config::set('order_delivery_verification', 0);
            }


            $round_up_to_digit = BusinessSetting::where(['key' => 'digit_after_decimal_point'])->first();
            if ($round_up_to_digit) {
               
                Config::set('round_up_to_digit', ($round_up_to_digit->value)["content"]);
            } else {
                Config::set('round_up_to_digit', 2);
            }

            $dm_maximum_orders = BusinessSetting::where(['key' => 'dm_maximum_orders'])->first();
            
       
          
            if ($dm_maximum_orders) {
                Config::set('dm_maximum_orders', ($dm_maximum_orders->value)["content"]);
         
            } else {
                Config::set('dm_maximum_orders', 1);
            }

            $order_confirmation_model = BusinessSetting::where(['key' => 'order_confirmation_model'])->first();
            if ($order_confirmation_model) {
                Config::set('order_confirmation_model', ($order_confirmation_model->value)["content"]);
            } else {
                Config::set('order_confirmation_model', 'deliveryman');
            }

            $timeformat = BusinessSetting::where(['key' => 'timeformat'])->first();
            if ($timeformat && $timeformat->value == '12') {
                Config::set('timeformat', 'h:i:a');
            }
            else{
                Config::set('timeformat', 'H:i');
            }

            $canceled_by_restaurant = BusinessSetting::where(['key' => 'canceled_by_restaurant'])->first();
            if ($canceled_by_restaurant) {
                Config::set('canceled_by_restaurant', (boolean)$canceled_by_restaurant->value);
            }

            $canceled_by_deliveryman = BusinessSetting::where(['key' => 'canceled_by_deliveryman'])->first();
            if ($canceled_by_deliveryman) {
                Config::set('canceled_by_deliveryman', (boolean)($canceled_by_deliveryman->value)["content"]);
            }
            
       


        } catch (\Exception $ex) {
           // print_r($ex);
          //  die();
        }
    }
}
