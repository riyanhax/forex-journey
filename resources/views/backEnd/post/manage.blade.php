@extends('backEnd.layouts.master')
@section('title','All Post')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>All Post</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">All Post</li>
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
                     <h6 class="card-title">All Post</h6>
                   </div>
                   <div class="col-sm-6">
                    <div class="shortcut-btn">
                       <a href="{{url('editor/post/create')}}"><i data-feather="plus"></i> New Post</a>
                    </div>
                   </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                      <div class="manage-area">
                          <!--Please rename myTable2 to myTable if you want to use frontend pagination via Datatable-->
                        <table id="myTable2" class="table table-striped table-bordered table-responsive-stack">
                        <thead>
                          <tr>
                            <th>SL</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Manage</th>
                          </tr>
                        </thead>
                        <tbody>
                          @foreach($show_data as $key=>$value)
                          <tr>
                            <td>{{$value->id}}</td>
                            <td>{{ str_limit($value->title,20) }}</td>
							<td> {{$value->name}}</td>
                            
							<td>{!! str_limit(strip_tags($value->description2),20) !!}</td>
                            <td>{{$value->status==1 ? "Active":"Inactive"}}</td>
                            <td>
							<div class="dropdown">
                                <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                  Select
                                </button>
                                <div class="dropdown-menu custom-action">

                                  
                                  <li>
                                    <a class="dropdown-item" href="{{url('editor/post/edit/'.$value->id)}}">Edit</a>
                                  </li>
                                  <li class="dropdown-item">
                                    <form action="{{url('editor/post/delete')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit" onclick="return confirm('Are you want to delete this post?')" class="trash_icon">Delete</button>
                                    </form>
                                  </li>
                              </td>
                          </tr>
                          @endforeach
                        </tbody>
                      </table>
					  {{$show_data->links()}}
                      </div>
                    </div>
                </div>
            </div>
        </div>
      </div>
    </div>
 </div>
@endsection