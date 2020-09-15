<?php

namespace App\Http\Controllers\admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Circuler;
use File;
class CirculerController extends Controller
{
    
    public function create(){
    	return view('backEnd.circuler.create');
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'designation'=>'required',
    		'location'=>'required',
    		'salary'=>'required',
    		'shortdescription'=>'required',
    		'exprience'=>'required',
    		'jobresponsibility'=>'required',
    		'expaire'=>'required',
    		'status'=>'required',
    	]);

    	$store_data = new Circuler();
    	$store_data->designation = $request->designation;
    	$store_data->location = $request->location;
    	$store_data->shortdescription = $request->shortdescription;
    	$store_data->exprience = $request->exprience;
    	$store_data->salary = $request->salary;
    	$store_data->jobresponsibility = $request->jobresponsibility;
    	$store_data->expaire = $request->expaire;
    	$store_data->status = $request->status;
    	$store_data->save();
        Toastr::success('message', 'Circuler add successfully!');
    	return redirect('admin/circuler/manage');
    }
    public function manage(){
    	$show_data = Circuler::get();
        return view('backEnd.circuler.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Circuler::find($id);
        return view('backEnd.circuler.edit', compact('edit_data'));
    }
     public function update(Request $request){
        $this->validate($request,[
            'status'=>'required',
        ]);

        $update_data = Circuler::find($request->hidden_id);

        $update_data->designation = $request->designation;
    	$update_data->location = $request->location;
    	$update_data->shortdescription = $request->shortdescription;
    	$update_data->exprience = $request->exprience;
    	$update_data->salary = $request->salary;
    	$update_data->jobresponsibility = $request->jobresponsibility;
    	$update_data->expaire = $request->expaire;
        $update_data->status = $request->status;
        $update_data->save();
        Toastr::success('message', 'Circuler  update successfully!');
        return redirect('admin/circuler/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Circuler::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Circuler  uppublished successfully!');
        return redirect('admin/circuler/manage');
    }

    public function active(Request $request){
        $publishId = Circuler::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Circuler  uppublished successfully!');
        return redirect('admin/circuler/manage');
    }
     public function destroy(Request $request){
        $delete_data = Circuler::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Circuler delete successfully!');
        return redirect('admin/circuler/manage');
    }
}
