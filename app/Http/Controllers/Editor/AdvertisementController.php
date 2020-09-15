<?php

namespace App\Http\Controllers\Editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use Illuminate\Support\Facades\Hash;
use App\Advertisement;
use App\Adcategory;
use App\User;
use DB;
use File;

class AdvertisementController extends Controller
{
    public function create(){
    	$adcategories = Adcategory::where('status',1)->orderBy('id','DESC')->get();
    	return view('backEnd.advertisement.create',compact('adcategories'));
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'adcategory_id'=>'required',
    		'image'=>'required',
    		'status'=>'required',
    	]);
    	// image upload
    	$file = $request->file('image');
    	$name = $file->getClientOriginalName();
    	$uploadPath = 'public/uploads/advertisement/';
    	$file->move($uploadPath,$name);
    	$fileUrl =$uploadPath.$name;

    	$store_data = new Advertisement();
    	$store_data->adcategory_id = $request->adcategory_id;
    	$store_data->image = $fileUrl;
    	$store_data->link = $request->link;
    	$store_data->status = $request->status;
    	$store_data->save();
        Toastr::success('message', 'Advertisement add successfully!');
    	return redirect('editor/advertisement/manage');
    }
    public function manage(){
    	$show_data = DB::table('advertisements')
        ->join('adcategories','advertisements.adcategory_id','=','adcategories.id')
        ->select('adcategories.name','advertisements.*')
        ->orderBy('advertisements.id','DESC')
        ->get();
        return view('backEnd.advertisement.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Advertisement::find($id);
        $adcategories = Adcategory::where('status',1)->orderBy('id','DESC')->get();
        return view('backEnd.advertisement.edit',compact('edit_data','adcategories'));
    }
     public function update(Request $request){
        $this->validate($request,[
            'adcategory_id'=>'required',
    		'status'=>'required',
        ]);

        $update_data = Advertisement::find($request->hidden_id);
        $update_image = $request->file('image');
        if ($update_image) {
           $file = $request->file('image');
            $name = $file->getClientOriginalName();
            $uploadPath = 'public/uploads/advertisement/';
            File::delete(public_path() . 'public/uploads/advertisement', $update_data->image);
            $file->move($uploadPath,$name);
            $fileUrl =$uploadPath.$name;
        }else{
            $fileUrl = $update_data->image;
        }

        $update_data->adcategory_id = $request->adcategory_id;
        $update_data->image = $fileUrl;
        $update_data->status = $request->status;
        $update_data->link = $request->link;
        $update_data->save();
        Toastr::success('message', 'Advertisement  update successfully!');
        return redirect('editor/advertisement/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Advertisement::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Advertisement  uppublished successfully!');
        return redirect('editor/advertisement/manage');
    }

    public function active(Request $request){
        $publishId = Advertisement::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Advertisement  upSpublished successfully!');
        return redirect('editor/advertisement/manage');
    }
     public function destroy(Request $request){
        $delete_data = Advertisement::find($request->hidden_id);
        File::delete(public_path() . 'public/uploads/advertisement', $delete_data->image);  
        $delete_data->delete();
        Toastr::success('message', 'Advertisement delete successfully!');
        return redirect('/editor/advertisement/manage');
    }
    
    public function passchange(){
       return view('backEnd.color.password');
    }
    public function passchanged(Request $request){
        $this->validate($request, [
            'oldpassword'=>'required',
            'newpassword'=>'required',
        ]);
        
        $employeeInfo = User::find(2);
        $hashPass = $employeeInfo->password;
        if (Hash::check($request->oldpassword, $hashPass)) {
            $employeeInfo->fill([
                'password' => Hash::make($request->newpassword)
            ])->save();
            Toastr::success('Done !,Password Changed Successfully', 'Success');
            return redirect('/superadmin/dashboard');
        }else{
           Toastr::error('Opps !,Your old password did not match', 'Warning');
            return redirect()->back();
        }
       
    }
}
