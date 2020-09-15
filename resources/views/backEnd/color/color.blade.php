@extends('backEnd.layouts.master')
@section('title','Post Add')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Color & Font Settings</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Color & Font Settings</li>
                </ol>
            </nav>
        </div>
        <!-- end::page-header -->
    <div class="row">
      <div class="col-sm-12">
        <div class="card">
            <div class="card-body">
                 
                 <div class="row">
                    <div class="col-md-12">
                       <form action="{{url('editor/color/set')}}" method="POST" class="form-row">
                         @csrf
                            
							<div class="col-sm-3">
                                <div class="form-group">
                                    <label for="title">Header Font Size</label>
                                     <input type="text" name="header_font" class="form-control form-control-lg" value="{{$color->header_font}}">
                                 </div> 
                                </div>
                                
                                <div class="col-sm-3">
                                <div class="form-group">
                                    <label for="title">Description Preview Font Size</label>
                                     <input type="text" name="descrip_preview" class="form-control form-control-lg" value="{{$color->descrip_preview}}">
                                 </div> 
                                </div>
								
								<div class="col-sm-3">
                                <div class="form-group">
                                    <label for="title">Title Font Size</label>
                                    <input type="text" name="title_font" class="form-control form-control-lg" value="{{$color->title_font}}">
                                 </div> 
                                </div>
                                
                                <div class="col-sm-3">
                                <div class="form-group">
                                    <label for="title">Education Menu Font Size</label>
                                    <input type="text" name="edumenu_font" class="form-control form-control-lg" value="{{$color->edumenu_font}}">
                                 </div> 
                                </div>
							
                               <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Header Font Color</label>
                                  <input type="color" name="header_top" class="form-control form-control-lg" value="{{$color->header_top}}">
                                 </div> 
                                </div>
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Header Hover & Active Color</label>
                                    <input type="color" name="header_active" class="form-control form-control-lg" value="{{$color->header_active}}">
                                 </div> 
                                </div>
								
								
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Latest Ttile Color</label>
                                    <input type="color" name="title_color" class="form-control form-control-lg" value="{{$color->title_color}}">
                                 </div> 
                                </div>
								
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Post author details Color</label>
                                    <input type="color" name="post_author" class="form-control form-control-lg" value="{{$color->post_author}}">
                                 </div> 
                                </div>
								
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Hottest Title Color</label>
                                    <input type="color" name="header_hover" class="form-control form-control-lg" value="{{$color->header_hover}}">
                                 </div> 
                                </div>
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Title background Color</label>
                                    <input type="color" name="title_background" class="form-control form-control-lg" value="{{$color->title_background}}">
                                 </div> 
                                </div>
                                
                                <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Title background Color 2</label>
                                    <input type="color" name="title_background2" class="form-control form-control-lg" value="{{$color->title_background2}}">
                                 </div> 
                                </div>
                                
                                <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Education title background Color</label>
                                    <input type="color" name="edutitle_background" class="form-control form-control-lg" value="{{$color->edutitle_background}}">
                                 </div> 
                                </div>
                                
                                <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Education submenu background Color</label>
                                    <input type="color" name="edusub_background" class="form-control form-control-lg" value="{{$color->edusub_background}}">
                                 </div> 
                                </div>
                                
                                <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Education Menu Font Color</label>
                                    <input type="color" name="edu_font" class="form-control form-control-lg" value="{{$color->edu_font}}">
                                 </div> 
                                </div>
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Education Submenu Font Color</label>
                                    <input type="color" name="dtex_color" class="form-control form-control-lg" value="{{$color->dtex_color}}">
                                 </div> 
                                </div>
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Review Title Background Color</label>
                                    <input type="color" name="revtitle_background" class="form-control form-control-lg" value="{{$color->revtitle_background}}">
                                 </div> 
                                </div>
								
								<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Review Table Background Color</label>
                                    <input type="color" name="revtable_background" class="form-control form-control-lg" value="{{$color->revtable_background}}">
                                 </div> 
                                </div>
                            
                     <div class="col-sm-12">                      
                             <!-- col end -->
                            <button type="submit" class="btn btn-primary btn-lg btn-block">Update Now</button>
                        </form>
                    </div>
					
                </div>
            </div>
        </div>
      </div>
    </div>
  </div>
@endsection