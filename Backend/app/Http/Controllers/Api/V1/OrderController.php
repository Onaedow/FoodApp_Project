<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\CentralLogics\Helpers;
use App\Models\Food;
use App\Models\Order;
use App\Models\OrderDetail;
use App\Models\OrderTrack;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
        public function place_order(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_amount' => 'required',
            'address' => 'required_if:order_type,delivery',
            //'longitude' => 'required_if:order_type,delivery',
           // 'latitude' => 'required_if:order_type,delivery',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $address = [
            'contact_person_name' => $request->contact_person_name?$request->contact_person_name:$request->user()->f_name.' '.$request->user()->f_name,
            'contact_person_number' => $request->contact_person_number?$request->contact_person_number:$request->user()->phone,
            'address' => $request->address,
            'longitude' => (string)$request->longitude,
            'latitude' => (string)$request->latitude,
        ];

        $product_price = 0;

        $order = new Order();
        $order->id = 100000 + Order::all()->count() + 1; //checked
        $order->user_id = $request->user()->id; //checked
        $order->order_amount = $request['order_amount']; //checked
        $order->order_note = $request['order_note']; //checked
        $order->delivery_address = json_encode($address); //checked
        $order->otp = rand(1000, 9999); //checked
        $order->pending = now(); //checked
        $order->created_at = now(); //checked
        $order->updated_at = now();//checked
          $order->order_type = $request['order_type'];
        /*
            newly added
        */
        $order->payment_status = $request['payment_method']=='wallet'?'paid':'unpaid';
        $order->order_status = $request['payment_method']=='digital_payment'?'failed':($request->payment_method == 'wallet'?'confirmed':'pending');
        $order->payment_method = $request->payment_method;

        $scheduled_at = $request->scheduled_at?\Carbon\Carbon::parse($request->scheduled_at):now();
        if($request->scheduled_at && $scheduled_at < now())
        {
            return response()->json([
                'errors' => [
                    ['code' => 'order_time', 'message' => trans('messages.you_can_not_schedule_a_order_in_past')]
                ]
            ], 406);
        }
        $order->scheduled_at = $scheduled_at;
        $order->scheduled = $request->scheduled_at?1:0;

        /*
                ends here
        */
        foreach ($request['cart'] as $c) {

                $product = Food::find($c['id']); //checked
                if ($product) {

                    $price = $product['price']; //checked

                    $or_d = [
                        'food_id' => $c['id'], //checked
                        'food_details' => json_encode($product),
                        'quantity' => $c['quantity'], //checked
                        'price' => $price, //checked
                        'created_at' => now(), //checked
                        'updated_at' => now(), //checked
                        'tax_amount' => 10.0
                    ];

                    $product_price += $price*$or_d['quantity'];
                    $order_details[] = $or_d;
                } else {
                    return response()->json([
                        'errors' => [
                            ['code' => 'food', 'message' => 'not found!']
                        ]
                    ], 401);
                }
        }


        try {
            $status = OrderTrack::where('order_status', $order->order_status)->first();
            $order->status_id=$status->id;
            $save_order= $order->id;
            $total_price= $product_price;
            $order->order_amount = $total_price;
            $order->save();

            foreach ($order_details as $key => $item) {
                $order_details[$key]['order_id'] = $order->id;
            }
            /*
            insert method takes array of arrays and insert each array in the database as a record.
            insert method is part of query builder
            */
            OrderDetail::insert($order_details);

            /*
                newly added for sending notifications
            */
     
           Helpers::send_order_notification($order, $request->user()->cm_firebase_token);
            
                    /*
                        ends here
                    */

            return response()->json([
                'message' => trans('messages.order_placed_successfully'),
                'order_id' =>  $save_order,
                'total_ammount' => $total_price,

            ], 200);
        } catch (\Exception $e) {
            return response()->json([$e], 403);
        }

        return response()->json([
            'errors' => [
                ['code' => 'order_time', 'message' => trans('messages.failed_to_place_order')]
            ]
        ], 403);
    }

    public function get_order_list(Request $request)
    {
        $orders = Order::withCount('details')->where(['user_id' => $request->user()->id])->get()->map(function ($data) {
            $data['delivery_address'] = $data['delivery_address']?json_decode($data['delivery_address']):$data['delivery_address'];

            return $data;
        });
        return response()->json($orders, 200);
    }
        public function get_order_details(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_id' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }



        $details = OrderDetail::whereHas('order', function($query)use($request){
            return $query->where('user_id', $request->user()->id);
        })->where(['order_id' => $request['order_id']])->get();


        if ($details->count() > 0) {
            unset($details['food_details']);
            // $details = Helpers::order_details_data_formatting($details);
            return response()->json($details, 200);
        } else {
            return response()->json([
                'errors' => [
                    ['code' => 'order', 'message' => trans('messages.not_found')]
                ]
            ], 401);
        }
    }
      public function track_order(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_id' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $order = Order::where(['id' => $request['order_id'], 'user_id' => $request->user()->id])->Notpos()->first();
        if($order)
        {

            $order['delivery_address'] = $order['delivery_address']?json_decode($order['delivery_address']):$order['delivery_address'];

            unset($order['details']);
        }
        else
        {
            return response()->json([
                'errors' => [
                    ['code' => 'scheduled_at', 'message' => trans('messages.not_found')]
                ]
            ], 404);
        }
        return response()->json($order, 200);
    }

   public function get_new_order(Request $request){
       $res = Order::orderBy("id","desc")->first();
      
       if(empty($res)){
           return response()->json(["code"=>-1], 200);
       }
       $id = $res->id;
       $order_new_id = cache()->get("order_new_id");
      
       if(empty($order_new_id)){
           cache()->put("order_new_id",$id);
           return response()->json(["code"=>-1], 200);
       }
       
       if($order_new_id < $id){
           cache()->put("order_new_id",$id);
           return response()->json(["code"=>0,"data"=>$id], 200);
       }else{
           cache()->put("order_new_id",$id);
       }
       return response()->json(["code"=>-1,"data"=>$order_new_id], 200);
    }

}
