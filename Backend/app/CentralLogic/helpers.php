<?php

namespace App\CentralLogics;


use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Storage;
use App\Models\BusinessSetting;
use Illuminate\Support\Facades\DB;

use Illuminate\Support\Facades\Mail;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;

//use App\Mail\OrderPlaced;

class Helpers
{
    public static function error_processor($validator)
    {
        $err_keeper = [];
        foreach ($validator->errors()->getMessages() as $index => $error) {
            array_push($err_keeper, ['code' => $index, 'message' => $error[0]]);
        }
        return $err_keeper;
    }
        public static function get_business_settings($name)
    {
        $config = null;

        $paymentmethod = BusinessSetting::where('key', $name)->first();

     
        if ($paymentmethod) {

            $config = json_decode(json_encode($paymentmethod->value), true);
          
           
        }


        return $config;
    }
          public static function currency_code()
    {
        return BusinessSetting::where(['key' => 'currency'])->first()->value['content'];
    }
        public static function upload(string $dir, string $format, $image = null)
    {
        if ($image != null) {
            $imageName = \Carbon\Carbon::now()->toDateString() . "-" . uniqid() . "." . $format;
            if (!Storage::disk('public')->exists($dir)) {
                Storage::disk('public')->makeDirectory($dir);
            }
            Storage::disk('public')->put($dir . $imageName, file_get_contents($image));
         
        } else {
            $imageName = 'def.png';
        }
       
        return $imageName;
    }
        public static function update(string $dir, $old_image, string $format, $image = null)
    {

        if($image == null)
        {
            return $old_image;
        }
        /*if(Storage::exists($dir)){
             return response()->json(['message' => trans('ok')], 200);
        }*/


        if (Storage::disk('public')->exists($dir . $old_image)) {

            Storage::disk('public')->delete($dir . $old_image);
        }

        $imageName = Helpers::upload($dir, $format, $image);
        return $imageName;
    }
    
