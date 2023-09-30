<div class="form-group <?php echo !$errors->has($label) ?: 'has-error'; ?>">

    <label for="<?php echo e($id, false); ?>" class="col-sm-2 control-label"><?php echo e($label, false); ?></label>

    <div class="<?php echo e($viewClass['field'], false); ?>">
        <?php $__currentLoopData = $value; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key=>$val): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
         <label class="control-label col-sm-2"><?php echo e($key, false); ?></label>
          <div class="col-sm-8 input-group"><input class="form-control" type="text" name="<?php echo e($key, false); ?>" value="<?php echo e($val, false); ?>"/></div>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    </div>
</div>

<script>


</script>
<?php /**PATH /www/wwwroot/dbf.dbestech.com/resources/views/admin/setcontent.blade.php ENDPATH**/ ?>