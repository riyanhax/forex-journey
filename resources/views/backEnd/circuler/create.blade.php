@extends('backEnd.layouts.master')
@section('title','Job Circuler Add')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Job Circuler Add</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Job Circuler Add</li>
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
                         <h6 class="card-title">Job Circuler Add</h6>
                       </div>
                       <div class="col-sm-6">
                        <div class="shortcut-btn">
                           <a href="{{url('admin/circuler/manage')}}"><i class="fa fa-cogs"></i> Manage</a>
                        </div>
                       </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                       <form action="{{url('/admin/circuler/store')}}" method="POST" enctype="multipart/form-data" class="form-row">
                         @csrf
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="designation">Designation</label>
                                    <input type="text" name="designation" class="form-control{{ $errors->has('designation') ? ' is-invalid' : '' }}" value="{{ old('designation') }}">

                                    @if ($errors->has('designation'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('designation') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="location">Location</label>
                                    <input type="text" name="location" class="form-control{{ $errors->has('location') ? ' is-invalid' : '' }}" value="{{ old('location') }}">

                                    @if ($errors->has('location'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('location') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->

                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label for="shortdescription">Short Description</label>
                                    <textarea name="shortdescription" class="form-control{{ $errors->has('shortdescription') ? ' is-invalid' : '' }} full-featured-non-premium">{{old('shortdescription')}}</textarea>
                                    @if ($errors->has('shortdescription'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('shortdescription') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->

                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="exprience">Exprience</label>
                                    <input type="text" name="exprience" class="form-control{{ $errors->has('exprience') ? ' is-invalid' : '' }}" value="{{ old('exprience') }}">

                                    @if ($errors->has('exprience'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('exprience') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="salary">Salary</label>
                                    <input type="text" name="salary" class="form-control{{ $errors->has('salary') ? ' is-invalid' : '' }}" value="{{ old('salary') }}">

                                    @if ($errors->has('salary'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('salary') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label for="jobresponsibility">Job Responsibility</label>
                                    <textarea name="jobresponsibility" class="form-control{{ $errors->has('jobresponsibility') ? ' is-invalid' : '' }} full-featured-non-premium">{{old('jobresponsibility')}}</textarea>
                                    @if ($errors->has('jobresponsibility'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('jobresponsibility') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->

                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="expaire">Expaire Date</label>
                                    <input type="text" name="expaire" class="form-control{{ $errors->has('expaire') ? ' is-invalid' : '' }}" value="{{ old('expaire') }}">

                                    @if ($errors->has('expaire'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('expaire') }}</strong>
                                    </span>
                                    @endif
                                </div>
                            </div>
                            <!-- form-group end -->
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