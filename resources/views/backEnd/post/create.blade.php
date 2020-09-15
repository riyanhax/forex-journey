@extends('backEnd.layouts.master')
@section('title','Post Add')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Post Add</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Post Add</li>
                </ol>
            </nav>
        </div>
        <!-- end::page-header -->
    <div class="row">
      <div class="col-sm-12">
        <div class="card">
            <div class="card-body">
                 <div class="row">
                       <div class="col-sm-6">
                         <h6 class="card-title">Post Add</h6>
                       </div>
                       <div class="col-sm-6">
                        <div class="shortcut-btn">
                           <a href="{{url('editor/post/manage')}}"><i class="fa fa-cogs"></i> Manage</a>
                        </div>
                       </div>
                 </div>
                 <div class="row">
                           @if ($errors->any())
									<div class="alert alert-danger">
									<ul>@foreach ($errors->all() as $error)
									<li>{{ $error }}</li>
								    	@endforeach
									</ul>
									</div>
							@endif
                    <div class="col-md-12">
                       <form action="{{url('editor/post/store')}}" method="POST" enctype="multipart/form-data" class="form-row">
                         @csrf
                            <div class="col-sm-12">
                                <div class="form-group">
                                        <label for="category">Select Category</label>
                                        <select type="text" name="category" class="form-control{{$errors->has('category')? 'is-invalid' : ''}} select2" value="{{ old('category') }}" id="category">
                                           
                                            @foreach($data as $category)
                                            <option value="{{$category->id}}">{{$category->name}}</option>
                                            @endforeach
                                        </select>
                                           @if ($errors->has('category'))
                                             <span class="invalid-feedback" role="alert">
                                                <strong>{{ $errors->first('category') }}</strong>
                                              </span>
                                            @endif
                                    </div>
                            </div>
							
							
                            <!-- form-group end -->
                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label for="title">Title <small> ( minimum 5 characters : maximum 300 characters )</small></label>
                                    <input type="text" name="title" class="form-control{{ $errors->has('title') ? ' is-invalid' : '' }}" value="{{ old('title') }}">

                                    @if ($errors->has('title'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('title') }}</strong>
                                    </span>
                                    @endif
                                </div>
								
								<div class="form-group">
                                        <label for="description2">Enter Details</label>
                                        <textarea id="mytextarea2" name="description2" class="full-featured-non-premium form-control{{ $errors->has('description2') ? ' is-invalid' : '' }}">{{old('description2')}}</textarea>
                                        @if ($errors->has('description2'))
                                        <span class="invalid-feedback" role="alert">
                                            <strong>{{ $errors->first('description2') }}</strong>
                                        </span>
                                        @endif
                                </div>
                                
                            
                                    <div class="form-group">
                                        <label for="file"><h5>  Attachment</h5></label>
								<input type="file" name="file[]" class="form-control">	
                               <div class="clone hide" style="display: none;">
                                  <div class="control-group input-group" >
                                    <input type="file" name="file[]" class="form-control">
                                    <div class="input-group-btn"> 
                                      <button class="btn btn-danger" type="button"><i class="fa fa-trash"></i></button>
                                    </div>
                                  </div>
                                </div>
                             <div class="input-group control-group increment">
                                  <div class="input-group-btn"> 
                                    <button class="btn btn-success" type="button">
                                        <i class="fa fa-plus"></i> Add file
                                        </button>
                                  </div>
                                </div>                                    
                            <!-- form-group end -->
                            </div>                            
                             <!-- col end -->
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    </div>
                </div>
            </div>
        </div>
      </div>
    </div>
  </div>
@endsection