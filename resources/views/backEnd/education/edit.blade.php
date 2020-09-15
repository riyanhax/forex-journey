@extends('backEnd.layouts.master')
@section('title','Update Post')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Update Post</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Update Post</li>
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
                         <h6 class="card-title">Update Post</h6>
                       </div>
                       <div class="col-sm-6">
                        <div class="shortcut-btn">
                           <a href="{{url('editor/education/manage')}}"><i class="fa fa-cogs"></i> Manage</a>
                        </div>
                       </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                       <form action="{{url('editor/education/update')}}" method="POST" enctype="multipart/form-data" class="form-row" name="editForm">
                         @csrf
                          <input type="hidden" value="{{$edit_data->id}}" name="hidden_id">
                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label for="name">Education Category</label>
                                    <select name="ecategory_id" id="eduCategory" class="form-control{{ $errors->has('ecategory_id') ? ' is-invalid' : '' }} select2-example" value="{{ old('ecategory_id') }}">
                                        <option value="">--select category--</option>
                                        @foreach($ecategories as $key=>$value)
                                        <option value="{{$value->id}}">{{$value->name}}</option>
                                        @endforeach
                                    </select>
                                    @if ($errors->has('ecategory_id'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('ecategory_id') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label for="title">Title</label>
                                    <input type="text" name="title" class="form-control{{ $errors->has('title') ? ' is-invalid' : '' }}" value="{{ $edit_data->title }}">

                                    @if ($errors->has('title'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('title') }}</strong>
                                    </span>
                                    @endif
                                </div>
                                
								<div class="form-group" style="margin-top:50px;">
                                <label for="description2">Details</label>
                                <textarea name="description2" class="full-featured-non-premium form-control{{ $errors->has('description2') ? ' is-invalid' : '' }} ">{{$edit_data->description2}}</textarea>
                                @if ($errors->has('description2'))
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $errors->first('description2') }}</strong>
                                </span>
                                @endif
                            </div>
								
                            
                            <div class="form-group">
                              <label for="file"> File</label>
    
                                <div class="clone hide" style="display: none;">
                                  <div class="control-group input-group" >
                                    <input type="file" name="file[]" class="form-control">
                                    <div class="input-group-btn"> 
                                      <button class="btn btn-danger" type="button"><i class="fa fa-trash"></i></button>
                                    </div>
                                  </div>
                                </div>
    
                                <div class="input-group control-group increment">
                                  <input type="file" name="file[]" class="form-control">
                                  <div class="input-group-btn"> 
                                    <button class="btn btn-success" type="button"><i class="fa fa-plus"></i></button>
                                  </div>
                                </div>
                                @foreach($educationfiles as $image)
                                   @if($edit_data->id==$image->postId) 
                                    <div class="edit-img">
                                      <input type="hidden" class="form-control" value="{{$image->id}}" name="hidden_img">
                                     <img src="{{asset($image->file)}}" class="editimage" alt="">
                                      <a href="{{url('editor/education/file/delete/'.$image->id)}}" onclick="return confirm('Are you sure? delete this.')" class="btn btn-danger">Delete</a>
                                    </div>
                                   @endif
                                @endforeach
                              @if ($errors->has('file'))
                              <span class="invalid-feedback" role="alert">
                                <strong>{{ $errors->first('file') }}</strong>
                              </span>
                              @endif
                            </div> 
                            
                           <!-- form-group end -->
                            </div>
						
                            <!-- form-group end -->
                             <div class="col-sm-12">
                                 <div class="form-group">	<br><br>
                                    <label for="status">Publication Status</label>
                                    <div class="form-group">
                                        <div class="custom-control custom-radio custom-checkbox-success inline-radio">
                                            <input type="radio" name="status" value="1" id="customRadio2"  class="custom-control-input{{ $errors->has('status') ? ' is-invalid' : '' }}">
                                            <label class="custom-control-label" for="customRadio2">Active</label>
                                        </div>
                                        <div class="custom-control custom-radio custom-checkbox-secondary inline-radio">
                                            <input type="radio" name="status" value="0" id="customRadio1"  class="custom-control-input{{ $errors->has('status') ? ' is-invalid' : '' }}">
                                            <label class="custom-control-label" for="customRadio1">Inactive</label>
                                        </div>
                                        @if ($errors->has('status'))
                                          <span class="invalid-feedback" role="alert">
                                              <strong>{{ $errors->first('status') }}</strong>
                                          </span>
                                          @endif
                                    </div>
                                </div>
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
  <script type="text/javascript">
      document.forms['editForm'].elements['status'].value="{{$edit_data->status}}"
          document.forms['editForm'].elements['ecategory_id'].value="{{$edit_data->ecategory_id}}"
          document.forms['editForm'].elements['esubcategory_id'].value="{{$edit_data->esubcategory_id}}"
    </script>
@endsection

