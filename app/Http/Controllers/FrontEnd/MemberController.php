<?php

namespace App\Http\Controllers\FrontEnd;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Brian2694\Toastr\Facades\Toastr;
use Illuminate\Support\Facades\Hash;
use App\Member;
use App\Overtimerate;
use App\Work;
use App\Forum;
use App\Post;
use App\Banner;
use App\EmployeePersonalDocument;
use App\EmployeeEducationalDocument;
use App\Support;
use Mail;
use DB;
use File;
use Carbon\Carbon;
use Session;
use Redirect;

class MemberController extends Controller
{
    
    private function validMember(){
        $memberInfo=Member::find(Session::get('memberId'));
        return $memberInfo;
    }
    public function signup(){
    	return view('frontEnd.layouts.member.signup');
    }
    public function signin(){
    	return view('frontEnd.layouts.member.signin');
    }

    public function login(Request $request){
       $memberCheck =Member::where('email',$request->email)
       ->first();
        if($memberCheck){
          if($memberCheck->status == 0){
             Toastr::error('Sorry! Your account has been suspend', 'Opps!');
             return redirect()->back();
         }else{
          if(password_verify($request->password,$memberCheck->password)){
                $memberId = $memberCheck->id;
                Session::put('memberId',$memberId);
                Toastr::success('Congratulation! You are successfully login', 'Success!');
                return Redirect::to($request->previous_url);

                // return redirect('/member/dashboard');

               

          }else{
              Toastr::error('Sorry! your password has been wrong', 'Opps!'); 
              return redirect()->back();
          }

           }
        }else{
         Toastr::error('Sorry! Your have no account', 'Opps!');
          return redirect()->back();
        }
       
    }
    public function register(Request $request){
      
           $this->validate($request,[
                'username' => 'required',
                'email' => 'required|unique:members',
                'password' => 'min:6|required_with:confirmpass|same:confirmpass',
                'confirmpass' => 'min:6',
            ]);

           $verifyToken=rand(111111,999999);
           $verify_code = uniqid(md5($request->email) . "_");
           $store_data          =   new Member();
           $store_data->name    =   $request->username;
           $store_data->slug    =   strtolower(preg_replace('/\s+/u', '-', trim($request->username))) ;
           $store_data->email   = $request->email;
           $store_data->agree   = 1;
           $store_data->verifyToken   = $verifyToken;
           $store_data->verification_code   = $verify_code;
           $store_data->password      = bcrypt(request('password'));
           $store_data->save();
          
            // verify code send to customer mail
            $data = array(
             'contact_email' => $request->email,
             'verifyToken' => $verifyToken,
             'verify_code' => $verify_code,
            );
            $send = Mail::send('frontEnd.emails.members.signup', $data, function($textmsg) use ($data){
             $textmsg->from('noreplay@journeyforex.com');
             $textmsg->to($data['contact_email']);
             $textmsg->subject('Account verify code');
            });

          // customer id put
          $memberId=$store_data->id;
          Session::put('memberId',$memberId);
         
          Toastr::success('We send verify token. Please check your email', 'Success');
          return view('frontEnd.layouts.member.emailverify', compact('verify_code'));
        //   return redirect('member/email-verification');
  
    }
    public function emailverify(){
    	return view('frontEnd.layouts.member.emailverify');
    }
    
