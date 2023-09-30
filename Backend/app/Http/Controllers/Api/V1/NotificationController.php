<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use App\Models\UserNotification;
use Illuminate\Support\Facades\Cache;
use Google\Auth;
use Twilio\Rest\Client;
use Google\Auth\AccessToken;
use Illuminate\Http\Request;
use App\CentralLogics\Helpers;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\ApnsConfig;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Message;
use Kreait\Firebase\Messaging\MessageData;
use Kreait\Firebase\Messaging\Notification as FirebaseNotification;
use Kreait\Firebase\Messaging\RawMessageFromArray;
use Kreait\Firebase\Messaging\WebPushConfig;

use Grimzy\LaravelMysqlSpatial\Types\Point;
use Grimzy\LaravelMysqlSpatial\Types\Polygon;
use Grimzy\LaravelMysqlSpatial\Types\LineString;


class NotificationController extends Controller
{
    
    public function get_notifications(Request $request){

        /*if (!$request->hasHeader('zoneId')) {
            $errors = [];
            array_push($errors, ['code' => 'zoneId', 'message' => 'Zone id is required!']);
            return response()->json([
                'errors' => $errors
            ], 403);
        }
        $zone_id= $request->header('zoneId');*/
        $zone_id=1;
        try {
            $notifications = Notification::active()->where('target', 'customer')->where(function($q)use($zone_id){
               // $q->whereNull('zone_id')->orWhere('zone_id', $zone_id);
            })->where('created_at', '>=', \Carbon\Carbon::today()->subDays(15))->get();
            $notifications->append('data');

            $user_notifications = UserNotification::where('user_id', $request->user()->id)->where('created_at', '>=', \Carbon\Carbon::today()->subDays(15))->get();
            $notifications =  $notifications->merge($user_notifications);
            return response()->json($notifications, 200);
        } catch (\Exception $e) {
            return response()->json([], 200);
        }
    }

    public function send_token(Request $request){
        $push_token = $request->get("push_token");
                $factory = (new Factory)
                    ->withServiceAccount(app()->basePath().'/dbestech-food-app-commercial-firebase-adminsdk-aaz7n-8ebfd8687b.json')
                    ->withDatabaseUri('https://dbestech-food-app-commercial.firebaseio.com/');
        $messaging = $factory->createMessaging();
        if($push_token){
            $messaging->subscribeToTopic("push_new_order",$push_token);
        }
        return response()->json([], 200);
    }

    public function send_msg(Request $request){



          //  $scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
          //  $res = new Auth\Credentials\ServiceAccountJwtAccessCredentials(app()->basePath().'/valiant-monitor-352501-firebase-adminsdk-uw71x-9c5b4ea659.json',$scopes);

        //    dump($res->fetchAuthToken());

          //  $factory = (new Factory)->withServiceAccount(app()->basePath().'/valiant-monitor-352501-firebase-adminsdk-uw71x-9c5b4ea659.json');
           // $jwtClient = $factory->;
          //  dump($jwtClient);
        try {
            $factory = (new Factory)
                    ->withServiceAccount(app()->basePath().'/dbestech-food-app-commercial-firebase-adminsdk-aaz7n-8ebfd8687b.json')
                    ->withDatabaseUri('https://dbestech-food-app-commercial.firebaseio.com/');
           $messaging = $factory->createMessaging();
           $message = CloudMessage::withTarget("topic","push_new_order")
               ->withNotification(["title"=> "new order","body"=> "new order","image"=> ""]);
           $messaging->send($message);



        }catch (\Exception $exception){

        }

    }
    
        public function send_verification(Request $request){



        $country_code =  $request->input("country_code");
        $phone = $request->input("phone");
        if(empty($country_code)){
            return response()->json(['code'=>-1,'data' => '','msg' => "country_code not empty!"], 200);
        }
        if(empty($phone)){
            return response()->json(['code'=>-1,'data' => '','msg' => "phone not empty!"], 200);
        }
        $sid = 'ACf313d5dec46f28738a46da4211e40b78';
        $token = 'eb22339b3d7d4352be742af484b70c1e';
        $client = new Client($sid, $token);
        $code = rand(1111,9999);

        $to_number = "+".$country_code.$phone;

        Cache::put("to_number_".$country_code.$phone,$code);
        $body = "SMS verification code: ".$code;

        // Use the client to do fun stuff like send text messages!
        $message = $client->messages->create(
            // the number you'd like to send the message to
            $to_number,
            [
                // A Twilio phone number you purchased at twilio.com/console
                "messagingServiceSid" => "MG0aa4f5254bf71325e20900db1636618d",
                // the body of the text message you'd like to send
                'body' => $body
            ]
        );

        return response()->json(['code'=>0,'data' => $message->sid,'msg' => ''], 200);

    }

}
