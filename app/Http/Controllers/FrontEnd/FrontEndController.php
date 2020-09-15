<?php

namespace App\Http\Controllers\FrontEnd;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use App\Project;
use App\Education;
use App\Comment;
use App\Broker;
use App\Post;
use App\Brokerreview;
use App\Reviewlist;
use App\Advertisement;
use App\Category;
use Session;
use DB;
class FrontEndController extends Controller
{
    public function index(){
        $homeadone = Advertisement::where(['status'=>1,'adcategory_id'=>1])->limit(1)->get();
		$bottomad = Advertisement::where(['status'=>1,'adcategory_id'=>13])->limit(1)->get();
        return view('frontEnd.index',compact('homeadone','bottomad'));
    }


    public function education(){
        $educationadone = Advertisement::where(['status'=>1,'adcategory_id'=>2])->limit(1)->get();
         $educationbottom = Advertisement::where(['status'=>1,'adcategory_id'=>20])->limit(1)->get();
        $educations = Education::where('status',1)->orderBy('id','ASC')->limit(1)->get();
        return view('frontEnd.layouts.pages.education',compact('educations','educationadone','educationbottom'));
    }
    public function educationdetails( $slug,$id){
        // return $slug;
         $edetailsad = Advertisement::where(['status'=>1,'adcategory_id'=>2])->limit(1)->get();
         $educationbottom = Advertisement::where(['status'=>1,'adcategory_id'=>20])->limit(1)->get();
        // $educationdtails = Education::where(['status'=>1,'slug'=>$slug])->first();
        
        $educationdtails = Education::where('status', 1)->where('id', $id)->where('slug', 'LIKE', '%' . $slug . '%')->first();

        if($educationdtails){
        return view('frontEnd.layouts.pages.educationdetails',compact('educationdtails','educationbottom','edetailsad'));
        }
    }
    public function educationcategory($slug,$id){
        $educations = Education::where(['status'=>1,'ecategory_id'=>$id])->orderBy('id','DESC')->get();
        return view('frontEnd.layouts.pages.educationcategory',compact('educations'));
    }
    public function brokers(){
        $brokers = Broker::where('status',1)->get();
        return view('frontEnd.layouts.pages.brokers',compact('brokers'));
    }
    
    
    public function brokersreview($slug,$id){
        $brokertop = Advertisement::where(['status'=>1,'adcategory_id'=>8])->limit(1)->get();
        
        $brokercorner = Advertisement::where(['status'=>1,'adcategory_id'=>9])->limit(1)->get();
        
        $brokerright = Advertisement::where(['status'=>1,'adcategory_id'=>10])->limit(1)->get();
        
        $brokerbottom = Advertisement::where(['status'=>1,'adcategory_id'=>12])->limit(1)->get();
        
        $brokersreview = Brokerreview::where(['status'=>1,'id'=>$id])->orderBy('id','DESC')->first();
        if($brokersreview){
            $reviewlists = Reviewlist::where('brokerreview_id',$brokersreview->id)->get();
          return view('frontEnd.layouts.pages.brokerreview',compact('brokersreview','reviewlists','brokerbottom','brokertop','brokercorner','brokerright'));
        }else{
            return view('404');
        }
    }
	
	
    public function strategies(){
        $strategiestop = Advertisement::where(['status'=>1,'adcategory_id'=>3])->limit(1)->get();
        $strategiesright = Advertisement::where(['status'=>1,'adcategory_id'=>4])->limit(1)->get(); 
         $strategiesbottom = Advertisement::where(['status'=>1,'adcategory_id'=>19])->limit(1)->get(); 
        return view('frontEnd.layouts.pages.strategies',compact('strategiestop', 'strategiesbottom', 'strategiesright'));
    }
	
	public function indicators(){
        $indicatorstop = Advertisement::where(['status'=>1,'adcategory_id'=>15])->limit(1)->get();
        $indicatorsright = Advertisement::where(['status'=>1,'adcategory_id'=>14])->limit(1)->get(); 
        $indicatorsbottom = Advertisement::where(['status'=>1,'adcategory_id'=>7])->limit(1)->get(); 
        return view('frontEnd.layouts.pages.indicators',compact('indicatorstop','indicatorsbottom', 'indicatorsright'));
    }

	public function expertadvisors(){
        $expertadvisorstop = Advertisement::where(['status'=>1,'adcategory_id'=>16])->limit(1)->get();
        $expertadvisorsbottom = Advertisement::where(['status'=>1,'adcategory_id'=>18])->limit(1)->get(); 
        $expertadvisorsright = Advertisement::where(['status'=>1,'adcategory_id'=>17])->limit(1)->get();
        return view('frontEnd.layouts.pages.expertadvisors',compact('expertadvisorstop', 'expertadvisorsright', 'expertadvisorsbottom'));
    }
	
	public function signals(){
        $signalstop = Advertisement::where(['status'=>1,'adcategory_id'=>3])->limit(1)->get();
        $signalsright = Advertisement::where(['status'=>1,'adcategory_id'=>4])->limit(1)->get(); 
        $signalsbottom = Advertisement::where(['status'=>1,'adcategory_id'=>19])->limit(1)->get(); 
        return view('frontEnd.layouts.pages.signals',compact('signalstop', 'signalsbottom', 'signalsright'));
    }
	
	public function discussion(){
        $discussiontop = Advertisement::where(['status'=>1,'adcategory_id'=>15])->limit(1)->get();
        $discussionright = Advertisement::where(['status'=>1,'adcategory_id'=>14])->limit(1)->get(); 
        $discussionbottom = Advertisement::where(['status'=>1,'adcategory_id'=>7])->limit(1)->get(); 
        return view('frontEnd.layouts.pages.discussion',compact('discussiontop', 'discussionbottom', 'discussionright'));
    }


	
    public function post($slug,$id){
        $detailsadone = Advertisement::where(['status'=>1,'adcategory_id'=>5])->limit(1)->get();
        $detailsadtwo = Advertisement::where(['status'=>1,'adcategory_id'=>6])->limit(1)->get();
        $detailsadbottom = Advertisement::where(['status'=>1,'adcategory_id'=>11])->limit(1)->get();
        
        $postdetails = Post::where(['status'=>1,'id'=>$id])->first();
        if($postdetails){
            $lasthits = $postdetails->hitcount;
            $postdetails->hitcount = $lasthits+1;
            $postdetails->save();
            $relatedposts = Post::where(['status'=>1,'category'=>$postdetails->category])->inRandomOrder()->limit(3)->get();
            $postcomments = Comment::where(['postId'=>$id])->orderBy('id',"DESC")->paginate(15);
            $category=Category::find($postdetails->category);
        return view('frontEnd.layouts.pages.post',compact('detailsadone', 'detailsadbottom','detailsadtwo','postdetails','relatedposts','postcomments','category'));
        }
        
    }
    
     public function SearchData($keyword)
    {

	     $data['show_datas'] = Post::where('title','LIKE','%'.$keyword."%")->get();
		    $data = view('frontEnd.layouts.pages.search', $data)->render();
		    if ($data != '') 
		    {
		    	 echo $data;
		    }
     }
    
}
