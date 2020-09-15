<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Education extends Model
{
   public function ecategories(){
    return $this->belongsTo('App\Ecategory', 'ecategory_id');
	}
}
