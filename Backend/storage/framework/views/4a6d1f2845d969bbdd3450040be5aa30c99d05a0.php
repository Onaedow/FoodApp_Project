<div class="<?php echo e($viewClass['form-group'], false); ?> <?php echo !$errors->has($errorKey) ? '' : 'has-error'; ?>">

    <label for="<?php echo e($id['lat'], false); ?>" class="<?php echo e($viewClass['label'], false); ?> control-label"><?php echo e($label, false); ?></label>

    <div class="<?php echo e($viewClass['field'], false); ?>">

        <?php echo $__env->make('admin::form.error', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?>

        <div class="row">
            <div class="col-md-3">
                <input id="<?php echo e($id['lat'], false); ?>" name="<?php echo e($name['lat'], false); ?>" class="form-control" value="<?php echo e(old($column['lat'], $value['lat'] ?? null), false); ?>" <?php echo $attributes; ?> />
            </div>
            <div class="col-md-3">
                <input id="<?php echo e($id['lng'], false); ?>" name="<?php echo e($name['lng'], false); ?>" class="form-control" value="<?php echo e(old($column['lng'], $value['lng'] ?? null), false); ?>" <?php echo $attributes; ?> />
            </div>

          

        </div>

        <br>

        <div id="map_<?php echo e($id['lat'].$id['lng'], false); ?>" style="width: 100%;height: <?php echo e($height, false); ?>px"></div>

        <?php echo $__env->make('admin::form.help-block', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?>

    </div>
</div>
<?php /**PATH /www/wwwroot/dbf.dbestech.com/vendor/laravel-admin-ext/latlong/src/../resources/views/latlong.blade.php ENDPATH**/ ?>