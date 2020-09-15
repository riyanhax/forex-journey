<?php

namespace App\Http\Controllers\Editor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Education;
use App\EducationFile;
use App\Ecategory;
use App\Esubcategory;
use App\Category;
use App\Post;
use App\PostFile;
use App\Color;
use DB;

class EducationController extends Controller
{
   // ajax code


     public function create(){
    	$ecategories = Ecategory::where('status',1)->orderBy('id','DESC')->get();
    	return view('backEnd.education.create',compact('ecategories'));
    }
	
	
	
	
    
    public function manage(){

    	$show_data = DB::table('education')
        ->join('ecategories','education.ecategory_id','=','ecategories.id')
        ->select('ecategories.name','education.*')
        ->orderBy('education.id','ASC')
        ->get();
        return view('backEnd.education.manage',compact('show_data'));
    }
    public function edit($id){
        $edit_data = Education::find($id);
        $ecategories = Ecategory::where('status',1)->orderBy('id','DESC')->get();
        $ecategoryId = Education::find($id)->ecategory_id;
        $educationfiles = EducationFile::where('postId',$id)->get();
        return view('backEnd.education.edit',compact('edit_data','ecategories','educationfiles'));
    }



	
	
	
	public function store(Request $request){
    	$this->validate($request,[
    		'ecategory_id'=>'required',
    		'title'=>'required',
    		'status'=>'required',
    	]);
    	$store_data = new Education();
    	$store_data->ecategory_id = $request->ecategory_id;
    	$store_data->title = $request->title;
    	$store_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->title)));
    	$store_data->description2 = $request->description2;
    	$store_data->status = $request->status;
    	$store_data->save();
    	
    	$files = $request->file('file');
        if($files){
            foreach($files as $file)
            {
                $name =  time().'-'.$file->getClientOriginalName();
                $uploadpath = 'public/uploads/educationfile/';
                $file->move($uploadpath, $name);
                $fileUrl = $uploadpath.$name; 
                $postfile= new EducationFile();
                $postfile->postId = $store_data->id;
                $postfile->file=$fileUrl;
                $postfile->save();
            }
        }else{
            $fileUrl = NULL;
        }
        Toastr::success('message', 'Education add successfully!');
    	return redirect('editor/education/manage');
    }
	
	
	
	
	
	
	
	
     public function update(Request $request){
        $this->validate($request,[
            'ecategory_id'=>'required',
    		'title'=>'required',
    		'status'=>'required',
        ]);

        $update_data = Education::find($request->hidden_id);
        $update_data->ecategory_id = $request->ecategory_id;
        $update_data->title = $request->title;
        $update_data->description2 = $request->description2;
        $update_data->slug = strtolower(preg_replace('/\s+/u', '-', trim($request->title)));
        $update_data->status = $request->status;
        $update_data->save();
        
        $postId=$update_data->id;
        $update_images=EducationFile::where('postId',$postId)->get();
		
        $images = $request->file('file');
        if($images){
            foreach($images as $file)
                {            
                 $name =  time().'-'.$file->getClientOriginalName();
                 $uploadpath = 'public/uploads/educationfile/';
                 $file->move($uploadpath, $name);
                 $imageUrl = $uploadpath.$name;  
                 $proimage= new EducationFile();
                 $proimage->postId = $postId;
                 $proimage->file=$imageUrl;
                 $proimage->save();
                }
        }
        Toastr::success('message', 'Education  update successfully!');
        return redirect('editor/education/manage');
    }

	
	
	
	
	
	
	
    public function inactive(Request $request){
        $unpublish_data = Education::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Education  uppublished successfully!');
        return redirect('editor/education/manage');
    }

    public function active(Request $request){
        $publishId = Education::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Education  upSpublished successfully!');
        return redirect('editor/education/manage');
    }
    public function destroy(Request $request){
        $delete_data = Education::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Education delete successfully!');
        return redirect('editor/education/manage');
    }
     public function filedelete($id){
        $delete_img = EducationFile::find($id);
        $delete_img->delete();
        Toastr::success('message', 'Education file  delete successfully!');
        return redirect()->back();
    }
	
	 
	
	
	//post manage section for admin
	public function postmanage(){

    	$show_data = DB::table('posts')
        ->join('categories','posts.category','=','categories.id')
        ->select('posts.*','categories.name')       
        ->orderBy('posts.id','ASC')
        ->paginate(15);
        return view('backEnd.post.manage',compact('show_data'));
    }
	
	    public function postcreate(){
    	$data = Category::where('status',1)->orderBy('id','DESC')->get();
    	return view('backEnd.post.create',compact('data'));
    }
	
    public function poststore(Request $request){
    	$this->validate($request,[
    		'title'=>'required',
    		'category'=>'required',
    	]);

    	$store_data = new Post();
    	$store_data->title = $request->title;
    	$store_data->slug = preg_replace('/[^a-zA-Z0-9\s]/', '', strtolower($request->title));
    	$store_data->category = $request->category;
    	$store_data->description = $request->description;
    	$store_data->description2 = $request->description2;
        $store_data->memberid = 1;
    	$store_data->status = 1;
    	$store_data->save();

    	$files = $request->file('file');
        if($files){
            foreach($files as $file)
            {
                $name = $file->getClientOriginalName();
                $uploadpath = 'public/uploads/post/';
                $file->move($uploadpath, $name);
                $fileUrl = $uploadpath.$name; 

                $postfile= new PostFile();
                $postfile->postId = $store_data->id;
                $postfile->file=$fileUrl;
                $postfile->save();
            }
        }else{
            $fileUrl = NULL;
        }
        Toastr::success('message', 'Post add successfully!');
    	return redirect('editor/post/manage');
    }	
	
	 public function postedit($id){
        $edit_data = Post::find($id);

        $productimage = DB::table('post_files')
        ->join('posts','post_files.postId','=','posts.id')
        ->select('posts.title','post_files.*')
        ->orderBy('post_files.id','DESC')
        ->get();
        if($edit_data){
        return view('backEnd.post.edit', compact('edit_data','productimage'));
        }else{
            Toastr::error('Opps', 'You are not access this post');
           return view('backEnd.post.edit',compact('edit_data','productimage'));
        }
    }
	
	 public function postupdate(Request $request){
        $this->validate($request,[
            'title'=>'required',
            'category'=>'required',
        ]);
        $update_data = Post::find($request->hidden_id);
        $update_data->title = $request->title;
        $update_data->slug = preg_replace('/[^a-zA-Z0-9\s]/', '', strtolower($request->title));
        $update_data->category = $request->category;
        $update_data->description = $request->description;
        $update_data->description2 = $request->description2;
        $update_data->status = 1;
        $update_data->save();

        $postId=$update_data->id;
        $update_images=PostFile::where('postId',$postId)->get();
        $images = $request->file('file');
        if($images){
            foreach($images as $file)
                {
                   // image01 upload
                $name = $file->getClientOriginalName();
                $uploadpath = 'public/uploads/post/';
                $file->move($uploadpath, $name);
                $imageUrl = $uploadpath.$name;  

                 $proimage= new PostFile();
                 $proimage->postId = $postId;
                 $proimage->file=$imageUrl;
                 $proimage->save();
                }
        }else{
            foreach($update_images as $update_image){
            $uimage=$update_image->file;
            $update_image->file    =   $uimage;
            $update_image->save();
            }
        }

        Toastr::success('message', 'Post  updated successfully!');
        return redirect('editor/post/manage');
    }
	
	 public function postdelete(Request $request){
        $delete_data = Post::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Post deleted successfully!');
        return redirect('editor/post/manage');
    }
	
	//color setting section
	public function frontindex(){
       $color = Color::first();
	   return view('backEnd.color.color', compact('color'));
    }
	public function colorset(Request $request){
		
        $colors = Color::first();
        $colors->header_top = $request->header_top;
        $colors->header_hover = $request->header_hover;
		$colors->title_color = $request->title_color;
        $colors->header_active = $request->header_active; 
        $colors->header_font = $request->header_font; 
		$colors->title_font = $request->title_font;
        $colors->post_author = $request->post_author; 
        $colors->title_background = $request->title_background;
        $colors->title_background2 = $request->title_background2; 
        $colors->descrip_preview = $request->descrip_preview;
        $colors->edutitle_background = $request->edutitle_background;
        $colors->edusub_background = $request->edusub_background;
        $colors->edu_font = $request->edu_font;
        $colors->edumenu_font = $request->edumenu_font;
        $colors->dtex_color = $request->dtex_color;
		$colors->revtitle_background = $request->revtitle_background;
		$colors->revtable_background = $request->revtable_background;
        $colors->save();
		Toastr::success('message', 'Color Update successfully!');
        return redirect('editor/color');
    }
}
