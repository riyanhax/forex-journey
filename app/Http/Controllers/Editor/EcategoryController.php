<?php

namespace App\Http\Controllers\Editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Ecategory;
use File;

class EcategoryController extends Controller
{
     public function create(){
    	return view('backEnd.ecategory.create');
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'name'=>'required',
    		'status'=>'required',
    	]);


    	$store_data = new Ecategory();
    	$store_data->name = $request->name;
    	$store_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->name)));
    	$store_data->status = $request->status;
    	$store_data->save();
        Toastr::success('message', 'Education Category add successfully!');
    	return redirect('editor/ecategory/manage');
    }
    public function manage(){
    	$show_data = Ecategory::get();
        return view('backEnd.ecategory.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Ecategory::find($id);
        return view('backEnd.ecategory.edit',compact('edit_data'));
    }
     public function update(Request $request){
        $this->validate($request,[
            'name'=>'required',
            'status'=>'required',
        ]);

        $update_data = Ecategory::find($request->hidden_id);
        $update_data->name = $request->name;
        $update_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->name)));
        $update_data->status = $request->status;
        $update_data->save();
        Toastr::success('message', 'Education Category  update successfully!');
        return redirect('editor/ecategory/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Ecategory::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Education Category  uppublished successfully!');
        return redirect('editor/ecategory/manage');
    }

    public function active(Request $request){
        $publishId = Ecategory::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Education Category  upSpublished successfully!');
        return redirect('editor/ecategory/manage');
    }
    
}