     public function verifyEmail($verify_code = null, Request $request){
         $verified=Member::where('verification_code', $verify_code)->first();
      
       if($verified){
            $verified->verifyToken = 1;
            $verified->status = 1;
            $verified->verification_code= null;
            $verified->save();
            Toastr::success('Your email account verified successfuly', 'Success');
            Session::forget('memberId');
            return redirect('/');
       }else{
        Toastr::error('Your verify token wrong', 'Opps!');
        return redirect()->back();
       }
       
       
    	return view('frontEnd.layouts.member.emailVerify');
    }
      public function resendVerifyEmail(){
        $findcustomer=Member::find(Session::get('memberId'));
        $verifyToken=rand(111111,999999);
        $verify_code = uniqid(md5($findcustomer->email) . "_");
        $findcustomer->verification_code = $verify_code;
        $findcustomer->verifyToken=$verifyToken;
        
        
        $findcustomer->save();

        // verify code send to customer mail
        $data = array(
         'contact_email' => $findcustomer->email,
         'verifyToken' => $verifyToken,
         'verify_code' => $verify_code,
        );
        $send = Mail::send('frontEnd.emails.members.signup', $data, function($textmsg) use ($data){
         $textmsg->from('noreplay@journeyforex.com');
         $textmsg->to($data['contact_email']);
         $textmsg->subject('Resend account verify code');
        });
      Toastr::success('We send verification code. Please check your email', 'Success');
    //   return redirect('member/email-verification');
     return view('frontEnd.layouts.member.emailverify', compact('verify_code'));
    }
    
    
    public function resendverify(){
        $findcustomer=Member::find(Session::get('memberId'));
        $verifyToken=rand(111111,999999);
        $findcustomer->verifyToken=$verifyToken;
        $findcustomer->save();

        // verify code send to customer mail
        $data = array(
         'contact_email' => $findcustomer->email,
         'verifyToken' => $verifyToken,
        );
        $send = Mail::send('frontEnd.emails.members.signup', $data, function($textmsg) use ($data){
         $textmsg->from('noreplay@journeyforex.com');
         $textmsg->to($data['contact_email']);
         $textmsg->subject('Resend account verify code');
        });
      Toastr::success('We send verification code. Please check your email', 'Success');
      return redirect('member/email-verification');
    }
    public function verification(Request $request){
        $this->validate($request,[
            'verifytoken'=>'required',
        ]);
        $verified=Member::find(Session::get('memberId'));
        $verifydbtoken = $verified->verifyToken;
        $verifyformtoken= $request->verifytoken;
       if($verifydbtoken==$verifyformtoken){
            $verified->verifyToken = 1;
            $verified->status = 1;
            $verified->save();
            Toastr::success('Your email account verified successfuly', 'Success');
            Session::forget('memberId');
            return redirect('/');
       }else{
        Toastr::error('Your verify token wrong', 'Opps!');
        return redirect()->back();
       }
    }
    public function signout(Request $request){
        $employeeCheck = Member::find(Session::get('memberId'));
        $employeeCheck->online = 0;
        $employeeCheck->save();
        Session::forget('memberId');
        Toastr::success('You are logout successfully', 'success!');
        return redirect('/member/login');
    }
    public function forgetpassword(){
        return view('frontEnd.layouts.member.forgetpassword');
    }
    public function forgetpassemailcheck(Request $request){
        $this->validate($request,[
            'email'=>'required',
        ]);
       $checkEmail = Member::where('email',$request->email)->first();
      if($checkEmail){
        $passResetToken=rand(111111,999999);
        $checkEmail->passResetToken=$passResetToken;
        $checkEmail->save();

        // verify code send to customer mail
        $data = array(
         'contact_email' => $request->email,
         'passResetToken' => $passResetToken,
        );
        $send = Mail::send('frontEnd.emails.members.forgetpassword', $data, function($textmsg) use ($data){
         $textmsg->from('noreplay@journeyforex.com');
         $textmsg->to($data['contact_email']);
         $textmsg->subject('Forget password code');
        });
        Toastr::success('We have send a password reset code.Please check your email inbox.','Success');
        Session::put('memberTempId',$checkEmail->id);
        return redirect('member/forget-password/reset');
      }else{
        Toastr::error('Your email address not found','Opps');
        return redirect()->back();
      }
    }
    public function fpassreset(Request $request){
        $this->validate($request,[
            'verifycode'=>'required',
            'newpassword'=>'required',
        ]);
       $memberInfo = Member::find(Session::get('memberTempId'));
      if($memberInfo->passResetToken == $request->verifycode){
        $memberInfo->password=bcrypt(request('newpassword'));
        $memberInfo->passResetToken=NULL;
        $memberInfo->save();
        Toastr::success('Your password reset successfully','Success');
        Session::put('memberId',$memberInfo->id);
        return redirect('member/dashboard');
      }else{
        Toastr::error('Your verified code not match','Opps');
        return redirect()->back();
      }
    }
    public function passresetpage(){
       if(Session::get('memberTempId')){
        return view('frontEnd.layouts.member.passwordreset');
        }else{
           Toastr::error('Your request process rong','Opps!');
           return redirect('member/forget-password'); 
        }
    }
    public function dashboard(){
        if($this->validMember()){
            $totalpost = Post::where('memberid',Session::get('memberId'))->count();
            $activetotalpost = Post::where('memberid',Session::get('memberId'))->where('status',1)->count();
            $inactivetotalpost = Post::where('memberid',Session::get('memberId'))->where('status',0)->count();
            $thismonthposts = Post::where('memberid',Session::get('memberId'))->whereMonth('created_at', Carbon::now()->month)->paginate(15);
            return view('frontEnd.layouts.member.dashboard',compact('totalpost','activetotalpost','inactivetotalpost','thismonthposts'));
        }else{
            return redirect('member/login');
        }
    }

