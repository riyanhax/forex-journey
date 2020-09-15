<?php

namespace App\Providers;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;
use App\Logo;
use App\Category;
use App\Ecategory;
use App\User;
use App\Post;
use DB;
use Session;
use Carbon\Carbon;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Schema::defaultStringLength(191);

       $whitelogo =Logo::where(['status'=>1,'type'=>1])->orderBy('id','DESC')->limit(1)->get(); 
        view()->share(compact('whitelogo'));
        // mainlogo
        $categories=Category::where('status',1)->orderBy('id','ASC')->get(); 
        view()->share(compact('categories'));
        // mainlogo
       
        $ecategories=Ecategory::where('status',1)->get(); 
        view()->share(compact('ecategories'));
        // mainlogo
        
        $users=User::count(); 
        view()->share(compact('users'));
        
        $posts=Post::get(); 
        view()->share(compact('posts'));
        
        $activeposts=Post::where('status',1)->count(); 
        view()->share(compact('activeposts'));
        // mainlogo
        
        $inactiveposts=Post::where('status',0)->count(); 
        view()->share(compact('inactiveposts'));
        // mainlogo
       
        

    }
}
