<?php

namespace App\Http\Controllers\editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Project;
use App\Projectimage;
use File;
class ProjectController extends Controller
{
    
    public function create(){
    	return view('backEnd.project.create');
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'title'=>'required',
    		'image'=>'required',
    		'status'=>'required',
    	]);

    	$store_data = new Project();
    	$store_data->title = $request->title;
    	$store_data->client = $request->client;
    	$store_data->otherinfo = $request->otherinfo;
        $store_data->btntext = $request->btntext;
    	$store_data->description = $request->description;
    	$store_data->status = $request->status;
    	$store_data->save();

    	$projectId=$store_data->id;
        $images = $request->file('image');
        foreach($images as $image)
        {
           // image01 upload
            $name =  time().'-'.$image->getClientOriginalName();
            $uploadpath = 'public/uploads/project/';
            $image->move($uploadpath, $name);
            $imageUrl = $uploadpath.$name;  

             $proimage= new Projectimage();
             $proimage->projectId = $projectId;
             $proimage->image=$imageUrl;
             $proimage->save(); 
        }

        Toastr::success('message', 'Project add successfully!');
    	return redirect('/editor/project/manage');
    }
    public function manage(){
    	$show_data = Project::get();
        return view('backEnd.project.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Project::find($id);
        return view('backEnd.project.edit', compact('edit_data'));
    }
     public function update(Request $request){
        $this->validate($request,[
            'status'=>'required',
        ]);

        $update_data = Project::find($request->hidden_id);

        $update_data->title = $request->title;
    	$update_data->client = $request->client;
    	$update_data->otherinfo = $request->otherinfo;
    	$update_data->description = $request->description;
        $update_data->btntext = $request->btntext;
        $update_data->status = $request->status;
        $update_data->save();
        Toastr::success('message', 'Project update successfully!');
        return redirect('/editor/project/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Project::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Project  uppublished successfully!');
        return redirect('/editor/project/manage');
    }

    public function active(Request $request){
        $publishId = Project::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Project uppublished successfully!');
        return redirect('/editor/project/manage');
    }
     public function destroy(Request $request){
        $delete_data = Project::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Project delete successfully!');
        return redirect('/editor/project/manage');
    }
         public function imagedelete($id){
        $delete_img = Projectimage::find($id);
        $delete_img->delete();
        Toastr::success('message', 'project image  delete successfully!');
        return redirect()->back();
    }
}
