<div class="form-group {!! !$errors->has($label) ?: 'has-error' !!}">

    <label for="{{$id}}" class="col-sm-2 control-label">{{$label}}</label>

    <div class="{{$viewClass['field']}}">
        @foreach($value as $key=>$val)
         <label class="control-label col-sm-2">{{$key}}</label>
          <div class="col-sm-8 input-group"><input class="form-control" type="text" name="{{$key}}" value="{{$val}}"/></div>
        @endforeach
    </div>
</div>

<script>


</script>
