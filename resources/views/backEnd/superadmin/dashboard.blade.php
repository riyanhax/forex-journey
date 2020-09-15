@extends('backEnd.layouts.master')
@section('title','Superadmin Dashboard')
@section('content')
  <!-- begin::main-content -->
        <div class="container">
            <!-- begin::page-header -->
            <div class="page-header">
                <h4>Superadmin Dashboard</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="{{url('superadmin/dashboard')}}">Home</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
                    </ol>
                </nav>
            </div>
            <!-- end::page-header -->
            <div class="row">
                <div class="col-md-4">
                    <div class="card border mb-3">
                        <div class="card-body custom-padding">
                            <div class="d-flex align-items-center">
                                <div class="icon-block mr-3 icon-block-lg icon-block-outline-success text-success">
                                    <i data-feather="users"></i>
                                </div>
                                <div>
                                    <h6 class="text-uppercase font-size-11">Total Member</h6>
                                    <h4 class="mb-0">{{$members}}</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border mb-3">
                        <div class="card-body custom-padding">
                            <div class="d-flex align-items-center">
                                <div class="icon-block mr-3 icon-block-lg icon-block-outline-primary text-primary">
                                    <i data-feather="pie-chart"></i>
                                </div>
                                <div>
                                    <h6 class="text-uppercase font-size-11">New Register</h6>
                                    <h4 class="mb-0">{{$newmembers}}</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card border mb-3">
                        <div class="card-body custom-padding">
                            <div class="d-flex align-items-center">
                                <div class="icon-block mr-3 icon-block-lg icon-block-outline-success text-success">
                                    <i data-feather="users"></i>
                                </div>
                                <div>
                                    <h6 class="text-uppercase font-size-11">Panel Admin</h6>
                                    <h4 class="mb-0">{{$users}}</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border mb-3">
                        <div class="card-body custom-padding">
                            <div class="d-flex align-items-center">
                                <div class="icon-block mr-3 icon-block-lg icon-block-outline-danger text-danger">
                                    <i data-feather="bar-chart"></i>
                                </div>
                                <div>
                                    <h6 class="text-uppercase font-size-11">Total Post</h6>
                                    <h4 class="mb-0">{{$posts->count()}}</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--col end-->
                <div class="col-md-4">
                    <div class="card border mb-3">
                        <div class="card-body custom-padding">
                            <div class="d-flex align-items-center">
                                <div class="icon-block mr-3 icon-block-lg icon-block-outline-danger text-success">
                                    <i data-feather="thumbs-up"></i>
                                </div>
                                <div>
                                    <h6 class="text-uppercase font-size-11">Active Post</h6>
                                    <h4 class="mb-0">{{$activeposts}}</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--col end-->
                <div class="col-md-4">
                    <div class="card border mb-3">
                        <div class="card-body custom-padding">
                            <div class="d-flex align-items-center">
                                <div class="icon-block mr-3 icon-block-lg icon-block-outline-danger text-danger">
                                    <i data-feather="thumbs-down"></i>
                                </div>
                                <div>
                                    <h6 class="text-uppercase font-size-11">Inactive Post</h6>
                                    <h4 class="mb-0">{{$inactiveposts}}</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--col end-->
            </div>
            
        </div>
@endsection

