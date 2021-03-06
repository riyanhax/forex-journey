<!DOCTYPE html>
<html lang="en">
<head>
    <style>
.note-editor .note-toolbar, .note-popover .popover-content {
    margin: 0;
    padding: 0 0 5px 5px;
    background-color: #fff;
    border-radius:5px;
}
.note-editor.note-airframe .note-editing-area .note-editable, .note-editor.note-frame .note-editing-area .note-editable {
    min-height:200px;
    overflow: auto;
    word-wrap: break-word;
    border: 1px solid gray;
    margin-top: 10px;
    border-radius:5px;
}
</style>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Journey forex - @yield('title','Welcome To Journey Forex')</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="{{asset('public/backEnd/')}}/assets/media/image/favicon.png"/>
    <!-- Plugin styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/bundle.css" type="text/css">
    <!-- quill -->
    <link href="{{asset('public/backEnd/')}}/vendors/quill/quill.snow.css" rel="stylesheet" type="text/css">
    <!-- Tagsinput -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/tagsinput/bootstrap-tagsinput.css" type="text/css">
    <!-- morris styles -->
     <!-- Morsis -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/charts/morsis/morris.css" type="text/css">

    <!-- Prism -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/prism/prism.css" type="text/css">
    <!-- App styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/assets/css/app.min.css" type="text/css">
    <!-- toastr styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/assets/css/toastr.min.css" type="text/css">
    <!-- custom styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/select2/css/select2.min.css" type="text/css">
    <!-- dataTable styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/dataTable/dataTables.min.css" type="text/css">
    <!-- datepkrr -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <!-- select2 styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/assets/css/custom.css" type="text/css">
    
    <!-- This js is for richtext function on this page -->
    <script src="https://cdn.tiny.cloud/1/3v39fnf4cnmr4g78v19fe2mlqhttbmh9ze5uwg8ss2xtdqmd/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
    
    
    
    
    
</head>
<body class="dark">

<!-- begin::preloader-->
<div class="preloader">
    <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="50px" height="50px" viewBox="0 0 128 128"
         xml:space="preserve">
        <rect x="0" y="0" width="100%" height="100%" fill="#FFFFFF"/>
        <g>
            <path d="M75.4 126.63a11.43 11.43 0 0 1-2.1-22.65 40.9 40.9 0 0 0 30.5-30.6 11.4 11.4 0 1 1 22.27 4.87h.02a63.77 63.77 0 0 1-47.8 48.05v-.02a11.38 11.38 0 0 1-2.93.37z"
                  fill="#000000" fill-opacity="1"/>
            <animateTransform attributeName="transform" type="rotate" from="0 64 64" to="360 64 64"
                              dur="500ms" repeatCount="indefinite">
            </animateTransform>
        </g>
    </svg>
</div>
<!-- end::preloader -->

