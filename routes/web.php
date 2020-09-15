<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Auth::routes();
Route::group(['namespace'=>'FrontEnd'], function(){    
    // employee route
     Route::get('member/register','MemberController@signup');
     Route::post('member/register','MemberController@register');
     Route::get('member/email-verification','MemberController@emailverify');
     Route::post('member/email-verification','MemberController@verification');
     Route::get('member/resend/verify-code','MemberController@resendverify');
     Route::get('member/login','MemberController@signin');
     Route::post('member/login','MemberController@login');
     Route::get('member/password-change','MemberController@passwordchange');
     Route::post('member/password-change','MemberController@pchangesave');
     Route::post('member/sign-out','MemberController@signout');
     Route::get('member/forget-password','MemberController@forgetpassword');
     Route::post('member/forget-password','MemberController@forgetpassemailcheck');
     Route::get('member/forget-password/reset','MemberController@passresetpage');
     Route::post('member/forget-password/reset','MemberController@fpassreset');
     Route::get('member/dashboard','MemberController@dashboard');
      Route::get('member/verification-email/{verifyToken}','MemberController@verifyEmail');
      Route::get('member/resend/verify-email','MemberController@resendVerifyEmail');

          // employee profile info
     Route::get('member/profile','MemberController@profile');
     Route::post('member/bio/edit','MemberController@bioedit');
     Route::post('member/information/edit','MemberController@infoedit');
     Route::post('member/nid-passport/upload','MemberController@personaldoc');
     Route::post('member/nid-passport/update','MemberController@personaldocupdate');
     Route::post('member/nid-passport/delete','MemberController@personaldocdel');
    
    // post operation
     Route::get('member/post/create','PostController@create');
     Route::post('member/post/store','PostController@store');
     Route::get('member/post/manage','PostController@manage');
     Route::get('member/post/edit/{id}','PostController@edit');
     Route::post('member/post/edit/{id}','PostController@edit');
     Route::post('member/post/update','PostController@update');
     Route::post('member/post/inactive','PostController@inactive');
     Route::post('member/post/delete','PostController@destroy');
     Route::post('member/post/comment','PostController@comment');
     Route::post('member/post/comment/edit', 'PostController@commentEdit');
     Route::post('member/post/comment/delete', 'PostController@commentDestroy');
     Route::post('member/post/comment-replay','PostController@commentreplay');
     Route::post('member/post/comment-reply/edit','PostController@commentReplyEdit');
     Route::post('member/post/comment-reply/delete','PostController@commentReplyDestroy');
     Route::get('member/post-file/delete/{id}','PostController@productimgdel');
     
     
});

Route::group(['namespace'=>'FrontEnd'], function(){
     Route::get('/strategies', 'FrontEndController@strategies');
     Route::get('/indicators', 'FrontEndController@indicators');
	 Route::get('/expert-advisors', 'FrontEndController@expertadvisors');	 
	 Route::get('/signals', 'FrontEndController@signals');
	 Route::get('/discussion', 'FrontEndController@discussion');
     Route::get('/', 'FrontEndController@index');
     Route::get('/education', 'FrontEndController@education');
     Route::get('/{slug}/education-details/{id}', 'FrontEndController@educationdetails');
    //  Route::get('/{slug}/{title}', 'FrontEndController@educationdetails');
     Route::get('/brokers', 'FrontEndController@brokers');
     Route::get('/brokers-review/{slug}/{id}', 'FrontEndController@brokersreview');
	
     Route::get('/{slug}/{id}', 'FrontEndController@post');
     Route::get('/broker-review', 'FrontEndController@brokerreview');
     Route::get('/about-us', 'FrontEndController@aboutUs');
   });  
 

