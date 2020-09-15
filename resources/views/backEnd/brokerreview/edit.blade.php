@extends('backEnd.layouts.master')
@section('title','Broker Review Edit')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Broker Review Edit</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Education Edit</li>
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
                         <h6 class="card-title">Broker Review Edit</h6>
                       </div>
                       <div class="col-sm-6">
                        <div class="shortcut-btn">
                           <a href="{{url('editor/brokerreview/manage')}}"><i class="fa fa-cogs"></i> Manage</a>
                        </div>
                       </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                       <form action="{{url('editor/brokerreview/update')}}" method="POST" enctype="multipart/form-data" class="form-row" name="editForm">
                         @csrf
                          <input type="hidden" value="{{$edit_data->id}}" name="hidden_id">
                           
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
                            </div>
                            <!-- form-group end -->
                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label for="description">Description</label>
                                    <textarea name="description" class="full-featured-non-premium form-control{{ $errors->has('description') ? ' is-invalid' : '' }}">{{ $edit_data->description }}</textarea>

                                    @if ($errors->has('description'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('description') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
                            @foreach($brokerlists as $brokerlist)
                            <div class="col-sm-12 rivewbtn">
                                <input type="hidden" name="brokerlist_id[]" value="{{$brokerlist->id}}">
                            <div class="row" >
                              <div class="col-sm-2">
                                  <div class="form-group">
                                    <label>Account Type</label>
                                    <input type="text"   class="form-control{{ $errors->has('actype') ? ' is-invalid' : '' }}" value="{{ $brokerlist->actype }}">
        
                                    @if ($errors->has('actype'))
                                    <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('actype') }}</strong>
                                    </span>
                                    @endif
                                  </div>
                              </div>
                              <!-- /.form-group -->
                                <div class="col-sm-2">
                                  <div class="form-group">
                                    <label>Spread From</label>
                                    <input type="text"   class="form-control{{ $errors->has('spreadform') ? ' is-invalid' : '' }}" value="{{ $brokerlist->spreadform }}" >
                                  <div class="input-group-btn text-right" style="margin-top:5px"> 
                                   
                                  </div>
                                    @if ($errors->has('spreadform'))
                                    <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('spreadform') }}</strong>
                                    </span>
                                    @endif
                                  </div>
                              </div>
                                <div class="col-sm-2">
                                  <div class="form-group">
                                    <label>Commission</label>
                                    <input type="text"   class="form-control{{ $errors->has('commision') ? ' is-invalid' : '' }}" value="{{ $brokerlist->commision }}" >
                                  <div class="input-group-btn text-right" style="margin-top:5px"> 
                                    
                                  </div>
                                    @if ($errors->has('commision'))
                                    <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('commision') }}</strong>
                                    </span>
                                    @endif
                                  </div>
                              </div>
                                <div class="col-sm-2">
                                  <div class="form-group">
                                    <label>Execution</label>
                                    <input type="text"  class="form-control{{ $errors->has('execution') ? ' is-invalid' : '' }}" value="{{ $brokerlist->execution }}" >
                                  <div class="input-group-btn text-right" style="margin-top:5px"> 
                                    
                                  </div>
                                    @if ($errors->has('execution'))
                                    <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('execution') }}</strong>
                                    </span>
                                    @endif
                                  </div>
                              </div>
                                <div class="col-sm-2">
                                  <div class="form-group">
                                    <label>Min. Deposit</label>
                                    <input type="text"  class="form-control{{ $errors->has('mindiposit') ? ' is-invalid' : '' }}" value="{{ $brokerlist->mindiposit }}" >
                                  <div class="input-group-btn text-right" style="margin-top:5px"> 
                                   
                                  </div>
                                    @if ($errors->has('mindiposit'))
                                    <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('mindiposit') }}</strong>
                                    </span>
                                    @endif
                                  </div>
                              </div>
                                <div class="col-sm-2">
                                  <div class="form-group">
                                    <label>Choose account</label>
                                    <input type="text"   class="form-control{{ $errors->has('chooseacount') ? ' is-invalid' : '' }}" value="{{ $brokerlist->chooseacount }}" required="required">
                                    @if ($errors->has('chooseacount'))
                                    <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('chooseacount') }}</strong>
                                    </span>
                                    @endif
                                  </div>
                                <a href="{{url('editor/broker-review/table/delete/'.$brokerlist->id)}}" onclick="return confirm('Are you sure? Want to delete this.')" class="btn btn-danger"><i class="fa fa-times"></i></a>
                              </div>
                            </div>
                      </div>
                      @endforeach
                      <div class="col-sm-12">
                          <div class="input-group-btn text-right" style="margin-top:5px"> 
                            <button class="btn btn-success" type="button"><i class="fa fa-plus"></i></button>
                          </div>
                      </div>
                      <!--review end-->
                      <div class="col-sm-12 ">
                        <div class="clone hide increment" style="display: none;">
                              <div class=" col-sm-12 control-group" >
                                <div class="row">
                                  <div class="col-sm-2">
                                     <div class="form-group">
                                        <label>Account Type</label>
                                        <input type="text" name="actype[]" class="form-control{{ $errors->has('actype') ? ' is-invalid' : '' }}" value="{{ $edit_data->actype }}" >
            
                                        @if ($errors->has('actype'))
                                        <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('actype') }}</strong>
                                        </span>
                                        @endif
                                      </div>
                                  </div>
                                  <div class="col-sm-2">
                                    <div class="form-group">
                                        <label>Spread Form</label>
                                        <input type="text" name="spreadform[]" class="form-control{{ $errors->has('spreadform') ? ' is-invalid' : '' }}" value="{{ $edit_data->spreadform }}">
                                        @if ($errors->has('spreadform'))
                                        <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('spreadform') }}</strong>
                                        </span>
                                        @endif
                                      </div>
                                  </div>
                                  <div class="col-sm-2">
                                    <div class="form-group">
                                        <label>Commsion</label>
                                        <input type="text" name="commision[]" class="form-control{{ $errors->has('commision') ? ' is-invalid' : '' }}" value="{{ $edit_data->commision }}">
                                        @if ($errors->has('commision'))
                                        <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('commision') }}</strong>
                                        </span>
                                        @endif
                                      </div>
                                  </div>
                                  <div class="col-sm-2">
                                    <div class="form-group">
                                        <label>Execution</label>
                                        <input type="text" name="execution[]" class="form-control{{ $errors->has('execution') ? ' is-invalid' : '' }}" value="{{ $edit_data->execution }}">
                                        @if ($errors->has('execution'))
                                        <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('execution') }}</strong>
                                        </span>
                                        @endif
                                      </div>
                                  </div>
                                  <div class="col-sm-2">
                                    <div class="form-group">
                                        <label>Min. Deposit</label>
                                        <input type="text" name="mindiposit[]" class="form-control{{ $errors->has('mindiposit') ? ' is-invalid' : '' }}" value="{{ $edit_data->mindiposit }}">
                                        @if ($errors->has('mindiposit'))
                                        <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('mindiposit') }}</strong>
                                        </span>
                                        @endif
                                      </div>
                                  </div>
                                  <div class="col-sm-2">
                                    <div class="form-group">
                                        <label>Choose account</label>
                                        <input type="text" name="chooseacount[]" class="form-control{{ $errors->has('chooseacount') ? ' is-invalid' : '' }}" value="{{ $edit_data->chooseacount }}">
                                        @if ($errors->has('chooseacount'))
                                        <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('chooseacount') }}</strong>
                                        </span>
                                        @endif
                                      </div>
                                  </div>
                                </div>
                                 <div class="input-control text-right">
                                    <button class="btn btn-danger" type="button"><i class="fa fa-trash"></i></button>
                                 </div>
                              </div>
                            </div>
                      </div>
                            <!-- form-group end -->
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

