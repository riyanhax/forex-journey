<table id="search-data" class="table table-bordered table-striped">

   @foreach($show_datas as $show_data)
   <tr>
     
     <td>
      <a href="{{url('post/'.$show_data->slug.'/'.$show_data->id)}}">
        {{$show_data->title}}
      </a>
    </td>
     <!-- <td>{{ date('F d, Y', strtotime($show_data->created_at)) }}</td> -->
     <td>
        <a href="{{url('post/'.$show_data->slug.'/'.$show_data->id)}}" class="btn btn-success"><i class="fa fa-eye"></i></a>
     </td>
   </tr>
   @endforeach

  </table>