    public static function send_restaurant_notification($msg){
         try {
                   
                   $factory = (new Factory)
                    ->withServiceAccount(app()->basePath().'/dbestech-food-app-commercial-firebase-adminsdk-aaz7n-8ebfd8687b.json')
                    ->withDatabaseUri('https://dbestech-food-app-commercial.firebaseio.com/');
                    $messaging = $factory->createMessaging();
                    $message = CloudMessage::withTarget("topic","push_new_order")->withNotification(["title"=> $msg['title'],"body"=> $msg['body'],"image"=> ""]);
                    $messaging->send($message);
                }catch (\Throwable $th){
                     return response()->json([
                        'status' => false,
                        'message' => $th->getMessage()
                    ], 500);
                }
    }
        //both delivery man and users get notifcaiton through this
        public static function send_order_notification($order, $token){

        try {
            $status = $order->order_status;

            $value = self::order_status_update_message($status);
  

         
          
            if ($value) {

                $data = [
                    'title' =>trans('messages.order_push_title'),
                    'description' => $value,
                    'order_id' => $order->id,
                    'image' => '',
                    'type'=>'order_status',
                ];

       

                self::send_push_notif_to_device($token, $data);
               
               /* try {
                   
                   $factory = (new Factory)
                    ->withServiceAccount(app()->basePath().'/dbestech-food-app-commercial-firebase-adminsdk-aaz7n-8ebfd8687b.json')
                    ->withDatabaseUri('https://dbestech-food-app-commercial.firebaseio.com/');
                    $messaging = $factory->createMessaging();
                    $message = CloudMessage::withTarget("topic","push_new_order")->withNotification(["title"=> "new order","body"=> "new order","image"=> ""]);
                    $messaging->send($message);
                }catch (\Throwable $th){
                     return response()->json([
                        'status' => false,
                        'message' => $th->getMessage()
                    ], 500);
                }*/
                $msg=[
                    'title'=>'new_order',
                    'body'=>'new order'
                    
                    ];
                self::send_restaurant_notification($msg);

              try{
                DB::table('user_notifications')->insert([
                    'data'=> json_encode($data),
                    'user_id'=>$order->user_id,
                    'created_at'=>now(),
                    'updated_at'=>now()
                ]);

                    } catch (\Exception $e) {

            return response()->json([$e], 403);
        }
            }


            if($status == 'picked_up')
            {
                $data = [
                    'title' =>trans('messages.order_push_title'),
                    'description' => $value,
                    'order_id' => $order->id,
                    'image' => '',
                    'type'=>'order_status',
                ];
              //  self::send_push_notif_to_device($order->restaurant->vendor->firebase_token, $data);
                DB::table('user_notifications')->insert([
                    'data'=> json_encode($data),
                    'vendor_id'=>$order->restaurant->vendor_id,
                    'created_at'=>now(),
                    'updated_at'=>now()
                ]);
            }

            /*
            not this
            */
            if($order->order_type == 'delivery' && !$order->scheduled && $order->order_status == 'pending' && $order->payment_method == 'cash_on_delivery' && config('order_confirmation_model') == 'deliveryman' && $order->order_type != 'take_away')
            {
                //below code is needed if it's resturant's self delivery system
                /*if($order->restaurant->self_delivery_system)
                {
                    $data = [
                        'title' =>trans('messages.order_push_title'),
                        'description' => trans('messages.new_order_push_description'),
                        'order_id' => $order->id,
                        'image' => '',
                        'type'=>'new_order',
                    ];
                 //   self::send_push_notif_to_device($order->restaurant->vendor->firebase_token, $data);
                    DB::table('user_notifications')->insert([
                        'data'=> json_encode($data),
                        'vendor_id'=>$order->restaurant->vendor_id,
                        'created_at'=>now(),
                        'updated_at'=>now()
                    ]);
                }
                else*/
                {
                    $data = [
                        'title' =>trans('messages.order_push_title'),
                        'description' => trans('messages.new_order_push_description'),
                        'order_id' => $order->id,
                        'image' => '',
                    ];
                //    self::send_push_notif_to_topic($data, $order->restaurant->zone->deliveryman_wise_topic, 'order_request');
                }
            }


            if(!$order->scheduled && (($order->order_type == 'take_away' && $order->order_status == 'pending') || ($order->payment_method != 'cash_on_delivery' && $order->order_status == 'confirmed')))
            {
                $data = [
                    'title' =>trans('messages.order_push_title'),
                    'description' => trans('messages.new_order_push_description'),
                    'order_id' => $order->id,
                    'image' => '',
                    'type'=>'new_order',
                ];
             //   self::send_push_notif_to_device($order->restaurant->vendor->firebase_token, $data);
                DB::table('user_notifications')->insert([
                    'data'=> json_encode($data),
                    'vendor_id'=>$order->restaurant->vendor_id,
                    'created_at'=>now(),
                    'updated_at'=>now()
                ]);
            }
            //this also gets called when delivery man accetps order
            if($order->order_status == 'confirmed' && $order->order_type != 'take_away' && config('order_confirmation_model') == 'deliveryman' && $order->payment_method == 'cash_on_delivery')
            {


                    $data = [
                        'title' =>trans('messages.order_push_title'),
                        'description' => trans('messages.new_order_push_description'),
                        'order_id' => $order->id,
                        'image' => '',
                        'type'=>'new_order',
                    ];
                 //   self::send_push_notif_to_device($order->restaurant->vendor->firebase_token, $data);
                    DB::table('user_notifications')->insert([
                        'data'=> json_encode($data),
                        'vendor_id'=>$order->restaurant->vendor_id,
                        'created_at'=>now(),
                        'updated_at'=>now()
                    ]);

            }



            if(in_array($order->order_status, ['processing', 'handover']) && $order->delivery_man)
            {
                $data = [
                    'title' =>trans('messages.order_push_title'),
                    'description' => $order->order_status=='processing'?trans('messages.Proceed_for_cooking'):trans('messages.ready_for_delivery'),
                    'order_id' => $order->id,
                    'image' => '',
                    'type'=>'order_status'
                ];
             //   self::send_push_notif_to_device($order->delivery_man->fcm_token, $data);
                DB::table('user_notifications')->insert([
                    'data'=> json_encode($data),
                    'delivery_man_id'=>$order->delivery_man->id,
                    'created_at'=>now(),
                    'updated_at'=>now()
                ]);
            }


            try{
                if($order->order_status == 'confirmed' && $order->payment_method != 'cash_on_delivery' && config('mail.status'))
                {
                   // Mail::to($order->customer->email)->send(new OrderPlaced($order->id));

                }

            }catch (\Exception $ex) {
                info($ex);
            }
            return true;

        } catch (\Exception $e) {
            print_r($e);
           // die();
           // info($e);
        }
        return false;
    }
           public static function send_push_notif_to_device($fcm_token, $data, $delivery=0)
    {
        $key=0;
        if($delivery==1){
             $key = BusinessSetting::where(['key' => 'delivery_boy_push_notification_key'])->first()->value;
        }else{
            $key = BusinessSetting::where(['key' => 'push_notification_key'])->first()->value;
        }
        
        $url = "https://fcm.googleapis.com/fcm/send";
        $header = array("authorization: key=" . $key['content'] . "",
            "content-type: application/json"
        );

        $postdata = '{
            "to" : "' . $fcm_token . '",
            "mutable_content": true,
            "data" : {
                "title":"' . $data['title'] . '",
                "body" : "' . $data['description'] . '",
                "order_id":"' . $data['order_id'] . '",
                "type":"' . $data['type'] . '",
                "is_read": 0
            },
            "notification" : {
                "title" :"' . $data['title'] . '",
                "body" : "' . $data['description'] . '",
                "order_id":"' . $data['order_id'] . '",
                "title_loc_key":"' . $data['order_id'] . '",
                "body_loc_key":"' . $data['type'] . '",
                "type":"' . $data['type'] . '",
                "is_read": 0,
                "icon" : "new",
                "android_channel_id": "dbfood"
            }
        }';