    public function profile(){
        if($this->validMember()){
        $memberInfo = Member::find(Session::get('memberId'));
        $totalpost = Post::where('memberId',Session::get('memberId'))->count();
        return view('frontEnd.layouts.member.profile',compact('memberInfo','totalpost'));
        }else{
           Toastr::error('You are not allowed this page','Opps!');
           return redirect('member/sign-in');
      }
    }
    public function passwordchange(){
        return view('frontEnd.layouts.member.passwordchange');
    }

    // product options
    public function pchangesave(Request $request){
        $this->validate($request, [
            'oldpassword'=>'required',
            'newpassword'=>'required',
        ]);

        $employeeInfo = Member::find(Session::get('memberId'));
        $hashPass = $employeeInfo->password;
        if (Hash::check($request->oldpassword, $hashPass)) {
            $employeeInfo->fill([
                'password' => Hash::make($request->newpassword)
            ])->save();
            Toastr::success('Done !,Your Password Change Success', 'Success');
            return redirect()->back();
        }else{
           Toastr::error('Opps !,Your old password not match', 'Warning');
            return redirect()->back();
        }

    }
    public function bioedit(Request $request){
        $this->validate($request,[
            'name'=>'required',
        ]);
        $bioedit=Member::find(Session::get('memberId'));
        $update_image = $request->file('profilepic');
        if ($update_image) {
           $file = $request->file('profilepic');
            $name = time().$file->getClientOriginalName();
            $uploadPath = 'public/uploads/member/profilepic/';
            $file->move($uploadPath,$name);
            $fileUrl =$uploadPath.$name;
        }else{
            $fileUrl = $bioedit->profilepic;
        }

        $bioedit->profilepic = $fileUrl;
        $bioedit->name = $request->name;
        $bioedit->designation = $request->designation;
        $bioedit->bio = $request->bio;
        $bioedit->save();
        Toastr::success('Your profile info update successfully', 'Success');
        return redirect()->back();
    }
    public function infoedit(Request $request){
        $this->validate($request,[
            'name'=>'required',
        ]);
        $bioedit=Member::find(Session::get('memberId'));
        $bioedit->name = $request->name;
        $bioedit->designation = $request->designation;
        $bioedit->phone = $request->phone;
        $bioedit->gender = $request->gender;
        $bioedit->birthday = $request->birthday;
        $bioedit->phone2 = $request->phone2;
        $bioedit->country = $request->country;
        $bioedit->district = $request->district;
        $bioedit->streetAddress = $request->streetAddress;
        $bioedit->postalCode = $request->postalCode;
        $bioedit->save();
        Toastr::success('Your profile info update successfully', 'Success');
        return redirect()->back();
    }

    // =========== employee personal documents ===========