Route::group(['as'=>'superadmin.', 'prefix'=>'superadmin', 'namespace'=>'Superadmin','middleware'=>[ 'auth', 'superadmin']], function(){

    // superadmin dashboard
    Route::get('/dashboard', 'DashboardController@index')->name('dashboard');
    Route::get('member/manage', 'DashboardController@allmember');
    Route::get('/active-member/manage', 'DashboardController@activemember');
    Route::post('member/active', 'DashboardController@active');
    Route::get('/inactive-member/manage', 'DashboardController@inactivemember');
    Route::post('member/inactive', 'DashboardController@inactive');
    Route::post('/member/delete', 'DashboardController@destroy');
    Route::post('member/profile/edit', 'DashboardController@eprofileupdate');
    Route::get('member/profile/{id}', 'DashboardController@employeeprofile');
    
    Route::get('/user/add', 'UserController@add');
    Route::post('/user/save', 'UserController@save');
    Route::get('/user/edit/{id}', 'UserController@edit');
    Route::post('/user/update', 'UserController@update');
    Route::get('/user/manage', 'UserController@manage');
    Route::post('/user/inactive', 'UserController@inactive');
    Route::post('/user/active', 'UserController@active');
    Route::post('/user/delete', 'UserController@destroy');
});


Route::group(['namespace'=>'FrontEnd'], function(){
	
     


    Route::get('search_data/{keyword}', 'FrontEndController@SearchData');
    Route::get('search_data', 'FrontEndController@SearchWithoutData');

});
// Live Search

// ajax route


 

Route::group(['as'=>'admin.', 'prefix'=>'admin', 'namespace'=>'Admin','middleware'=>['auth', 'admin']], function(){

 // admin dashboard
 Route::get('/dashboard', 'DashboardController@index')->name('dashboard');

 	// Logo route here
    Route::get('/logo/add','LogoController@create');
    Route::post('/logo/store','LogoController@store');
    Route::get('/logo/manage','LogoController@manage');
    Route::get('/logo/edit/{id}','LogoController@edit');
    Route::post('/logo/update','LogoController@update');
    Route::post('/logo/inactive','LogoController@inactive');
    Route::post('/logo/active','LogoController@active');
    Route::post('/logo/delete','LogoController@destroy');


});


