<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    use HasFactory;
    public function article(){
        return $this->hasOne(ArticleType::class, 'id', 'type_id');
    }
}
