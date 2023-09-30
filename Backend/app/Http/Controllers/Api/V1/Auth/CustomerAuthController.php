<?php

namespace App\Http\Controllers\Api\V1\Auth;
use App\CentralLogics\Helpers;

use App\Http\Controllers\Controller;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Storage;

class CustomerAuthController extends Controller
{
    
     public function login(Request $request)
    {
          $validator = Validator::make($request->all(), [
            'phone' => 'required',
            'password' => 'required|min:6'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }
        $data = [
            'phone' => $request->phone,
            'password' => $request->password
        ];
        
        if (auth()->attempt($data)) {
            //auth()->user() is coming from laravel auth:api middleware
            $token = auth()->user()->createToken('RestaurantCustomerAuth')->accessToken;
            if(!auth()->user()->status)
            {
                $errors = [];
                array_push($errors, ['code' => 'auth-003', 'message' => trans('messages.your_account_is_blocked')]);
                return response()->json([
                    'errors' => $errors
                ], 403);
            }
          
            return response()->json(['token' => $token, 'is_phone_verified'=>auth()->user()->is_phone_verified], 200);
        } else {
            $errors = [];
            array_push($errors, ['code' => 'auth-001', 'message' => 'Phone or password does not match']);
            return response()->json([
                'errors' => $errors
            ], 401);
        }
    }
    /*
    
    if you have the commercial license, use this registration method. and comment out the second method
    
    */
    
    /*
    
           public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'f_name' => 'required',
            //'l_name' => 'required',
            'email' => 'required|unique:users',
            'phone' => 'required|unique:users',
            'sms_code' => 'required',
            'country_code' => 'required',
            'password' => 'required|min:6',
        ], [
            'f_name.required' => 'The first name field is required.',
            'phone.required' => 'The  phone field is required.',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => "Failed Validation"], 403);
        }
        $validator = $request->all();

        $to_number_key = "to_number_".$validator["country_code"].$validator["phone"];
        $sms_code =  $validator["sms_code"];
        $yz_to_number = Cache::get($to_number_key);

        if(empty($yz_to_number)){
            return response()->json(['errors' => "Sms Code Failed Validation"], 403);
        }
        if($yz_to_number!=$sms_code){
            return response()->json(['errors' => "Sms Code Failed Validation"], 403);
        }

        Cache::put($to_number_key,"");

        $user = User::create([
            'f_name' => $request->f_name,
            //'l_name' => $request->l_name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => bcrypt($request->password),
        ]);

        $token = $user->createToken('RestaurantCustomerAuth')->accessToken;


        return response()->json(['token' => $token,'is_phone_verified' => 0, 'phone_verify_end_url'=>"api/v1/auth/verify-phone" ], 200);
    }
    
    */
    
           public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'f_name' => 'required',
            //'l_name' => 'required',
            'email' => 'required|unique:users',
            'phone' => 'required|unique:users',
            'password' => 'required|min:6',
        ], [
            'f_name.required' => 'The first name field is required.',
            'phone.required' => 'The  phone field is required.',
        ]);

        if ($validator->fails()) {
            $errors = Helpers::error_processor($validator);
           
            return response()->json(['errors' => $errors], 403);
        }
        $user = User::create([
            'f_name' => $request->f_name,
            //'l_name' => $request->l_name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => bcrypt($request->password),
        ]);

        $token = $user->createToken('RestaurantCustomerAuth')->accessToken;

       
        return response()->json(['token' => $token,'is_phone_verified' => 0, 'phone_verify_end_url'=>"api/v1/auth/verify-phone" ], 200);
    }
  
        public function upload(Request $request){
       
         $dir="test/";
        
        $image = $request->file('image');
      
        if ($request->has('image')) {
            
                $imageName = \Carbon\Carbon::now()->toDateString() . "-" . uniqid() . "." . "png";
              
              
                if (!Storage::disk('public')->exists($dir)) {
                    Storage::disk('public')->makeDirectory($dir);
                }
                Storage::disk('public')->put($dir.$imageName, file_get_contents($image));
            
        }else{
             return response()->json(['message' => trans('/storage/test/'.'def.png')], 200);
        } 
    //     return response()->json(['message' => $imageName], 200);

 

        $userDetails = [
        
            'image' => $imageName,
         
        ];

        User::where(['id' => 27])->update($userDetails);

        return response()->json(['message' => trans('/storage/test/'.$imageName)], 200);
    }
}
