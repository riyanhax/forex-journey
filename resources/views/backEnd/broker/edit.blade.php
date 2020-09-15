@extends('backEnd.layouts.master')
@section('title','Broker Add')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Broker Add</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('admin/logoboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Broker Add</li>
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
                         <h6 class="card-title">Broker Add</h6>
                       </div>
                       <div class="col-sm-6">
                        <div class="shortcut-btn">
                           <a href="{{url('editor/broker/manage')}}"><i class="fa fa-cogs"></i> Manage</a>
                        </div>
                       </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                       <form action="{{url('/editor/broker/update')}}" method="POST" enctype="multipart/form-data" class="form-row" name="editForm">
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
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="mindiposit">Name</label>
                                    <input type="text" name="name" class="form-control{{ $errors->has('name') ? ' is-invalid' : '' }}" value="{{ $edit_data->broker_name }}">

                                    @if ($errors->has('name'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('name') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="mindiposit">Min. Deposit</label>
                                    <input type="text" name="mindiposit" class="form-control{{ $errors->has('mindiposit') ? ' is-invalid' : '' }}" value="{{ $edit_data->mindiposit }}">

                                    @if ($errors->has('mindiposit'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('mindiposit') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="minspread">Min. Spread</label>
                                    <input type="text" name="minspread" class="form-control{{ $errors->has('minspread') ? ' is-invalid' : '' }}" value="{{ $edit_data->minspread }}">

                                    @if ($errors->has('minspread'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('minspread') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="maxleverage">Max Leverage</label>
                                    <input type="text" name="maxleverage" class="form-control{{ $errors->has('maxleverage') ? ' is-invalid' : '' }}" value="{{ $edit_data->maxleverage }}">

                                    @if ($errors->has('maxleverage'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('maxleverage') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="typebroker">Type Of Broker</label>
                                    <input type="text" name="typebroker" class="form-control{{ $errors->has('typebroker') ? ' is-invalid' : '' }}" value="{{ $edit_data->typebroker }}">

                                    @if ($errors->has('typebroker'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('typebroker') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="regulatedby">Regulated By</label>
                                    <input type="text" name="regulatedby" class="form-control{{ $errors->has('regulatedby') ? ' is-invalid' : '' }}" value="{{ $edit_data->regulatedby }}">

                                    @if ($errors->has('regulatedby'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('regulatedby') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="established">Established</label>
                                    <input type="text" name="established" class="form-control{{ $errors->has('established') ? ' is-invalid' : '' }}" value="{{ $edit_data->established }}">

                                    @if ($errors->has('established'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('established') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="headquater">Headquater</label>
                                    <input type="text" name="headquater" class="form-control{{ $errors->has('headquater') ? ' is-invalid' : '' }}" value="{{ $edit_data->headquater }}">

                                    @if ($errors->has('headquater'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('headquater') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="reviewlink">Review</label>
                                    <input type="text" name="reviewlink" class="form-control{{ $errors->has('reviewlink') ? ' is-invalid' : '' }}" value="{{ $edit_data->reviewlink }}">

                                    @if ($errors->has('reviewlink'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('reviewlink') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="visitlink">Visit Broker</label>
                                    <input type="text" name="visitlink" class="form-control{{ $errors->has('visitlink') ? ' is-invalid' : '' }}" value="{{ $edit_data->visitlink }}">

                                    @if ($errors->has('visitlink'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('visitlink') }}</strong>
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
      document.forms['editForm'].elements['status'].value="{{$edit_data->status}}"
    </script>
@endsection

