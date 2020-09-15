<?php

namespace App\Http\Controllers\superadmin;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Work;
use App\Overtimerate;
use App\Member;
use App\Forum;
use App\EmployeePersonalDocument;
use App\EmployeeEducationalDocument;
use Carbon\Carbon;
class DashboardController extends Controller
{
    public function index(){
        $members = Member::where('status',1)->count();
        $newmembers = Member::where('status',0)->count();
        $thismonthworks = Member::get();
    	return view('backEnd.superadmin.dashboard',compact('members','newmembers','thismonthworks'));
    }
    
    
    public function eprofileupdate(Request $request){
        $this->validate($request,[
            'worktarget'=>'required',
        ]);
        $worktarget         =   Employee::find($request->hidden_id);
        $worktarget->worktarget =  $request->worktarget;
        $worktarget->mworktarget =  $request->mworktarget;
        $worktarget->employeetype =  $request->employeetype;
        $worktarget->save();
        Toastr::success('message', 'Employee work target update successfully!');
        return redirect()->back();   
    }

    public function allmember(){
    	$members = Member::get();
    	return view('backEnd.member.allmember',compact('members'));
    }

    public function activemember(){
        $members = Member::where('status',1)->get();
        return view('backEnd.member.activemember',compact('members'));
    }

    public function active(Request $request){
        $accept_data         =   Member::find($request->hidden_id);
        $accept_data->status =  1;
        $accept_data->save();
        Toastr::success('message', 'Member active successfully!');
        return redirect()->back();   
    }
    public function inactivemember(){
        $members = Member::where('status',0)->get();
        return view('backEnd.member.inactivemember',compact('members'));
    }
    public function inactive(Request $request){
        $accept_data         =   Member::find($request->hidden_id);
        $accept_data->status =  0;
        $accept_data->save();
        Toastr::success('message', 'Member inactive successfully!');
        return redirect()->back();   
    }
    
    public function destroy(Request $request){
        $member         =   Member::find($request->hidden_id);
        $member->delete();
        
        Toastr::success('message', 'Member deleted successfully');
        return redirect()->back();
    }
    
    
    
    public function employeeprofile($id){
    	$employeeInfo = Employee::find($id);
    	$monthlyEarn = Work::where(['employeeId'=>$id,'status'=>1])->whereMonth('created_at', Carbon::now()->month)->sum('totalpoint');
    	$totalEarn = Work::where(['employeeId'=>$id,'status'=>1])->sum('totalpoint');
        $thismonthworks = Work::where(['employeeId'=>$id,'status'=>1])->whereMonth('created_at', Carbon::now()->month)->get();
        $employeepersonaldoc =EmployeePersonalDocument::where('employeeId',$id)->get();
        $employeeEducationaldoc = EmployeeEducationalDocument::where('employeeId',$id)->get();
        $forumarticles = Forum::where('status',1)->where('email',$employeeInfo->email)->orderBy('id','DESC')->paginate(30);
    	return view('backEnd.member.profile',compact('employeeInfo','monthlyEarn','totalEarn','thismonthworks','employeepersonaldoc','employeeEducationaldoc','forumarticles'));
    }
}