<!-- begin::navigation -->
<div class="navigation">

    <!-- begin::logo -->
    <div id="logo">
        <a href="{{url('/')}}">
           @foreach($whitelogo as $logo)
            <img class="logo-dark" src="{{asset($logo->image)}}" alt="dark logo">
           @endforeach
        </a>
    </div>
    <!-- end::logo -->

    <!-- begin::navigation header -->
    <header class="navigation-header">
        <figure class="avatar avatar-state-success">
            <img src="{{asset(Auth::user()->image)}}" class="rounded-circle" alt="image">
        </figure>
        <div>
            <h5>{{auth::user()->name}}</h5>
            <p class="text-muted">{{auth::user()->designation}}</p>
            <ul class="nav">
                <li class="nav-item">
                    <a href="{{url('superadmin/dashboard')}}" class="btn nav-link bg-info-bright" title="Profile" data-toggle="tooltip">
                        <i data-feather="user"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="{{url('/')}}" target="_blank" class="btn nav-link bg-success-bright" title="Settings" data-toggle="tooltip">
                        <i data-feather="globe"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="{{ route('logout') }}" onclick="event.preventDefault();document.getElementById('logout-form').submit();"  class="btn nav-link bg-danger-bright" title="Logout" data-toggle="tooltip">
                        <i data-feather="log-out"></i>
                        <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                          @csrf
                       </form>
                    </a>
                </li>
            </ul>
        </div>
    </header>
    <!-- end::navigation header -->

    <!-- begin::navigation menu -->
    <div class="navigation-menu-body">
        <ul>
           
           <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="coffee"></i>
                    <span>Logo</span>
                </a>
                <ul>
                    <li>
                        <a href="{{url('admin/logo/add')}}">Create</a>
                        <a href="{{url('admin/logo/manage')}}">Manage</a>
                    </li>
                    <!-- main nav end -->
                </ul>
            </li>
            <!-- main nav end -->
            <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="user"></i>
                    <span>Admin User</span>
                </a>
                <ul>
                    <li><a href="{{url('superadmin/user/add')}}">Add</a></li>
                    <li><a href="{{url('superadmin/user/manage')}}">Manage</a></li>
                </ul>
            </li>
            <!-- main nav end -->
           <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="users"></i>
                    <span>Members</span>
                </a>
                <ul>
                    <li><a href="{{url('superadmin/member/manage')}}">All Member</a></li>
                    <li><a href="{{url('superadmin/active-member/manage')}}">Active Members</a></li>
                    <li><a href="{{url('superadmin/inactive-member/manage')}}">Inactive Members</a></li>
                </ul>
            </li>
            <!-- main nav end -->
           <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>Category</span>
                </a>
                <ul>
                    <li><a href="{{url('editor/category/add')}}">Add</a></li>
                    <li><a href="{{url('editor/category/manage')}}">Manage</a></li>
                </ul>
            </li>
			
			<!-- user post-->
           <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>User all post</span>
                </a>
                <ul>
                    <li><a href="{{url('editor/post/manage')}}">View Post</a></li>
                    <li><a href="{{url('editor/post/create')}}">Add Post</a></li>                    
                </ul>
            </li>
            <!-- Uder post end -->
			
            <!-- main nav end -->
           <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>Education</span>
                </a>
                <ul>
                    <li><a href="{{url('editor/education/manage')}}">Manage Post</a></li>
                    <li><a href="{{url('editor/ecategory/manage')}}">Add Category</a></li>
                </ul>
            </li>
            <!-- main nav end -->
           <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>Broker</span>
                </a>
                <ul>
                    <li><a href="{{url('editor/broker/add')}}">Add Post</a></li>
                    <li><a href="{{url('editor/broker/manage')}}">View Post</a></li>
                </ul>
            </li>
            <!-- main nav end -->
            <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>Broker Review</span>
                </a>
                <ul>
                    <li><a href="{{url('editor/brokerreview/add')}}">Add Post</a></li>
                    <li><a href="{{url('editor/brokerreview/manage')}}">View Post</a></li>
                </ul>
            </li>
            <!-- main nav end -->
           <li>
                <a href="#">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>Advertisement</span>
                </a>
                <ul>
                    <li><a href="{{url('editor/adcategory/manage')}}">Add Category</a></li>
                    <li><a href="{{url('editor/advertisement/manage')}}">Add Banner</a></li>
                </ul>
            </li>
            <!-- main nav end -->
          <li>
                <a href="{{url('editor/color')}}">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>Color & Font Setting</span>
                </a>
                
            </li>
            
            <li>
                <a href="{{url('editor/password/change')}}">
                    <i class="nav-link-icon" data-feather="check-circle"></i>
                    <span>Password Change</span>
                </a>
                
            </li>
            <!-- main nav end -->
            <li>
                <a href="{{ route('logout') }}" onclick="event.preventDefault();document.getElementById('logout-form').submit();" title="Logout" data-toggle="tooltip">
                        <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                          @csrf
                       </form>
                    <i class="nav-link-icon" data-feather="log-out"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </div>
    <!-- end::navigation menu -->

</div>
<!-- end::navigation -->

