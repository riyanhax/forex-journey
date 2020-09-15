@extends('backEnd.layouts.master')
@section('title','Logo Add')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Logo Add</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('admin/logoboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Logo Add</li>
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
                         <h6 class="card-title">Logo Add</h6>
                       </div>
                       <div class="col-sm-6">
                        <div class="shortcut-btn">
                           <a href="{{url('admin/logo/manage')}}"><i class="fa fa-cogs"></i> Manage</a>
                        </div>
                       </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                       <form action="{{url('/admin/logo/update')}}" method="POST" enctype="multipart/form-data" class="form-row" name="editForm">
                         @csrf
                          <input type="hidden" value="{{$edit_data->id}}" name="hidden_id">
                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label for="image">Image</label>
                                    <input type="file" name="image" class="form-control{{ $errors->has('image') ? ' is-invalid' : '' }}" value="{{ old('image') }}" accept="image/*">
                                    <img src="{{asset($edit_data->image)}}" class="edit-img" alt="">
                                    @if ($errors->has('image'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('image') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
                             <div class="col-sm-12">
                                 <div class="form-group">
                                    <label for="type">Select...</label>
                                     <select class="select2-example{{ $errors->has('type') ? ' is-invalid' : '' }}" value="{{ old('type') }}" name="type" >
                                      <option>Choose..</option>
                                      <option value="1">White Logo</option>
                                      <option value="2">Dark Logo</option>
                                      <option value="3">Faveicon</option>
                                    </select>
                                     @if ($errors->has('type'))
                                      <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('type') }}</strong>
                                      </span>
                                      @endif
                                 </div>
                             </div>
                             <!-- col end -->
                             <div class="col-sm-12">
                                 <div class="form-group">
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
      document.forms['editForm'].elements['type'].value="{{$edit_data->type}}"
      document.forms['editForm'].elements['status'].value="{{$edit_data->status}}"
    </script>
@endsection

