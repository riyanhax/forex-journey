<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Esubcategory extends Model
{
    public function ecategory(){
    	return $this->belongsTo('App\Ecategory');
    }

    
}
