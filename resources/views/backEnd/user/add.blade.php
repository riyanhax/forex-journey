@extends('backEnd.layouts.master')
@section('title','User')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>User Add</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">User Add</li>
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
                         <h6 class="card-title">User Add</h6>
                       </div>
                       <div class="col-sm-6">
                        <div class="shortcut-btn">
                           <a href="{{url('superadmin/user/manage')}}"><i class="fa fa-cogs"></i> Manage</a>
                        </div>
                       </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                       <form action="{{url('/superadmin/user/save')}}" method="POST" enctype="multipart/form-data" class="form-row">
                         @csrf
                            <div class="col-sm-6">
                                <div class="form-group">
                                      <label>Name</label>
                                      <input type="text" name="name" class="form-control{{ $errors->has('name') ? ' is-invalid' : '' }}" value="{{ old('name') }}">

                                      @if ($errors->has('name'))
                                      <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('name') }}</strong>
                                      </span>
                                      @endif
                                </div>
                            </div>
                            <!-- col end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label>Username</label>
                                    <input type="text" name="username" class="form-control{{ $errors->has('username') ? ' is-invalid' : '' }}" value="{{ old('username') }}">

                                    @if ($errors->has('username'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('username') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                             <!--form-group -->
                            <div class="col-sm-6">
                              <div class="form-group">
                                  <label>Email</label>
                                  <input type="text" name="email" class="form-control{{ $errors->has('email') ? ' is-invalid' : '' }}" value="{{ old('email') }}">

                                  @if ($errors->has('email'))
                                  <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('email') }}</strong>
                                  </span>
                                  @endif
                              </div>
                            </div>
                             <!--form-group -->

                            <div class="col-sm-6">
                              <div class="form-group">
                                <label>Phone</label>
                                <input type="text" name="phone" class="form-control{{ $errors->has('phone') ? ' is-invalid' : '' }}" value="{{ old('phone') }}">

                                @if ($errors->has('phone'))
                                <span class="invalid-feedback" role="alert">
                                   <strong>{{ $errors->first('phone') }}</strong>
                                </span>
                                @endif
                              </div>
                            </div>
                            <!-- /.form-group -->

                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label>Designation</label>
                                    <input type="text" name="designation" class="form-control{{ $errors->has('designation') ? ' is-invalid' : '' }}" value="{{ old('designation') }}">

                                    @if ($errors->has('designation'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('designation') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- /.form-group -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="Picture">Picture</label>
                                    <input type="file" name="image" class="form-control{{ $errors->has('image') ? ' is-invalid' : '' }}" value="{{ old('image') }}" accept="image/*">

                                    @if ($errors->has('image'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('image') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
                          <div class="col-sm-6">
                              <div class="form-group">
                                  <label for="password">Password</label>
                                  <input type="password" name="password" class="form-control{{ $errors->has('password') ? ' is-invalid' : '' }}" value="{{ old('password') }}">

                                  @if ($errors->has('password'))
                                  <span class="invalid-feedback" role="alert">
                                      <strong>{{ $errors->first('password') }}</strong>
                                  </span>
                                  @endif
                              </div>
                          </div>
                          <!-- form group end -->
                          <div class="col-sm-6">
                              <div class="form-group">
                                  <label for="password">Confirm Password</label>
                                  <input type="password" class="form-control" name="confirm_password">
                              </div>
                          </div>
                          <!-- form group end -->
                             <div class="col-sm-6">
                                 <div class="form-group">
                                    <label for="">Select Role</label>
                                     <select class="select2-example{{ $errors->has('role') ? ' is-invalid' : '' }}" value="{{ old('role') }}" name="role" >
                                      <option>Choose..</option>
                                      <option value="1">Superadmin</option>
                                      <option value="2">Admin</option>
                                      <option value="3">Editor</option>
                                    </select>
                                     @if ($errors->has('role'))
                                      <span class="invalid-feedback" role="alert">
                                          <strong>{{ $errors->first('role') }}</strong>
                                      </span>
                                      @endif
                                 </div>
                             </div>
                             <!-- col end -->
                             <div class="col-sm-6">
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
@endsection