        $ch = curl_init();
        $timeout = 120;
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $header);

        // Get URL content
        $result = curl_exec($ch);
          if ($result === FALSE) {
          dd( curl_error($ch));
      }


        curl_close($ch);

        return $result;
    }
       public static function order_status_update_message($status)
    {

        if ($status == 'pending') {

            $data = BusinessSetting::where('key', 'order_pending_message')->first();
           

        } elseif ($status == 'confirmed') {
            $data = BusinessSetting::where('key', 'order_confirmation_msg')->first();
         
           
        } elseif ($status == 'processing') {
            $data = BusinessSetting::where('key', 'order_processing_message')->first();
        } elseif ($status == 'picked_up') {
            $data = BusinessSetting::where('key', 'out_for_delivery_message')->first();
        } elseif ($status == 'handover') {
            $data = BusinessSetting::where('key', 'order_handover_message')->first();
        } elseif ($status == 'delivered') {
            $data = BusinessSetting::where('key', 'order_delivered_message')->first();
        }
        elseif ($status == 'delivery_boy_delivered') {
            $data = BusinessSetting::where('key', 'delivery_boy_delivered_message')->first();
        }
        elseif ($status == 'accepted') {
            $data = BusinessSetting::where('key', 'delivery_boy_assign_message')->first();
        } 
        elseif ($status == 'canceled') {
            $data = BusinessSetting::where('key', 'order_cancled_message')->first();
        }
        elseif ($status == 'refunded') {
            $data = BusinessSetting::where('key', 'order_refunded_message')->first();
        }
        else {
           $data = BusinessSetting::where('key', 'order_payment_message')->first();
        }
     
        //$res = json_decode($data['key'], true);
       // print_r($data['value']['message']);
       // die();
       // if ($res['status'] == 0) {
        //    return 0;
       // }
    
        return $data['value']['message'];
    }
        public static function order_details_data_formatting($data)
    {
        $storage = [];
        foreach ($data as $item) {

            $item['food_details'] = json_decode($item['food_details'], true);
            array_push($storage, $item);
        }
        $data = $storage;

        return $data;
    }
        public static function order_data_formatting($data, $multi_data = false)
    {
        $storage = [];
        if($multi_data)
        {
            foreach ($data as $item) {
               
                
        

                $item['delivery_address'] = $item->delivery_address?json_decode($item->delivery_address, true): null;
                $item['details_count'] = (integer)$item->details->count();
                unset($item['details']);
                array_push($storage, $item);
            }
            $data = $storage;
        }
        else
        {
           

            $data['delivery_address'] = $data->delivery_address?json_decode($data->delivery_address, true): null;
            $data['details_count'] = (integer)$data->details->count();
            unset($data['details']);
        }
        return $data;
    }
}
