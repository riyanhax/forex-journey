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
                       <form action="{{url('editor/password/changed')}}" method="POST" class="form-row">
                            @csrf
							<div class="col-sm-6">
                                <div class="form-group">
                                    <label for="title">Enter Old Password</label>
                                     <input type="password" placeholder="Enter Old password" name="oldpassword" class="form-control form-control-lg" required />
                                 </div> 
                                </div>
                                <div class="col-sm-6">
                                 </div>
                                <div class="col-sm-6">
                                 <div class="form-group">
                                    <label for="title"> Enter New Password</label>
                                     <input type="password" placeholder="Enter New password" name="newpassword" class="form-control form-control-lg" required />
                                      </div> 
                                   </div>
                            <div class="col-sm-6">
                                 </div>
                     <div class="col-sm-6">                      
                             <!-- col end -->
                            <button type="submit" onclick="return-confirm('Are you sure to change your password ?')" class="btn btn-danger btn-lg btn-block"> Change Password </button>
                        </form>
                    </div>
					<br>	<br>	<br>	<br>	<br><br>	<br>	<br>	<br>	<br>
                </div>
            </div>
        </div>
      </div>
    </div>
  </div>
@endsection