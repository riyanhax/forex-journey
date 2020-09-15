@extends('backEnd.layouts.master')
@section('title','Employees Profile')
@section('content')
<div class="container">
    <div class="row">
          <div class="col-md-4">
              <div class="card">
                  <div class="card-body text-center">
                      <figure class="avatar avatar-lg m-b-20">
                          <img src="{{asset($employeeInfo->profilepic)}}" class="rounded-circle" alt="...">
                      </figure>
                      <h5 class="mb-1">{{$employeeInfo->name}}</h5>
                      <p class="text-muted small"> {{$employeeInfo->designation}} </p>
                      <p>{{$employeeInfo->bio}}</p>
                       <a  class="btn btn-outline-primary" data-toggle="modal" data-target="#bioModal">
                          <i data-feather="edit-2" class="mr-2"></i> Edit Profile
                      </a>
                      <!-- Modal -->
                        <div class="modal fade custom-modal-one" id="bioModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Edit Employee Info</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                  <span aria-hidden="true">&times;</span>
                                </button>
                              </div>
                              <div class="modal-body">
                                <div class="modal-form">
                                  <form action="{{url('superadmin/employee/profile/edit')}}" method="POST" enctype="multipart/form-data">
                                    @csrf
                                    <input type="hidden" name="hidden_id" value="{{$employeeInfo->id}}">
                                    <div class="form-group">
                                      <label for="">daily target</label>
                                      <input type="text" class="form-control" value="{{$employeeInfo->worktarget}}" name="worktarget" placeholder="Daily Work Target" required="required">
                                    </div>
                                    <div class="form-group">
                                      <label for="">Monthly Target</label>
                                      <input type="text" class="form-control" value="{{$employeeInfo->mworktarget}}" name="mworktarget" placeholder="Monthly Work Target" required="required">
                                    </div>
                                    <div class="form-group">
                                      <label for="">Employee Category</label>
                                      <input type="text" class="form-control" value="{{$employeeInfo->employeetype}}" name="employeetype" placeholder="Employee Category">
                                    </div>
                                    <div class="form-group">
                                      <button class="btn btn-primary" class="form-control">Submit</button>
                                    </div>
                                  </form>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <!-- modal end -->
                  </div>
                  <hr class="m-0">
                  <div class="card-body">
                      <div class="row text-center">
                          <div class="col-4 text-info">
                              <h4 class="font-weight-bold">{{$employeeInfo->worktarget}}</h4>
                              <span>D.Target</span>
                          </div>
                          <div class="col-4 text-success">
                              <h4 class="font-weight-bold">{{$employeeInfo->mworktarget}}</h4>
                              <span>M.Target</span>
                          </div>
                          <div class="col-4 text-warning">
                              <h4 class="font-weight-bold">{{$totalEarn}}</h4>
                              <span>Total Earn</span>
                          </div>
                      </div>
                  </div>
              </div>

              <div class="card">
                  <div class="card-body">
                      <h6 class="card-title d-flex justify-content-between align-items-center">
                          Information
                          <!-- <a  class="btn btn-outline-light btn-sm" data-toggle="modal" data-target="#infoModal">
                              <i data-feather="edit-2" class="mr-2"></i> Edit
                          </a> -->

                        <!-- Modal -->
                          <div class="modal fade custom-modal-one" id="infoModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                              <div class="modal-content">
                                <div class="modal-header">
                                  <h5 class="modal-title" id="exampleModalLabel">Edit Information</h5>
                                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                  </button>
                                </div>
                                <div class="modal-body">
                                  <div class="modal-form">
                                    <form action="{{url('employee/information/edit')}}" method="POST">
                                      @csrf
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$employeeInfo->name}}" name="name" placeholder="Name">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$employeeInfo->phone}}" name="phone" placeholder="Phone (Myself)">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$employeeInfo->phone2}}" name="phone2" placeholder="Phone No (Home)">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$employeeInfo->country}}" name="country" placeholder="Country">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$employeeInfo->district}}" name="district" placeholder="District">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$employeeInfo->streetAddress}}" name="streetAddress" placeholder="Street Adress">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$employeeInfo->postalCode}}" name="postalCode" placeholder="Postal Code">
                                      </div>
                                      <div class="form-group">
                                        <button class="btn btn-primary" class="form-control">Submit</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                      </h6>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Name:</div>
                          <div class="col-6">{{$employeeInfo->name}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Position:</div>
                          <div class="col-6">{{$employeeInfo->designation}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Gender:</div>
                          <div class="col-6">{{$employeeInfo->gender}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Birthday:</div>
                          <div class="col-6">{{$employeeInfo->birthday}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Phone(Myself):</div>
                          <div class="col-6">{{$employeeInfo->phone}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Phone(Home):</div>
                          <div class="col-6">{{$employeeInfo->phone2}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Employee Category:</div>
                          <div class="col-6">{{$employeeInfo->employeetype}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Country:</div>
                          <div class="col-6">{{$employeeInfo->country}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">District:</div>
                          <div class="col-6">{{$employeeInfo->district}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Street Address:</div>
                          <div class="col-6">{{$employeeInfo->streetAddress}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Postal Code:</div>
                          <div class="col-6">{{$employeeInfo->postalCode}}</div>
                      </div>
                  </div>
              </div>
              <div class="card">
                  <div class="card-body">
                      <h6 class="card-title d-flex justify-content-between align-items-center">
                          NID/Passport
                         <!--  <a href="#" class="btn btn-outline-light btn-sm" data-toggle="modal" data-target="#nidModal">
                              <i data-feather="upload" class="mr-2"></i> Upload
                          </a> -->

                      <!-- Modal -->
                        <div class="modal fade custom-modal-one" id="nidModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">NID/Passport Upload</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                  <span aria-hidden="true">&times;</span>
                                </button>
                              </div>
                              <div class="modal-body">
                                <div class="modal-form">
                                  <form action="{{url('employee/nid-passport/upload')}}" method="POST" enctype="multipart/form-data">
                                    @csrf
                                    <div class="form-group">
                                      <input type="text" class="form-control" value="" name="title" placeholder="Title">
                                    </div>
                                    <div class="form-group">
                                      <input type="file" class="form-control"  name="document" accept="image/*">
                                    </div>
                                    <div class="form-group">
                                      <button class="btn btn-primary" class="form-control"><i data-feather="upload"></i> Upload</button>
                                    </div>
                                  </form>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <!-- modal end -->
                      </h6>
                      <div class="row row-xs">
                        @foreach($employeepersonaldoc as $epersonaldoc)
                          <div class="col-lg-4 mb-3">
                              <img class="img-fluid rounded" src="{{asset($epersonaldoc->document)}}"
                                   alt="image">
                          </div>
                          @endforeach
                      </div>
                  </div>
              </div>
              <div class="card">
                  <div class="card-body">
                      <h6 class="card-title d-flex justify-content-between align-items-center">
                          Educational Doc
                          <!-- <a href="#" class="btn btn-outline-light btn-sm" data-toggle="modal" data-target="#edicationModal">
                              <i data-feather="upload" class="mr-2"></i> Upload
                          </a> -->

                      <!-- Modal -->
                        <div class="modal fade custom-modal-one" id="edicationModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Educational Doc Upload</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                  <span aria-hidden="true">&times;</span>
                                </button>
                              </div>
                              <div class="modal-body">
                                <div class="modal-form">
                                  <form action="{{url('employee/educational-doc/upload')}}" method="POST" enctype="multipart/form-data">
                                    @csrf
                                    <div class="form-group">
                                      <input type="text" class="form-control" value="" name="title" placeholder="Title">
                                    </div>
                                    <div class="form-group">
                                      <input type="file" class="form-control"  name="document" accept="image/*">
                                    </div>
                                    <div class="form-group">
                                      <button class="btn btn-primary" class="form-control"><i data-feather="upload"></i> Upload</button>
                                    </div>
                                  </form>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <!-- modal end -->
                      </h6>
                      <div class="row row-xs">
                        @foreach($employeeEducationaldoc as $eEducationaldoc)
                          <div class="col-lg-4 mb-3">
                              <img class="img-fluid rounded" src="{{asset($eEducationaldoc->document)}}"
                                   alt="image">
                          </div>
                          @endforeach
                      </div>
                  </div>
              </div>


          </div>
          <div class="col-md-8">

              <div class="card">
                  <div class="card-body">
                      <!-- <form>
                          <div class="form-group">
                              <textarea rows="2" class="form-control" placeholder="Create something"></textarea>
                          </div>
                          <div class="text-right">
                              <ul class="list-inline">
                                  <li class="list-inline-item">
                                      <a href="#" data-toggle="tooltip" title="Add Image"
                                         class="btn btn-outline-light">
                                          <i data-feather="image"></i>
                                      </a>
                                  </li>
                                  <li class="list-inline-item">
                                      <a href="#" data-toggle="tooltip" title="Add Video"
                                         class="btn btn-outline-light">
                                          <i data-feather="video"></i>
                                      </a>
                                  </li>
                                  <li class="list-inline-item">
                                      <a href="#" data-toggle="tooltip" title="Add File"
                                         class="btn btn-outline-light">
                                          <i data-feather="file"></i>
                                      </a>
                                  </li>
                                  <li class="list-inline-item">
                                      <button class="btn btn-primary">Submit</button>
                                  </li>
                              </ul>
                          </div>
                      </form> -->
                  </div>
              </div>

              <div class="card">
                  <div class="card-body">
                      <ul class="nav nav-pills flex-column flex-sm-row" id="myTab" role="tablist">
                          <li class="flex-sm-fill text-sm-center nav-item">
                              <a class="nav-link active" id="home-tab" data-toggle="tab" href="#home"
                                 role="tab" aria-selected="true">Posts</a>
                          </li>
                          <li class="flex-sm-fill text-sm-center nav-item">
                              <a class="nav-link" id="timeline-tab" data-toggle="tab" href="#timeline"
                                 role="tab" aria-selected="true">NID/Passport  <span class="badge badge-light m-l-5">{{$employeepersonaldoc->count()}}</span></a>
                          </li>
                          <li class="flex-sm-fill text-sm-center nav-item">
                              <a class="nav-link" id="connections-tab1" data-toggle="tab" href="#connections"
                                 role="tab"
                                 aria-selected="false">
                                  Education Docs <span class="badge badge-light m-l-5">{{$employeeEducationaldoc->count()}}</span>
                              </a>
                          </li>
                          <li class="flex-sm-fill text-sm-center nav-item">
                              <a class="nav-link" id="earnings-tab" data-toggle="tab" href="#earnings" role="tab"
                                 aria-selected="false">Earnings</a>
                          </li>
                      </ul>
                  </div>
              </div>

              <div class="tab-content" id="myTabContent">
                  <div class="tab-pane fade show active" id="home" role="tabpanel">
                      @foreach($forumarticles as $forumarticle)
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex mb-3">
                            @php
                                $articleimages = App\ForumImage::where('postId',$forumarticle->id)->get();
                                $articleUser = App\User::where('email',$forumarticle->email)->first();
                                 if($articleUser==NULL){
                                    $articleUser = App\Employee::where('email',$forumarticle->email)->first();
                                }
                                $articlecomments = App\ArticleComment::where('postId',$forumarticle->id)->orderBy('id','DESC')->get();
                                $articlelike = App\ArticleLike::where('postId',$forumarticle->id)->orderBy('id','DESC')->count();
                                $employeeInfo = App\Employee::where('email',$forumarticle->email)->first();
                                $enabletolike = App\ArticleLike::where('postId',$forumarticle->id)->where('email',$employeeInfo->email)->count();
                                $forumImages = App\ForumImage::where('postId',$forumarticle->id)->get();
                            @endphp
                            <div class="d-flex align-items-center">
                                <figure class="avatar avatar-sm mr-3">
                                    <img src="@if($articleUser->image) {{asset($articleUser->image)}} @else {{asset($articleUser->profilepic)}} @endif"
                                         class="rounded-circle" alt="...">
                                </figure>
                                <div class="d-inline-block">
                                    <div><strong>{{$articleUser->name}}</strong> shared a post</div>
                                    <small class="text-muted">{{$forumarticle->created_at->diffForHumans()}}</small>
                                </div>
                            </div>
                            @if($forumarticle->email == $employeeInfo->email)
                            <div class="dropdown ml-auto">
                                <a href="#" data-toggle="dropdown">
                                    <i class="fa fa-ellipsis-v"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right">
                                    <a  class="dropdown-item anchor" data-toggle="modal" data-target="#articleModal{{$forumarticle->id}}">Edit</a>
                                    <a href="#" class="dropdown-item" onclick="event.preventDefault();document.getElementById('articledelete-form').submit();" >Delete</a>
                                    <form id="articledelete-form" action="{{ url('employee/article/delete') }}" method="POST" style="display: none;">
                                        <input type="hidden" name="postId" value="{{$forumarticle->id}}">
                                      @csrf
                                   </form>
                                </div>
                            </div>
                            @endif
                        </div>
                        <p>
                            {{$forumarticle->post}}
                        </p>
                        <div class="row row-xs mrtp-20">
                            @foreach($forumImages as $forumImage)
                            <div class="@if($forumImages->count() > 1) col-6 @else col-12 @endif mrtp-8">
                                <img src="{{asset($forumImage->image)}}"
                                     alt="image">
                            </div>
                            @endforeach
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <div>
                                @if($enabletolike)
                                <a class="anchor" title="Liked" data-toggle="tooltip">
                                    <i data-feather="heart"
                                       class="width-17 height-17 mr-1 text-danger"></i> {{$articlelike}}
                                </a>
                                
                               @else
                               <a href="" title="Like" data-toggle="tooltip" onclick="event.preventDefault();document.getElementById('articlelike-form').submit();" >
                                    <i data-feather="heart"
                                       class="width-17 height-17 mr-1 text-muted"></i> {{$articlelike}}
                                </a>
                                <form id="articlelike-form" action="{{ url('employee/article/like') }}" method="POST" style="display: none;">
                                    <input type="hidden" name="postId" value="{{$forumarticle->id}}">
                                  @csrf
                               </form>
                               @endif
                            </div>
                            <div>
                                <a href="#" title="Comments" data-toggle="tooltip">
                                    <i data-feather="message-square" class="width-17 height-17 mr-1"></i> {{$articlecomments->count()}}
                                </a>
                            </div>
                        </div>
                        <!-- People who wrote, liked, or shared a comment -->
                        <div class="mt-4">
                            <div class="card card-body border p-3 comment-margin">
                            @foreach($articlecomments as $articlecomment)
                                @php
                                    $commentUser = App\User::where('email',$articlecomment->email)->first();
                                    if($commentUser==NULL){
                                        $commentUser = App\Employee::where('email',$articlecomment->email)->first();
                                    }
                                @endphp
                                <div class="d-flex">
                                    <figure class="avatar avatar-sm mr-3">
                                        <img src="@if($commentUser->image) {{asset($commentUser->image)}} @else {{asset($commentUser->profilepic)}} @endif"
                                         class="rounded-circle" alt="...">
                                    </figure>

                                <div class="flex-grow-1">
                                    <strong>{{$commentUser->name}}</strong>
                                    <p>{{$articlecomment->comment}}</p>
                                </div>
                                </div>

                                <!-- <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <a href="#" title="Like" data-toggle="tooltip">
                                            <i data-feather="heart" class="width-17 height-17 mr-1"></i> 3
                                        </a>
                                        <a href="#" class="ml-3">
                                            Reply
                                        </a>
                                    </div>
                                </div> -->
                              @endforeach
                            </div>
                           
                            <form action="{{url('employee/article/comment')}}" method="POST" class="d-flex">
                                @csrf
                                <input type="hidden" value="{{$forumarticle->id}}" name="postId">
                                <div>
                                    <figure class="avatar avatar-sm mr-3">
                                        <img src="{{asset($employeeInfo->profilepic)}}"
                                             class="rounded-circle" alt="...">
                                    </figure>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="form-group">
                                        <textarea rows="2" name="comment" required="required" class="form-control"
                                                  placeholder="Post comment for @zadu"></textarea>
                                    </div>
                                    <button class="btn btn-primary">Submit</button>
                                </div>
                            </form>
                                <!-- Modal -->
                                <div class="modal fade custom-modal-one" id="articleModal{{$forumarticle->id}}" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                  <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                      <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLabel">Edit Post</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                          <span aria-hidden="true">&times;</span>
                                        </button>
                                      </div>
                                      <div class="modal-body">
                                        <div class="modal-form">
                                          <form action="{{url('employee/forum-article/update/')}}" method="POST" enctype="multipart/form-data">
                                            @csrf
                                            <input type="hidden" name="postId" value="{{$forumarticle->id}}">
                                            <div class="form-group">
                                                <textarea name="post" id="" class="form-control forum-form" cols="30" rows="10">{{$forumarticle->post}}</textarea>
                                            </div>
                                            <div class="form-group">
                                            <input type="file" class="form-control" name="image[]" multiple="multiple" placeholder="Name" accept="image*">
                                             @foreach($forumImages as $forumImage)
                                              <img  src="{{asset($forumImage->image)}}"
                                                       class="rounded-circle small-image mrtp-20" alt="...">
                                                <a href="{{url('employee/article/image-delete/'.$forumImage->id)}}"><i data-feather="trash"></i></a>
                                                @endforeach
                                            </div>
                                            <button class="btn btn-primary">Save Change</button>
                                          </form>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                             <!-- modal end -->
                        </div>
                        <!-- ./ People who wrote, liked, or shared a comment -->
                    </div>
                </div>
                @endforeach
                      
                  </div>
                  <div class="tab-pane fade show" id="timeline" role="tabpanel">
                      <div class="card">
                          <div class="card-body custom-card">
                              <h6 class="card-title">NID/Passport</h6>
                              <!-- <a href="#" class="btn btn-outline-light btn-sm" data-toggle="modal" data-target="#nidModal">
                                <i data-feather="upload" class="mr-2"></i> Upload
                             </a> -->
                              <table id="myTable" class="table table-striped table-bordered">
                                <thead>
                                  <tr>
                                    <th>Title</th>
                                    <th>Image</th>
                                    <th>Manage</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  @foreach($employeepersonaldoc as $epersonaldoc)
                                  <tr>
                                    <td>{{$epersonaldoc->title}}</td>
                                    <td><img src="{{asset($epersonaldoc->document)}}" alt="" class="small-image"></td>
                                    <!-- <td><div class="dropdown">
                                        <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                          Select
                                        </button>
                                        <div class="dropdown-menu custom-action">
                                            <a class="dropdown-item" data-toggle="modal" data-target="#personalChangeModal{{$epersonaldoc->id}}">Change</a>
                                          </li>
                                          <li class="dropdown-item">
                                            <form action="{{url('employee/nid-passport/delete')}}" method="POST">
                                              @csrf
                                              <input type="hidden" name="hidden_id" value="{{$epersonaldoc->id}}">
                                              <button type="submit" onclick="return confirm('Are you delete this user?')" >Delete</button>
                                            </form>
                                          </li>
                                        </td> -->
                                  </tr>
                                  <!-- Modal -->
                                  <div class="modal fade custom-modal-one" id="personalChangeModal{{$epersonaldoc->id}}" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog" role="document">
                                      <div class="modal-content">
                                        <div class="modal-header">
                                          <h5 class="modal-title" id="exampleModalLabel">Educational Doc Change</h5>
                                          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                          </button>
                                        </div>
                                        <div class="modal-body">
                                          <div class="modal-form">
                                            <form action="{{url('employee/nid-passport/update')}}" method="POST" enctype="multipart/form-data">
                                              @csrf
                                              <div class="form-group">
                                                <input type="hidden" value="{{$epersonaldoc->id}}" name="hidden_id">
                                                <input type="text" class="form-control" value="{{$epersonaldoc->title}}" name="title" placeholder="Title">
                                              </div>
                                              <div class="form-group">
                                                <input type="file" class="form-control"  name="document" accept="image/*">
                                                <img src="{{asset($epersonaldoc->document)}}" alt="" class="small-image">
                                              </div>
                                              <div class="form-group">
                                                <button class="btn btn-primary" class="form-control"><i data-feather="upload"></i> Save Change</button>
                                              </div>
                                            </form>
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                  <!-- modal end -->
                                  @endforeach
                                </tbody>
                              </table>
                          </div>
                      </div>
                  </div>
                  <div class="tab-pane fade" id="connections" role="tabpanel">
                      <div class="card">
                          <div class="card-body custom-card">
                              <h6 class="card-title">Educational Document</h6>
                              <!-- <a href="#" class="btn btn-outline-light btn-sm" data-toggle="modal" data-target="#edicationModal">
                                <i data-feather="upload" class="mr-2"></i> Upload
                             </a> -->
                              <table id="myTable" class="table table-striped table-bordered">
                                <thead>
                                  <tr>
                                    <th>Title</th>
                                    <th>Image</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  @foreach($employeeEducationaldoc as $eEducationaldoc)
                                  <tr>
                                    <td>{{$eEducationaldoc->title}}</td>
                                    <td><img src="{{asset($eEducationaldoc->document)}}" alt="" class="small-image"></td>
                                    <!-- <td><div class="dropdown">
                                        <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                          Select
                                        </button>
                                        <div class="dropdown-menu custom-action">
                                            <a class="dropdown-item" data-toggle="modal" data-target="#edicationChangeModal{{$eEducationaldoc->id}}">Change</a>
                                          </li>
                                          <li class="dropdown-item">
                                            <form action="{{url('employee/eiducational-doc/delete')}}" method="POST">
                                              @csrf
                                              <input type="hidden" name="hidden_id" value="{{$eEducationaldoc->id}}">
                                              <button type="submit" onclick="return confirm('Are you delete this user?')" >Delete</button>
                                            </form>
                                          </li>
                                        </td> -->

                                  <!-- Modal -->
                                  <div class="modal fade custom-modal-one" id="edicationChangeModal{{$eEducationaldoc->id}}" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog" role="document">
                                      <div class="modal-content">
                                        <div class="modal-header">
                                          <h5 class="modal-title" id="exampleModalLabel">Educational Doc Change</h5>
                                          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                          </button>
                                        </div>
                                        <div class="modal-body">
                                          <div class="modal-form">
                                            <form action="{{url('employee/edicational-doc/update')}}" method="POST" enctype="multipart/form-data">
                                              @csrf
                                              <div class="form-group">
                                                <input type="hidden" value="{{$eEducationaldoc->id}}" name="hidden_id">
                                                <input type="text" class="form-control" value="{{$eEducationaldoc->title}}" name="title" placeholder="Title">
                                              </div>
                                              <div class="form-group">
                                                <input type="file" class="form-control"  name="document" accept="image/*">
                                                <img src="{{asset($eEducationaldoc->document)}}" alt="" class="small-image">
                                              </div>
                                              <div class="form-group">
                                                <button class="btn btn-primary" class="form-control"><i data-feather="upload"></i> Save Change</button>
                                              </div>
                                            </form>
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                  <!-- modal end -->
                                  </tr>
                                  @endforeach
                                </tbody>
                              </table>
                          </div>
                      </div>
                  </div>
                  <div class="tab-pane fade" id="earnings" role="tabpanel">
                      <div class="card">
                          <div class="card-body">
                              <h6 class="card-title">Earnings</h6>
                              <div class="table-responsive">
                                  <table class="table table-striped">
                                    <thead>
                                      <tr>
                                        <th>SL</th>
                                        <th>Date</th>
                                        <th>Day</th>
                                        <th>Total Point</th>
                                        <th>OT Point</th>
                                        <th>OT Amount</th>
                                      </tr>
                                    </thead>
                                    <tbody>
                                      @foreach($thismonthworks as $thismonthwork)
                                      <tr>
                                        <td>{{$loop->iteration}}</td>
                                        <td>{{date('F d', strtotime($thismonthwork->created_at))}}</td>
                                          <td>{{date('D', strtotime($thismonthwork->created_at))}} day</td>
                                          <td>{{$thismonthwork->totalpoint}}</td>
                                          <td>{{$thismonthwork->otpoint}}</td>
                                          <td>{{$thismonthwork->otamount}}</td>
                                      </tr>
                                      @endforeach
                                    </tbody>
                                  </table>
                                  <!-- single table end -->     
                                </div>
                          </div>
                      </div>
                  </div>
              </div>

          </div>
      </div>
 </div>
@endsection