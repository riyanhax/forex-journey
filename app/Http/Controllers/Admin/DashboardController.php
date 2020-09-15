<?php

namespace App\Http\Controllers\admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use DB;
use Carbon\Carbon;
class DashboardController extends Controller
{
    public function index(){
    	return view('backEnd.superadmin.dashboard');
    }
    public function employeerank(){
         $thismonthranks=DB::table('works')
            ->select('employeeId',DB::raw('SUM(totalpoint) as earntotalpoint'))
            ->where('status',1)
            ->whereMonth('created_at', Carbon::now()->month)
            ->groupBy('employeeId')
            ->limit(10)
            ->orderBy('earntotalpoint','DESC')
            ->get();
         $prevmonthranks=DB::table('works')
            ->select('employeeId',DB::raw('SUM(totalpoint) as earntotalpoint'))
            ->where('status',1)
            ->whereMonth('created_at', Carbon::now()->subMonth())
            ->groupBy('employeeId')
            ->limit(10)
            ->orderBy('earntotalpoint','DESC')
            ->get();
         $anualranks=DB::table('works')
            ->select('employeeId',DB::raw('SUM(totalpoint) as earntotalpoint'))
            ->where('status',1)
            ->whereYear('created_at', Carbon::now()->year)
            ->groupBy('employeeId')
            ->limit(10)
            ->orderBy('earntotalpoint','DESC')
            ->get();
    	return view('backEnd.employee.rank',compact('thismonthranks','prevmonthranks','anualranks'));
    }
}