<!-- begin::main -->
<div id="main">

    <!-- begin::header -->
    <div class="header">

        <!-- begin::header left -->
        <ul class="navbar-nav">

            <!-- begin::navigation-toggler -->
            <li class="nav-item navigation-toggler">
                <a href="#" class="nav-link">
                    <i data-feather="menu"></i>
                </a>
            </li>
            <!-- end::navigation-toggler -->

            <!-- begin::header-logo -->
            <li class="nav-item" id="header-logo">
                <a href="{{url('employee/dashboard')}}">
                    <img class="logo" src="{{asset('public/backEnd/')}}/assets/media/image/logo.png" alt="logo">
                    <img class="logo-sm" src="{{asset('public/backEnd/')}}/assets/media/image/logo-sm.png" alt="small logo">
                    <img class="logo-dark" src="{{asset('public/backEnd/')}}/assets/media/image/logo-dark.png" alt="dark logo">
                </a>
            </li>
            <!-- end::header-logo -->
        </ul>
        <!-- end::header left -->

        <!-- begin::header-right -->
        <div class="header-right">
            <ul class="navbar-nav">

                <!-- begin::search-form -->
                <li class="nav-item search-form">
                    <div class="row">
                        <div class="col-md-6">
                            <form>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Search">
                                    <div class="input-group-append">
                                        <button class="btn btn-default" type="button">
                                            <i data-feather="search"></i>
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </li>
                <!-- end::search-form -->

                <!-- begin::header minimize/maximize -->
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link" title="Fullscreen" data-toggle="fullscreen">
                        <i class="maximize" data-feather="maximize"></i>
                        <i class="minimize" data-feather="minimize"></i>
                    </a>
                </li>
                <!-- end::header minimize/maximize -->

                <!-- begin::header app list -->
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link" title="Apps" data-toggle="dropdown">
                        <i data-feather="grid"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right dropdown-menu-big">
                        <div class="p-3">
                            <h6 class="text-uppercase font-size-11 mb-3">Web Apps</h6>
                            <div class="row row-xs">
                                <div class="col-6">
                                    <a href="{{url('employee/work-history')}}">
                                        <div class="text-uppercase font-size-11 p-3 border-radius-1 border text-center mb-3">
                                            <i class="text-success width-23 height-23" data-feather="check-circle"></i>
                                            <div class="mt-2">Point</div>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-6">
                                    <a href="{{url('employee/work-history')}}">
                                        <div class="text-uppercase font-size-11 p-3 border-radius-1 border text-center mb-3">
                                            <i class="text-info width-23 height-23" data-feather="mail"></i>
                                            <div class="mt-2">History</div>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-6">
                                    <a href="{{url('employee/rank')}}">
                                        <div class="text-uppercase font-size-11 p-3 border-radius-1 border text-center">
                                            <i class="text-warning width-23 height-23" data-feather="calendar"></i>
                                            <div class="mt-2">Rank</div>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-6">
                                    <a href="{{url('employee/forum')}}">
                                        <div class="text-uppercase font-size-11 p-3 border-radius-1 border text-center">
                                            <i class="text-danger width-23 height-23" data-feather="file"></i>
                                            <div class="mt-2">Forum</div>
                                        </div>
                                    </a>
                                </div>

                            </div>
                        </div>
                    </div>
                </li>
                <!-- end::header app list -->

                <!-- begin::header messages dropdown -->
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link nav-link-notify" title="Log Out" data-toggle="dropdown">
                        <i data-feather="log-out"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right dropdown-menu-big">
                        <div>
                            <ul class="list-group list-group-flush">
                                <li>
                                    <a href="{{ route('logout') }}" onclick="event.preventDefault();document.getElementById('logout-form').submit();" class="list-group-item d-flex hide-show-toggler">
                                        <div>
                                            <figure class="avatar avatar-sm m-r-15">
                                                <img src="{{asset(auth::user()->image)}}"
                                                     class="rounded-circle" alt="user">
                                            </figure>
                                        </div>
                                        <div class="flex-grow-1">
                                            <p class="mb-0 line-height-20 d-flex justify-content-between">
                                               {{auth::user()->name}}
                                                <i title="Make unread" data-toggle="tooltip"
                                                   class="hide-show-toggler-item fa fa-circle-o font-size-11"></i>
                                            </p>
                                            <div class="small text-muted">
                                                <span>Logout</span>
                                            </div>
                                        </div>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </li>
                <!-- end::header messages dropdown -->

            <ul class="navbar-nav d-flex align-items-center">
                <li class="nav-item header-toggler">
                    <a href="#" class="nav-link">
                        <i data-feather="arrow-down"></i>
                    </a>
                </li>
            </ul>
            <!-- end::mobile header toggler -->
        </div>
        <!-- end::header-right -->
    </div>
    <!-- end::header -->

    <!-- begin::main-content -->
    <main class="main-content">

        @yield('content')

    </main>
    <!-- end::main-content -->

    <!-- begin::footer -->
    <footer>
        <div class="container-fluid">
            <div>?? @php date('Y')@endphp Journeyforex v1.0.0 Made by</div>
            <div>
                <nav class="nav">
                    <a href="#" class="nav-link">Support</a>
                    <a href="#" target="_blank" class="nav-link">Visit Us</a>
                    <a href="#" class="nav-link">Get Help</a>
                </nav>
            </div>
        </div>
    </footer>
    <!-- end::footer -->

</div>
<!-- end::main -->

