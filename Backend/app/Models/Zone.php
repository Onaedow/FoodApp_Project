<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Grimzy\LaravelMysqlSpatial\Eloquent\SpatialTrait;
use Grimzy\LaravelMysqlSpatial\Types\Point;
use Grimzy\LaravelMysqlSpatial\Types\Polygon;
use Grimzy\LaravelMysqlSpatial\Types\LineString;

class Zone extends Model
{
    use HasFactory;
    use SpatialTrait;

    protected $spatialFields = [
        'coordinates'
    ];


    public function orders()
    {
        return $this->hasManyThrough(Order::class);
    }

    public function deliverymen()
    {
        return $this->hasMany(DeliveryMan::class);
    }

    public function scopeActive($query)
    {
        return $query->where('status', '=', 1);
    }

    public function getCoordinatesAttribute($value)
    {
        if($value){

        $data_str = "";
        foreach($value as $coord)
        {
            foreach ($coord as $val){
                $data_str = $data_str."({$val->getlat()},{$val->getlng()}),";
            }
        }
        return substr($data_str,0,-1);
        }
        return $value;
    }

    public function setCoordinatesAttribute($value)
    {

        $lastcord = [];
        $polygon= [];
        foreach(explode('),(',trim($value,'()')) as $index=>$single_array){
            if($index == 0)
            {
                $lastcord = explode(',',$single_array);
            }
            $coords = explode(',',$single_array);
            $polygon[] = new Point($coords[0], $coords[1]);
        }
        $polygon[] = new Point($lastcord[0], $lastcord[1]);
        $coordinates = new Polygon([new LineString($polygon)]);
        $this->attributes['coordinates'] = $coordinates;

    }
}
