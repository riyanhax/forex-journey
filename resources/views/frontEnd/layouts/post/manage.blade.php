@extends('frontEnd.layouts.member.master')
@section('title','Manage Post')
@section('content')
  <div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Manage Post</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('member/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Manage Post</li>
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
                     <h6 class="card-title">Post Manage</h6>
                   </div>
                   <div class="col-sm-6">
                    <div class="shortcut-btn">
                       <a href="{{url('member/post/create')}}"><i data-feather="plus"></i> Create Post </a>
                    </div>
                   </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                      <div class="manage-area">
                        <table id="myTable" class="table table-striped table-bordered ">
                        
                          <tr>
                            <th>SL</th>
                            <th>Category</th>
                            <th>Title</th>
                            <th>Status</th>
                            <th>Manage</th>
                          </tr>
                       
                        
                          @foreach($show_data as $key=>$value)
                          <tr>
                            <td>{{$loop->iteration}}</td>
                            <td>{{$value->name}}</td>
                            <td>{{$value->title}}</td>
                            <td>{{$value->status==1 ? "Active":"Inactive"}}</td>
                            <td><div class="dropdown">
                                <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                  Select
                                </button>
                                <div class="dropdown-menu custom-action">

                                  @if($value->status==1)
                                    <li class="dropdown-item">
                                    <form action="{{url('member/post/inactive')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Inactive</button>
                                    </form>
                                  </li>
                                   @else
                                   <li class="dropdown-item">
                                    <form action="{{url('member/post/active')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Active</button>
                                    </form>
                                  </li>
                                  @endif
                                  <li>
                                    <a class="dropdown-item" href="{{url('member/post/edit/'.$value->id)}}">Edit</a>
                                  </li>
                                  <li class="dropdown-item">
                                    <form action="{{url('member/post/delete')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit" onclick="return confirm('Are you want to delete this post?')" class="trash_icon"></button>
                                    </form>
                                  </li>
                                </td>
                          </tr>
                          @endforeach
                       
                      </table>
                      {{ $show_data->links() }}
                      </div>
                    </div>
                </div>
            </div>
        </div>
      </div>
    </div>
 </div>
@endsection