Route::group(['as'=>'editor.', 'prefix'=>'editor', 'namespace'=>'Editor','middleware'=>['auth', 'editor']], function(){
 // editor dashboard
 	Route::get('/dashboard', 'DashboardController@index')->name('dashboard');


    Route::get('support','ContactController@support');
    Route::post('support','ContactController@sendmessage');
    Route::get('support/{slug}','ContactController@chat');
    Route::get('admin-to-employee/chat/content','ContactController@chatcontent');

   // Project content
    Route::get('project/add','ProjectController@create');
    Route::post('project/store','ProjectController@store');
    Route::get('project/manage','ProjectController@manage');
    Route::get('project/edit/{id}','ProjectController@edit');
    Route::post('project/update','ProjectController@update');
    Route::post('project/inactive','ProjectController@inactive');
    Route::post('project/active','ProjectController@active');
    Route::post('project/delete','ProjectController@destroy');
    Route::get('project/image/delete/{id}','ProjectController@imagedelete'); 


    // forum
    Route::get('forum','DashboardController@forum');

    Route::get('category/add','CategoryController@create');
    Route::post('category/store','CategoryController@store');
    Route::get('category/manage','CategoryController@manage');
    Route::get('category/edit/{id}','CategoryController@edit');
    Route::post('category/update','CategoryController@update');
    Route::post('category/inactive','CategoryController@inactive');
    Route::post('category/active','CategoryController@active');
    Route::post('category/delete','CategoryController@destroy');
    
    // Education Category
    Route::get('ecategory/add','EcategoryController@create');
    Route::post('ecategory/store','EcategoryController@store');
    Route::get('ecategory/manage','EcategoryController@manage');
    Route::get('ecategory/edit/{id}','EcategoryController@edit');
    Route::post('ecategory/update','EcategoryController@update');
    Route::post('ecategory/inactive','EcategoryController@inactive');
    Route::post('ecategory/active','EcategoryController@active');
    Route::post('ecategory/delete','EcategoryController@destroy');
	
	
    // User post for admin
    Route::get('post/manage','EducationController@postmanage');
	Route::get('post/create','EducationController@postcreate');
	Route::post('post/store','EducationController@poststore');
	Route::get('post/edit/{id}','EducationController@postedit');
	Route::post('post/update','EducationController@postupdate');
	Route::post('post/delete','EducationController@postdelete');
	
	
	//color setting section
	Route::get('color','EducationController@frontindex');
	Route::post('color/set','EducationController@colorset');
	
	
    // Education Category
    Route::get('education/add','EducationController@create');
    Route::post('education/store','EducationController@store');
    Route::get('education/manage','EducationController@manage');
    Route::get('education/edit/{id}','EducationController@edit');
    Route::post('education/update','EducationController@update');
    Route::post('education/inactive','EducationController@inactive');
    Route::post('education/active','EducationController@active');
    Route::get('education/file/delete/{id}','EducationController@filedelete');
    Route::post('education/delete','EducationController@destroy');

    // B Category
    Route::get('broker/add','BorkerController@create');
    Route::post('broker/store','BorkerController@store');
    Route::get('broker/manage','BorkerController@manage');
    Route::get('broker/edit/{id}','BorkerController@edit');
    Route::post('broker/update','BorkerController@update');
    Route::post('broker/inactive','BorkerController@inactive');
    Route::post('broker/active','BorkerController@active');
    Route::post('broker/delete','BorkerController@destroy');
    
    // Broker Review
    Route::get('brokerreview/add','BrokerreviewController@create');
    Route::post('brokerreview/store','BrokerreviewController@store');
    Route::get('brokerreview/manage','BrokerreviewController@manage');
    Route::get('brokerreview/edit/{id}','BrokerreviewController@edit');
    Route::post('brokerreview/update','BrokerreviewController@update');
    Route::post('brokerreview/inactive','BrokerreviewController@inactive');
    Route::post('brokerreview/active','BrokerreviewController@active');
    Route::post('brokerreview/delete','BrokerreviewController@destroy');
    Route::get('/broker-review/table/delete/{id}', 'BrokerreviewController@reviewlistdelete');

    // Advertisement Category
    Route::get('adcategory/add','AdcategoryController@create');
    Route::post('adcategory/store','AdcategoryController@store');
    Route::get('adcategory/manage','AdcategoryController@manage');
    Route::get('adcategory/edit/{id}','AdcategoryController@edit');
    Route::post('adcategory/update','AdcategoryController@update');
    Route::post('adcategory/inactive','AdcategoryController@inactive');
    Route::post('adcategory/active','AdcategoryController@active');
    Route::post('adcategory/delete','AdcategoryController@destroy');
    // Advertisement 
    Route::get('advertisement/add','AdvertisementController@create');
    Route::post('advertisement/store','AdvertisementController@store');
    Route::get('advertisement/manage','AdvertisementController@manage');
    Route::get('advertisement/edit/{id}','AdvertisementController@edit');
    Route::post('advertisement/update','AdvertisementController@update');
    Route::post('advertisement/inactive','AdvertisementController@inactive');
    Route::post('advertisement/active','AdvertisementController@active');
    Route::post('advertisement/delete','AdvertisementController@destroy');
    
    Route::get('password/change','AdvertisementController@passchange');
    Route::post('password/changed','AdvertisementController@passchanged');

});

 Route::group(['namespace'=>'Reports'], function(){
	// Repost functon
    Route::get('/editor/customer/list','ReportsController@customerlist');
});
 Route::group(['as'=>'author.', 'prefix'=>'author', 'namespace'=>'author','middleware'=>['auth', 'author']], function(){
 Route::get('/dashboard', 'DashboardController@index')->name('dashboard');
});
