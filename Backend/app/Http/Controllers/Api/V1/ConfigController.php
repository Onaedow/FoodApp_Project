<?php

namespace App\Http\Controllers\Api\V1;
use App\Models\Zone;
use App\Models\BusinessSetting;
use App\Models\Currency;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Validator;
use App\CentralLogics\Helpers;
use Grimzy\LaravelMysqlSpatial\Types\Point;


class ConfigController extends Controller
{
        public function geocode_api(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
        ]);

        if ($validator->errors()->count()>0) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }
       
        $response = Http::get('https://maps.googleapis.com/maps/api/geocode/json?latlng='.$request->lat.','.$request->lng.'&key='."AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c");
        return $response->json();
    }
        public function get_zone(Request $request)
    {
          $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
        ]);

        if ($validator->errors()->count()>0) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }
        $point = new Point($request->lat,$request->lng);
        

        $zones = Zone::contains('coordinates', $point)->first();
        if(empty($zones)){
            return response()->json(['code'=>-1,'message'=>'error']);
        }
        return response()->json(['code'=>0,'message'=>'success','data'=>$zones->id]);
      
     
    }
            public function configuration()
    {

       
        $key = ['cash_on_delivery','digital_payment','default_location','order_delivery_verification','canceled_by_deliveryman', 'business_name'];
        $settings =  array_column(BusinessSetting::whereIn('key',$key)->get()->toArray(), 'value', 'key');

        $cod=json_decode(json_encode($settings['cash_on_delivery']),true);

        $digital_payment = json_decode(json_encode($settings['digital_payment']), true);
    
        $currency_symbol = Currency::where(['currency_code' => Helpers::currency_code()])->first()->currency_symbol;
           
        return response()->json([
           
            'business_name'=>$settings['business_name']['content'],
            
            'cash_on_delivery' => (boolean)($cod['status'] == 1 ? true : false),
            'digital_payment' => (boolean)($digital_payment['status'] == 1 ? true : false),
            'base_urls' => [
                'product_image_url' => asset('storage/product'),
                'customer_image_url' => asset('uploads/profile'),
                'business_logo_url' => asset('storage/business'),
                'notification_image_url' => asset('storage/notification'),
                'delivery_man_image_url' => asset('storage/delivery-man'),
            ],
            'order_confirmation_model'=>config('order_confirmation_model'),
            'digit_after_decimal_point' => (int)config('round_up_to_digit'),
            'canceled_by_deliveryman' => (boolean)$settings['canceled_by_deliveryman']["content"],
            'currency_symbol' => $currency_symbol,
            'country' => BusinessSetting::where(['key' => 'country'])->first()->value['content'],
            'default_location'=> [ 'lat'=>'23.757989', 'lng'=> '90.360587' ],
            'maintenance_mode' => (boolean)Helpers::get_business_settings('maintenance_mode')["content"] ?? 0,
            
            'dm_maximum_orders'=>(int)config('dm_maximum_orders'),
            'order_delivery_verification' => (boolean)$settings['order_delivery_verification']["content"],
        ], 200);
    }

    public function place_api_autocomplete(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'search_text' => 'required',
        ]);

        if ($validator->errors()->count()>0) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }
        $response = Http::get('https://maps.googleapis.com/maps/api/place/autocomplete/json?input='.$request['search_text'].'&key='.'AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c');
        return $response->json();
    }

        public function place_api_details(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'placeid' => 'required',
        ]);

        if ($validator->errors()->count()>0) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }
        $response = Http::get('https://maps.googleapis.com/maps/api/place/details/json?placeid='.$request['placeid'].'&key='.'AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c');
        return $response->json();
    }
}
