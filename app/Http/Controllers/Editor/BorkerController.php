<?php

namespace App\Http\Controllers\Editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Broker;
use File;

class BorkerController extends Controller
{
   public function create(){
    	return view('backEnd.broker.create');
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'image'=>'required',
    		'status'=>'required',
    		'name'=>'required',
    	]);

    	// image upload
    	$file = $request->file('image');
    	$name = $file->getClientOriginalName();
    	$uploadPath = 'public/uploads/broker/';
    	$file->move($uploadPath,$name);
    	$fileUrl =$uploadPath.$name;

    	$store_data = new Broker();
    	$store_data->image = $fileUrl;
    	$store_data->broker_name = $request->name;
    	$store_data->mindiposit = $request->mindiposit;
    	$store_data->minspread = $request->minspread;
    	$store_data->maxleverage = $request->maxleverage;
    	$store_data->dipositbonus = $request->dipositbonus;
    	$store_data->welbonus = $request->welbonus;
    	$store_data->currencypairs = $request->currencypairs;
    	$store_data->increments = $request->increments;
    	$store_data->platforms = $request->platforms;
    	$store_data->typebroker = $request->typebroker;
    	$store_data->regulatedby = $request->regulatedby;
    	$store_data->established = $request->established;
    	$store_data->headquater = $request->headquater;
    	$store_data->reviewlink = $request->reviewlink;
    	$store_data->visitlink = $request->visitlink;
    	$store_data->status = $request->status;
    	$store_data->save();
        Toastr::success('message', 'Broker add successfully!');
    	return redirect('editor/broker/manage');
    }
    public function manage(){
    	$show_data = Broker::get();
        return view('backEnd.broker.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Broker::find($id);
        return view('backEnd.broker.edit',compact('edit_data'));
    }
     public function update(Request $request){
        $this->validate($request,[
            'status'=>'required',
            'name'=>'required',
        ]);

        $update_data = Broker::find($request->hidden_id);
         $update_image = $request->file('image');
        if ($update_image) {
           $file = $request->file('image');
            $name = $file->getClientOriginalName();
            $uploadPath = 'public/uploads/broker/';
            File::delete(public_path() . 'public/uploads/broker', $update_data->image);
            $file->move($uploadPath,$name);
            $fileUrl =$uploadPath.$name;
        }else{
            $fileUrl = $update_data->image;
        }
        $update_data->broker_name = $request->name;
        $update_data->image = $fileUrl;
    	$update_data->mindiposit = $request->mindiposit;
    	$update_data->minspread = $request->minspread;
    	$update_data->maxleverage = $request->maxleverage;
    	$update_data->dipositbonus = $request->dipositbonus;
    	$update_data->welbonus = $request->welbonus;
    	$update_data->currencypairs = $request->currencypairs;
    	$update_data->increments = $request->increments;
    	$update_data->platforms = $request->platforms;
    	$update_data->typebroker = $request->typebroker;
    	$update_data->regulatedby = $request->regulatedby;
    	$update_data->established = $request->established;
    	$update_data->headquater = $request->headquater;
    	$update_data->reviewlink = $request->reviewlink;
    	$update_data->visitlink = $request->visitlink;
    	$update_data->status = $request->status;
        $update_data->save();
        Toastr::success('message', 'Broker  update successfully!');
        return redirect('editor/broker/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Broker::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Broker  uppublished successfully!');
        return redirect('editor/broker/manage');
    }

    public function active(Request $request){
        $publishId = Broker::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Broker  upSpublished successfully!');
        return redirect('editor/broker/manage');
    }
     public function destroy(Request $request){
        $delete_data = Broker::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Broker delete successfully!');
        return redirect('editor/broker/manage');
    }
}
