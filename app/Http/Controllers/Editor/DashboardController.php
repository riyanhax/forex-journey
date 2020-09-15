<?php

namespace App\Http\Controllers\editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Forum;
use App\Employee;
class DashboardController extends Controller
{
    public function index(){
        
    	return redirect('/logout');
    }
    public function forum(){
    	  $forumarticles = Forum::where('status',1)->orderBy('id','DESC')->paginate(30);
          $onlineEmployees = Employee::where('online',1)->get();
    	return view('backEnd.superadmin.forum',compact('forumarticles','onlineEmployees'));
    }
}
