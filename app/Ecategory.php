<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Ecategory extends Model
{
     public function esubcategories(){
    	return $this->hasMany('App\Esubcategory')->where('status',1);
    }

    public function educations(){
    return $this->hasMany('App\Education', 'ecategory_id');
	}
}
