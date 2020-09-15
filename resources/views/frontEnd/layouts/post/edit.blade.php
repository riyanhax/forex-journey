@extends('frontEnd.layouts.member.master')
@section('title','Update Post')
@section('content')
	<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Update Post</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('member/dashboard')}}">Home</a>
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
                        <h6 class="card-title">Update Post</h6>
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
                                <form action="{{url('member/post/update')}}" method="POST" enctype="multipart/form-data" name="editForm">
                                    @csrf
                                    <input type="hidden" value="{{$edit_data->id}}" name="hidden_id">
                                    <div class="form-group">
                                        <label for="category">Select Category</label>
                                        <select type="text" name="category" class="form-control{{$errors->has('category')? 'is-invalid' : ''}} select2" value="{{ old('category') }}" id="category">
                                            <option value="">Select...</option>
                                            @foreach($categories as $category)
                                            <option value="{{$category->id}}">{{$category->name}}</option>
                                            @endforeach
                                        </select>
                                           @if ($errors->has('category'))
                                             <span class="invalid-feedback" role="alert">
                                                <strong>{{ $errors->first('category') }}</strong>
                                              </span>
                                            @endif
                                    </div>

                                    <div class="form-group">
                                        <label for="title">Title <small> ( minimum 5 characters : maximum 300 characters )</small></label>
                                        <input type="text" name="title" class="form-control{{$errors->has('title')? 'is-invalid' : ''}}" value="{{ $edit_data->title}}" id="title"
                                               placeholder="Write Title">
                                           @if ($errors->has('title'))
                                                <span class="invalid-feedback" role="alert">
                                                  <strong>{{ $errors->first('title') }}</strong>
                                                </span>
                                            @endif
                                    </div>
                                                                        
                                    
                                    <div class="form-group" style="margin-top:70px;margin-right:15%">
                                        <label for="description2">Enter Details</label>
                                        <textarea id="mytextarea" name="description2" class="form-control{{ $errors->has('description2') ? ' is-invalid' : '' }} full-featured-non-premium">{{$edit_data->description2}}</textarea>
                                        @if ($errors->has('description2'))
                                        <span class="invalid-feedback" role="alert">
                                            <strong>{{ $errors->first('description2') }}</strong>
                                        </span>
                                        @endif
                                    </div>
                                    
                                    
                                    
                                    <div class="form-group">
                                        <label for="file"><h4>  Attachment</h4></label>
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
                                        </div><br>
                                        @foreach($productimage as $image)
                                           @if($edit_data->id==$image->postId) 
                                            <div class="edit-img">
                                              <input type="hidden" class="form-control" value="{{$image->id}}" name="hidden_img">
											  {{File::name($image->file)}}.{{File::Extension($image->file)}}                  <br>      
                                              <a href="{{url('member/post-file/delete/'.$image->id)}}" onclick="return confirm('Are you sure? delete this.')" class="btn btn-danger">Delete</a>
                                              
                                            </div>
                                           @endif
                                        @endforeach
                                      @if ($errors->has('file'))
                                      <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('file') }}</strong>
                                      </span>
                                      @endif
                                    </div> 
                                    
                                    
                                    <br><br><br>
                                    
                        
                                    <button type="submit" class="btn btn-primary btn-lg">Submit</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
			</div>
		</div>
    </div>
    <script type="text/javascript">
          document.forms['editForm'].elements['category'].value="{{$edit_data->category}}"
       </script>
@endsection