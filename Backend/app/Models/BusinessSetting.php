<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Encore\Admin\Traits\DefaultDatetimeFormat;

class BusinessSetting extends Model
{
	use DefaultDatetimeFormat;
    use HasFactory;


    public function getValueAttribute($value){
        $values = "";
        if(is_numeric($value)){
           $value_num = json_encode(["content"=>$value]);
           return json_decode($value_num, true);
        }
        
        if(is_null(json_decode($value))){
            $values = json_encode(["content"=>$value]);
        }else{
            $values = $value;
        }

        return json_decode($values, true);
    }

}
