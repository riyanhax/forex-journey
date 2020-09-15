<?php

namespace App\Http\Controllers\frontEnd;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use App\Member;
use App\Post;
use App\PostFile;
use App\Comment;
use App\CommentFile;
use App\CommentReplay;
use App\CommentReplayFile;
use DB;
use Session;
use File;
class PostController extends Controller
{
	private function validMember(){
        $memberInfo=Member::find(Session::get('memberId'));
        return $memberInfo;
    }

    public function create(){
    	if($this->validMember()){
    	return view('frontEnd.layouts.post.create');
	    }else{
	    	return redirect('member/login');
	    }
    }
    public function store(Request $request){
    	$this->validate($request,[
    		'title'=>'required|string|min:5|max:300',
    		'description2'=>'required|string|min:5',
    		'category'=>'required',
    	]);

    	$store_data = new Post();
    	$store_data->title = $request->title;
    	$store_data->slug = preg_replace('/[^a-zA-Z0-9\s]/', '', strtolower($request->title));
    	$store_data->category = $request->category;
    	$store_data->description = $request->description;
    	$store_data->description2 = $request->description2;
        $store_data->memberid = Session::get('memberId');
    	$store_data->status = 1;
    	$store_data->save();

    	$files = $request->file('file');
        if($files){
            foreach($files as $file)
            {
               // image01 upload
                $name =  $file->getClientOriginalName();
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
    	return redirect('member/post/manage');
    }
    public function manage(){
      if($this->validMember()){
    	$show_data = DB::table('posts')
        ->join('categories','posts.category','=','categories.id')
        ->select('posts.*','categories.name')
        ->where('posts.memberid',Session::get('memberId'))
        ->orderBy('posts.id','DESC')
        ->paginate(20);
    	
         
        return view('frontEnd.layouts.post.manage',compact('show_data'));
      }else{
          return redirect('member/login');
      }
    }
    public function edit($id){
        $edit_data = Post::where(['memberid'=>Session::get('memberId'),'id'=>$id])->first();

        $productimage = DB::table('post_files')
        ->join('posts','post_files.postId','=','posts.id')
        ->select('posts.title','post_files.*')
        ->orderBy('post_files.id','DESC')
        ->get();
        if($edit_data){
        return view('frontEnd.layouts.post.edit', compact('edit_data','productimage'));
        }else{
            Toastr::error('Opps', 'You are not access this post');
            return redirect('member/post/manage');
        }
    }
     public function update(Request $request){
        $this->validate($request,[
            'title'=>'required|string|min:5|max:300',
            'description2'=>'required|string|min:5',
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
                $name =  $file->getClientOriginalName();
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

        Toastr::success('message', 'Post  update successfully!');
        return redirect('member/post/manage');
    }

    public function inactive(Request $request){
        $unpublish_data = Post::find($request->hidden_id);
        $unpublish_data->status=0;
        $unpublish_data->save();
        Toastr::success('message', 'Post  uppublished successfully!');
        return redirect('member/post/manage');
    }

    public function active(Request $request){
        $publishId = Post::find($request->hidden_id);
        $publishId->status=1;
        $publishId->save();
        Toastr::success('message', 'Post  uppublished successfully!');
        return redirect('member/post/manage');
    }
     public function productimgdel($id){
        $delete_img = PostFile::find($id);
        $delete_img->delete();
        Toastr::success('message', 'advertisments image  delete successfully!');
        return redirect()->back();
    }
     public function destroy(Request $request){
        $delete_data = Post::find($request->hidden_id); 
        $delete_data->delete();
        Toastr::success('message', 'Post delete successfully!');
        return redirect('member/post/manage');
    }
    public function comment(Request $request){
        if(Session::get('memberId')){
    	$this->validate($request,[
    		'comment'=>'required',
    	]);


    	$store_data = new Comment();
    	$store_data->comment = $request->comment;
        $store_data->memberid = Session::get('memberId');
    	$store_data->postId = $request->hidden_id;
    	$store_data->save();

    	$files = $request->file('file');
        if($files){
            foreach($files as $file)
            {
               // image01 upload
                $name = $file->getClientOriginalName();
                $uploadpath = 'public/uploads/comment/';
                $file->move($uploadpath, $name);
                $fileUrl = $uploadpath.$name; 

                $postfile= new CommentFile();
                $postfile->commentId = $store_data->id;
                $postfile->file=$fileUrl;
                $postfile->save();
            }
        }else{
            $fileUrl = NULL;
        }
        Toastr::success('message', 'Comment Published add successfully!');
    	return redirect()->back();
        }else{
           Toastr::error('Opps!!', 'Your process wrong please login first!');
    	   return redirect()->back(); 
        }
    }
    public function commentEdit(Request $request){
        $comment = Comment::find($request->input('commentId'));
        $comment->comment = $request->input('updatedComment');
        $comment->save();
        return redirect()->back();
        
    }
    public function commentDestroy(Request $request){
        $comment = Comment::find($request->input('commentId'));
        $comment->delete();
        Toastr::success('message', 'Comment delete successfully');
        return redirect()->back();  
    }
    public function commentreplay(Request $request){
        if(Session::get('memberId')){
    	$this->validate($request,[
    		'comment'=>'required',
    	]);


    	$store_data = new CommentReplay();
    	$store_data->comment = $request->comment;
        $store_data->memberid = Session::get('memberId');
    	$store_data->commentId = $request->hidden_id;
    	$store_data->save();

    	$files = $request->file('file');
        if($files){
            foreach($files as $file)
            {
               // image01 upload
                $name = $file->getClientOriginalName();
                $uploadpath = 'public/uploads/commentreplay/';
                $file->move($uploadpath, $name);
                $fileUrl = $uploadpath.$name; 

                $postfile= new CommentReplayFile();
                $postfile->commentId = $store_data->id;
                $postfile->file=$fileUrl;
                $postfile->save();
            }
        }else{
            $fileUrl = NULL;
        }
        Toastr::success('message', 'Comment Published add successfully!');
    	return redirect()->back();
        }else{
           Toastr::error('Opps!!', 'Your process wrong please login first!');
    	   return redirect()->back(); 
        }
    }
    public function commentReplyEdit(Request $request){
        $replyComment = CommentReplay::find($request->input('replyCommentId'));
        $replyComment->comment = $request->input('updatedReplyComment');
        $replyComment->save();
        return redirect()->back();
    }
    public function commentReplyDestroy(Request $request){
        $replyComment = CommentReplay::find($request->input('replyCommentId'));
        $replyComment->delete();
        Toastr::success('message', 'Comment delete successfully');
        return redirect()->back(); 
    }
}
