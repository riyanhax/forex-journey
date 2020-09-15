<?php

namespace App\Http\Controllers\editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Category;
use File;
class CategoryController extends Controller
{
    
    public function create(){
    	return view('backEnd.category.create');
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'name'=>'required',
    		'status'=>'required',
    	]);


    	$store_data = new Category();
    	$store_data->name = $request->name;
    	$store_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->name)));
    	$store_data->status = $request->status;
    	$store_data->save();
        Toastr::success('message', 'Category add successfully!');
    	return redirect('editor/category/manage');
    }
    public function manage(){
    	$show_data = Category::get();
        return view('backEnd.category.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Category::find($id);
        return view('backEnd.category.edit',compact('edit_data'));
    }
     public function update(Request $request){
        $this->validate($request,[
            'name'=>'required',
            'status'=>'required',
        ]);

        $update_data = Category::find($request->hidden_id);
        $update_data->name = $request->name;
        $update_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->name)));
        $update_data->status = $request->status;
        $update_data->save();
        Toastr::success('message', 'Category  update successfully!');
        return redirect('editor/category/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Category::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Category  uppublished successfully!');
        return redirect('editor/category/manage');
    }

    public function active(Request $request){
        $publishId = Category::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Category  upSpublished successfully!');
        return redirect('editor/category/manage');
    }
     public function destroy(Request $request){
        $delete_data = Category::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Category delete successfully!');
        return redirect('editor/category/manage');
    }
}