<div class="modal fade" tabindex="-1" role="dialog" id="compose">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Compose Email</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <i class="ti-close"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="d-flex justify-content-between m-b-20">
                    <div>
                        <a href="#" data-toggle="tooltip" title=""
                           class="btn btn-outline-light btn-sm mr-2"
                           data-original-title="Keep">
                            <i data-feather="save"></i>
                        </a>
                        <a href="#" data-toggle="tooltip" title=""
                           class="btn btn-outline-light btn-sm mr-2"
                           data-original-title="Delete">
                            <i data-feather="trash-2"></i>
                        </a>
                    </div>
                </div>
                <form>
                    <div class="form-group">
                        <input type="text" class="form-control tagsinput" placeholder="To"
                               value="example@test.com.tr" required>
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="Subject" required>
                    </div>
                    <div class="form-group">
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" multiple id="customFileLangHTML">
                            <label class="custom-file-label" for="customFileLangHTML" data-browse="Select files">Voeg je document toe</label>
                        </div>
                    </div>
                    <div>
                        <div class="compose-quill-editor mb-3"></div>
                        <div class="d-flex justify-content-between">
                            <div class="compose-quill-toolbar">
                            <span class="ql-formats mr-0">
                                <button class="ql-bold"></button>
                                <button class="ql-italic"></button>
                                <button class="ql-underline"></button>
                                <button class="ql-link"></button>
                                <button class="ql-image"></button>
                            </span>
                            </div>
                            <button class="btn btn-primary">
                                <i data-feather="send" class="mr-2"></i>
                                Send
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Plugin scripts -->

 <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
 <script>
    function chatContent(){
     $.ajax({
       type:"GET",
       url:"{{url('editor/admin-to-employee/chat/content')}}",
       dataType: "html",
       success: function(message){
         toastr.success('Your cart update successfully', 'Success');
         $('.chatBox').html(message);
       }
        });
    }
  $('.admin_chatting').click(function(){
        var id = $(this).data("id");
        if(id){
            $.ajax({
               cache: 'false',
               type:"GET",
               url:"{{url('editor/admin-to-employee/chat')}}/"+id,
               dataType: "json",
                success: function(message){
                    return chatContent();
                    }
                });
            }
       });
</script>
<script src="{{asset('public/backEnd/')}}/vendors/bundle.js"></script>

<!-- Chartjs -->
<script src="{{asset('public/backEnd/')}}/vendors/charts/chartjs/chart.min.js"></script>
<!-- Circle progress -->
<script src="{{asset('public/backEnd/')}}/vendors/circle-progress/circle-progress.min.js"></script>
<!-- morsis scripts -->
<!-- Apex Chart -->
<script src="https://apexcharts.com/samples/assets/irregular-data-series.js"></script>
<script src="{{asset('public/backEnd/')}}/vendors/charts/apex/apexcharts.min.js"></script>
@yield('extrajs')
<!-- Prism -->
<script src="{{asset('public/backEnd/')}}/vendors/prism/prism.js"></script>
<!-- Javascript -->
<script src="{{asset('public/backEnd/')}}/vendors/dataTable/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    flatpickr("#flatpickr", {
        dateFormat: "Y m d",
    });
</script>
<!-- datepkr -->
<!-- Bootstrap 4 and responsive compatibility -->
<script src="{{asset('public/backEnd/')}}/vendors/dataTable/dataTables.bootstrap4.min.js"></script>
<script src="{{asset('public/backEnd/')}}/vendors/dataTable/dataTables.responsive.min.js"></script>
<script src="{{asset('public/backEnd/')}}/assets/js/examples/dashboard.js"></script>
<script src="{{asset('public/backEnd/')}}/assets/js/toastr.min.js"></script>
 {!! Toastr::message() !!}
<script src="{{asset('public/backEnd/')}}/vendors/select2/js/select2.min.js"></script>
 
  
  
  


<script>
$('.select2-example').select2({
    placeholder: 'Select'
});

$(document).ready(function (){
    $('#myTable').DataTable();
});

</script>

<!-- App scripts -->
<script src="{{asset('public/backEnd/')}}/assets/js/app.min.js"></script>



