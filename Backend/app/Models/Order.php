<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;
use Encore\Admin\Traits\DefaultDatetimeFormat;


class Order extends Model
{
    use DefaultDatetimeFormat;


    protected $casts = [
        'order_amount' => 'float',
        'total_tax_amount' => 'float',
        'delivery_address_id' => 'integer',
        'delivery_charge' => 'float',
        'user_id' => 'integer',
        'scheduled' => 'integer',
        'details_count' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    public function setDeliveryChargeAttribute($value)
    {
        $this->attributes['delivery_charge'] = round($value, 3);
    }

    public function details()
    {
        return $this->hasMany(OrderDetail::class);
    }
       public function scopeNotpos($query)
    {
        return $query->where('order_type', '<>' , 'pos');
    }
        public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
        public function delivery_man()
    {
        return $this->belongsTo(DeliveryMan::class, 'delivery_man_id');
    }
    public function scopeOrderScheduledIn($query, $interval)
    {
        return $query->where(function($query)use($interval){
            $query->whereRaw('created_at <> scheduled_at')->where(function($q) use ($interval) {
            $q->whereBetween('scheduled_at', [Carbon::now()->toDateTimeString(),Carbon::now()->addMinutes($interval)->toDateTimeString()]); 
            })->orWhere('scheduled_at','<',Carbon::now()->toDateTimeString());
        })->orWhereRaw('created_at = scheduled_at');
        
    }
    public function Type(){
        return $this->hasOne(Type::class, 'type_id', 'type_id');
    }
 
}