     public function personaldoc(Request $request){
        $this->validate($request,[
            'document'=>'required',
            'title'=>'required',
        ]);

        // image upload
        $file = $request->file('document');
        $name = time().$file->getClientOriginalName();
        $uploadPath = 'public/uploads/member/personaldoc/';
        $file->move($uploadPath,$name);
        $fileUrl =$uploadPath.$name;

        $store_data = new EmployeePersonalDocument();
        $store_data->title = $request->title;
        $store_data->document = $fileUrl;
        $store_data->memberId = Session::get('memberId');
        $store_data->status = 1;
        $store_data->save();
        Toastr::success('message', 'Your document upload successfully!');
        return redirect()->back();
    }
    
    public function personaldocupdate(Request $request){
        $update_data = EmployeePersonalDocument::find($request->hidden_id); 
        $update_image = $request->file('document');
        if ($update_image) {
           $file = $request->file('document');
            $name = time().$file->getClientOriginalName();
            $uploadPath = 'public/uploads/member/personaldoc/';
            File::delete(public_path().'public/uploads/member/personaldoc/', $update_data->document);
            $file->move($uploadPath,$name);
            $fileUrl =$uploadPath.$name;
        }else{
            $fileUrl = $update_data->document;
        }

        $update_data->document = $fileUrl;
        $update_data->title = $request->title;
        $update_data->save();
        Toastr::success('message', 'Your document  update successfully!');
        return redirect()->back();
    }

    public function personaldocdel(Request $request){
        $delete_data = EmployeePersonalDocument::find($request->hidden_id);
        File::delete(public_path() . 'public/uploads/member/personaldoc/', $delete_data->document);  
        $delete_data->delete();
        Toastr::success('message', 'Your document delete successfully!');
        return redirect()->back();
    }

    // =========== employee educational documents ===========

     public function educationaldoc(Request $request){
        $this->validate($request,[
            'document'=>'required',
            'title'=>'required',
        ]);

        // image upload
        $file = $request->file('document');
        $name = time().$file->getClientOriginalName();
        $uploadPath = 'public/uploads/member/educationaldoc/';
        $file->move($uploadPath,$name);
        $fileUrl =$uploadPath.$name;

        $store_data = new EmployeeEducationalDocument();
        $store_data->title = $request->title;
        $store_data->document = $fileUrl;
        $store_data->memberId = Session::get('memberId');
        $store_data->status = 1;
        $store_data->save();
        Toastr::success('message', 'Your document upload successfully!');
        return redirect()->back();
    }


    
    public function educationaldocupdate(Request $request){
        $update_data = EmployeeEducationalDocument::find($request->hidden_id); 
        $update_image = $request->file('document');
        if ($update_image) {
           $file = $request->file('document');
            $name = time().$file->getClientOriginalName();
            $uploadPath = 'public/uploads/member/educationaldoc/';
            File::delete(public_path().'public/uploads/member/educationaldoc/', $update_data->document);
            $file->move($uploadPath,$name);
            $fileUrl =$uploadPath.$name;
        }else{
            $fileUrl = $update_data->document;
        }

        $update_data->document = $fileUrl;
        $update_data->title = $request->title;
        $update_data->save();
        Toastr::success('message', 'Your document  update successfully!');
        return redirect()->back();
    }

    public function educationaldocdel(Request $request){
        $delete_data = EmployeeEducationalDocument::find($request->hidden_id);
        File::delete(public_path() . 'public/uploads/member/educationaldoc/', $delete_data->document);  
        $delete_data->delete();
        Toastr::success('message', 'Your document delete successfully!');
        return redirect()->back();
    }

    // =========employee wallet ===========

    public function wallet(Request $request){
        $walletedit=Member::find(Session::get('memberId'));
        $walletedit->bankname = $request->bankname;
        $walletedit->branchlocation = $request->branchlocation;
        $walletedit->acholderno = $request->acholderno;
        $walletedit->acno = $request->acno;
        $walletedit->bkashnumber = $request->bkashnumber;
        $walletedit->roketnumber = $request->roketnumber;
        $walletedit->nagodnumber = $request->nagodnumber;
        $walletedit->save();
        Toastr::success('Your wallet info update successfully', 'Success');
        return redirect()->back();
    }
    

      
}
