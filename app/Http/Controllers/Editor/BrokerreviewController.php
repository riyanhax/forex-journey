<?php

namespace App\Http\Controllers\Editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Brokerreview;
use App\Reviewlist;
use DB;

class BrokerreviewController extends Controller
{
    public function create(){
    	
    	return view('backEnd.brokerreview.create');
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'title'=>'required',
    		'description'=>'required',
    		'status'=>'required',
    	]);


    	$store_data = new Brokerreview();
    	$store_data->title = $request->title;
    	$store_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->title)));
    	$store_data->description = $request->description;
    	$store_data->status = $request->status;
    	$store_data->save();

    	$brokerreviewId=$store_data->id;
        $actyps = $request->actype;
        $spreadforms = $request->spreadform;
        $commisions = $request->commision;
        $executions = $request->execution;
        $mindiposits = $request->mindiposit;
        $chooseacounts = $request->chooseacount;
        foreach($actyps as $key => $actype) {
            if($actype !=''){
            $reviewlists = new Reviewlist;
            $reviewlists->brokerreview_id =$brokerreviewId;
            $reviewlists->actype = $actype;
            $reviewlists->spreadform = $spreadforms[$key];
            $reviewlists->commision = $commisions[$key];
            $reviewlists->execution   = $executions[$key];
            $reviewlists->mindiposit   = $mindiposits[$key];
            $reviewlists->chooseacount   = $chooseacounts[$key];
            $reviewlists->save();
            }

        }

        Toastr::success('message', 'Brokerrivew add successfully!');
    	return redirect('editor/brokerreview/manage');
    }
    public function manage(){
    	$show_data = Brokerreview::orderBy('id','DESC')->get();
        return view('backEnd.brokerreview.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Brokerreview::find($id);
        $brokerlists = Reviewlist::where('brokerreview_id',$id)->get();
        return view('backEnd.brokerreview.edit',compact('edit_data','brokerlists'));
    }
     public function update(Request $request){
        $this->validate($request,[
    		'title'=>'required',
    		'description'=>'required',
    		'status'=>'required',
        ]);

        $update_data = Brokerreview::find($request->hidden_id);
        $update_data->title = $request->title;
        $update_data->description = $request->description;
        $update_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->title)));
        $update_data->status = $request->status;
        $update_data->save();
        
        $brokerreviewId=$update_data->id;
        $actyps = $request->actype;
        $spreadforms = $request->spreadform;
        $commisions = $request->commision;
        $executions = $request->execution;
        $mindiposits = $request->mindiposit;
        $chooseacounts = $request->chooseacount;
        foreach($actyps as $key => $actype) {
            if($actype !=''){
            $reviewlists = new Reviewlist;
            $reviewlists->brokerreview_id =$brokerreviewId;
            $reviewlists->actype = $actype;
            $reviewlists->spreadform = $spreadforms[$key];
            $reviewlists->commision = $commisions[$key];
            $reviewlists->execution   = $executions[$key];
            $reviewlists->mindiposit   = $mindiposits[$key];
            $reviewlists->chooseacount   = $chooseacounts[$key];
            $reviewlists->save();
            }

        }
        Toastr::success('message', 'Brokerrivew  update successfully!');
        return redirect('editor/brokerreview/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Brokerreview::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Brokerrivew  uppublished successfully!');
        return redirect('editor/brokerreview/manage');
    }

    public function active(Request $request){
        $publishId = Brokerreview::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Brokerrivew  upSpublished successfully!');
        return redirect('editor/brokerreview/manage');
    }
    public function destroy(Request $request){
        $delete_data = Brokerreview::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Brokerrivew delete successfully!');
        return redirect('editor/brokerreview/manage');
    }
    public function reviewlistdelete($id){
        $delete_data = Reviewlist::find($id); 
        $delete_data->delete();
        Toastr::success('message', 'Brokerrivew list delete successfully!');
        return redirect()->back();
    }
}