<script type="text/javascript">
        $('#eduCategory').change(function(){
            // alert('test');
        var ajaxId = $(this).val();    
        if(ajaxId){
            $.ajax({
               type:"GET",
               url:"{{url('editor/ajax-education-subcategory')}}?ecategory_id="+ajaxId,
               success:function(res){               
                if(res){
                    $("#eduSubcategory").empty();
                    $("#eduSubcategory").append('<option>Select...</option>');
                    $.each(res,function(key,value){
                        $("#eduSubcategory").append('<option value="'+key+'">'+value+'</option>');
                    });
               
                }else{
                   $("#eduSubcategory").empty();
                }
               }
            });
        }else{
            $("#eduSubcategory").empty();
            $("#eduSubcategory").empty();
        }      
       });

        $('#proSubcategory').on('change',function(){
        var ajaxId = $(this).val();    
        if(ajaxId){
            $.ajax({
               type:"GET",
               url:"{{url('ajax-product-childsubcategory')}}?category_id="+ajaxId,
               success:function(res){               
                if(res){
                    $("#proChildcategory").empty();
                     $("#proChildcategory").append('<option value="0">=====select your childcategory======</option>');
                    $.each(res,function(key,value){
                        $("#proChildcategory").append('<option value="'+key+'">'+value+'</option>');
                    });
               
                }else{
                   $("#proChildcategory").empty();
                }
               }
            });
        }else{
            $("#proChildcategory").empty();
        }
            
       });
    </script>
    
    
    
    <script type="text/javascript">

    $(document).ready(function() {

      $(".btn-success").click(function(){ 
          var html = $(".clone").html();
          $(".increment").before(html);
      });

      $("body").on("click",".btn-danger",function(){ 
          $(this).parents(".control-group").remove();
      });

    });

</script>

<script type="text/javascript">
    tinymce.init({
  selector: 'textarea.full-featured-non-premium',
  plugins: 'print preview paste importcss searchreplace autolink autosave save directionality code visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern noneditable help charmap quickbars emoticons',
  imagetools_cors_hosts: ['picsum.photos'],
  menubar: 'file edit view insert format tools table help',
  toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist | forecolor backcolor removeformat | pagebreak | charmap emoticons | fullscreen  preview save print | insertfile image media template link anchor codesample | ltr rtl',
      toolbar_sticky: true,
      autosave_ask_before_unload: true,
      autosave_interval: "30s",
      autosave_prefix: "{path}{query}-{id}-",
      autosave_restore_when_empty: false,
      autosave_retention: "2m",
      image_advtab: true,
      content_css: '//www.tiny.cloud/css/codepen.min.css',
      link_list: [
        { title: 'My page 1', value: 'http://www.tinymce.com' },
        { title: 'My page 2', value: 'http://www.moxiecode.com' }
      ],
      image_list: [
        { title: 'My page 1', value: 'http://www.tinymce.com' },
        { title: 'My page 2', value: 'http://www.moxiecode.com' }
      ],
      image_class_list: [
        { title: 'None', value: '' },
        { title: 'Some class', value: 'class-name' }
      ],
      importcss_append: true,
      height: 200,
      file_picker_callback: function (callback, value, meta) {
        /* Provide file and text for the link dialog */
        if (meta.filetype === 'file') {
          callback('https://www.google.com/logos/google.jpg', { text: 'My text' });
        }

        /* Provide image and alt text for the image dialog */
        if (meta.filetype === 'image') {
          callback('https://www.google.com/logos/google.jpg', { alt: 'My alt text' });
        }

        /* Provide alternative source and posted for the media dialog */
        if (meta.filetype === 'media') {
          callback('movie.mp4', { source2: 'alt.ogg', poster: 'https://www.google.com/logos/google.jpg' });
        }
      },
      templates: [
            { title: 'New Table', description: 'creates a new table', content: '<div class="mceTmpl"><table width="98%%"  border="0" cellspacing="0" cellpadding="0"><tr><th scope="col"> </th><th scope="col"> </th></tr><tr><td> </td><td> </td></tr></table></div>' },
        { title: 'Starting my story', description: 'A cure for writers block', content: 'Once upon a time...' },
        { title: 'New list with dates', description: 'New List with dates', content: '<div class="mceTmpl"><span class="cdate">cdate</span><br /><span class="mdate">mdate</span><h2>My List</h2><ul><li></li><li></li></ul></div>' }
      ],
      template_cdate_format: '[Date Created (CDATE): %m/%d/%Y : %H:%M:%S]',
      template_mdate_format: '[Date Modified (MDATE): %m/%d/%Y : %H:%M:%S]',
      height: 600,
      image_caption: true,
      quickbars_selection_toolbar: 'bold italic | quicklink h2 h3 blockquote quickimage quicktable',
      noneditable_noneditable_class: "mceNonEditable",
      toolbar_mode: 'sliding',
      contextmenu: "link image imagetools table",
      
     });
</script>




</body>
</html>