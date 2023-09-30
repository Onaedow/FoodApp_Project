<div class="box">
    <?php if(isset($title)): ?>
    <div class="box-header with-border">
        <h3 class="box-title"> <?php echo e($title, false); ?></h3>
    </div>
    <?php endif; ?>

    <?php if( $grid->showTools() || $grid->showExportBtn() || $grid->showCreateBtn() ): ?>
    <div class="box-header with-border">
        <div class="pull-right">
            <?php echo $grid->renderColumnSelector(); ?>

            <?php echo $grid->renderExportButton(); ?>

            <?php echo $grid->renderCreateButton(); ?>

        </div>
        <?php if( $grid->showTools() ): ?>
        <div class="pull-left">
            <?php echo $grid->renderHeaderTools(); ?>

        </div>
        <?php endif; ?>
    </div>
    <?php endif; ?>

    <?php echo $grid->renderFilter(); ?>


    <?php echo $grid->renderHeader(); ?>


    <!-- /.box-header -->
    <div class="box-body table-responsive no-padding">
        <div class="tables-container">
            <div class="table-wrap table-main">
                <table class="table grid-table" id="<?php echo e($grid->tableID, false); ?>">
                    <thead>
                        <tr>
                            <?php $__currentLoopData = $grid->visibleColumns(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $column): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <th <?php echo $column->formatHtmlAttributes(); ?>><?php echo e($column->getLabel(), false); ?><?php echo $column->renderHeader(); ?></th>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </tr>
                    </thead>

                    <tbody>

                        <?php $__currentLoopData = $grid->rows(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $row): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <tr <?php echo $row->getRowAttributes(); ?>>
                            <?php $__currentLoopData = $grid->visibleColumnNames(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $name): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <td <?php echo $row->getColumnAttributes($name); ?> class="column-<?php echo $name; ?>">
                                <?php echo $row->column($name); ?>

                            </td>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </tbody>

                    <?php echo $grid->renderTotalRow(); ?>


                </table>
            </div>

            <?php if($grid->leftVisibleColumns()->isNotEmpty()): ?>
            <div class="table-wrap table-fixed table-fixed-left">
                <table class="table grid-table">
                    <thead>
                    <tr>
                        <?php $__currentLoopData = $grid->leftVisibleColumns(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $column): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <th <?php echo $column->formatHtmlAttributes(); ?>><?php echo e($column->getLabel(), false); ?><?php echo $column->renderHeader(); ?></th>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </tr>
                    </thead>
                    <tbody>

                    <?php $__currentLoopData = $grid->rows(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $row): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <tr <?php echo $row->getRowAttributes(); ?>>
                            <?php $__currentLoopData = $grid->leftVisibleColumns(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $column): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <?php
                                    $name = $column->getName()
                                ?>
                                <td <?php echo $row->getColumnAttributes($name); ?> class="column-<?php echo $name; ?>">
                                    <?php echo $row->column($name); ?>

                                </td>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </tbody>

                    <?php echo $grid->renderTotalRow($grid->leftVisibleColumns()); ?>


                </table>
            </div>
            <?php endif; ?>

            <?php if($grid->rightVisibleColumns()->isNotEmpty()): ?>
            <div class="table-wrap table-fixed table-fixed-right">
                <table class="table grid-table">
                    <thead>
                    <tr>
                        <?php $__currentLoopData = $grid->rightVisibleColumns(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $column): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <th <?php echo $column->formatHtmlAttributes(); ?>><?php echo e($column->getLabel(), false); ?><?php echo $column->renderHeader(); ?></th>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </tr>
                    </thead>

                    <tbody>

                    <?php $__currentLoopData = $grid->rows(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $row): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <tr <?php echo $row->getRowAttributes(); ?>>
                            <?php $__currentLoopData = $grid->rightVisibleColumns(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $column): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <?php
                                $name = $column->getName()
                                ?>
                                <td <?php echo $row->getColumnAttributes($name); ?> class="column-<?php echo $name; ?>">
                                    <?php echo $row->column($name); ?>

                                </td>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </tbody>

                    <?php echo $grid->renderTotalRow($grid->rightVisibleColumns()); ?>


                </table>
            </div>
            <?php endif; ?>
        </div>
    </div>

    <?php echo $grid->renderFooter(); ?>


    <div class="box-footer clearfix">
        <?php echo $grid->paginator(); ?>

    </div>
    <!-- /.box-body -->
</div>


<style>
    .tables-container {
        position:relative;
    }

    .tables-container table {
        margin-bottom: 0px !important;
    }

    .tables-container table th, .tables-container table td {
        white-space:nowrap;
    }

    .table-wrap table tr .active {
        background: #f5f5f5;
    }

    .table-main {
        overflow-x: auto;
        width: 100%;
    }

    .table-fixed {
        position:absolute;
        top: 0px;
        background:#ffffff;
        z-index:10;
    }

    .table-fixed-left {
        left:0;
        box-shadow: 7px 0 5px -5px rgba(0,0,0,.12);
    }

    .table-fixed-right {
        right:0;
        box-shadow: -5px 0 5px -5px rgba(0,0,0,.12);
    }
</style>

<script>
    var theadHeight = $('.table-main thead tr')[0].getBoundingClientRect().height;
    $('.table-fixed thead tr').outerHeight(theadHeight);

    var tfootHeight = $('.table-main tfoot tr').outerHeight();
    $('.table-fixed tfoot tr').outerHeight(tfootHeight);

    $('.table-main tbody tr').each(function(i, obj) {
        var height = obj.getBoundingClientRect().height;

        $('.table-fixed-left tbody tr').eq(i).outerHeight(height);
        $('.table-fixed-right tbody tr').eq(i).outerHeight(height);
    });

    if ($('.table-main').width() >= $('.table-main').prop('scrollWidth')) {
        $('.table-fixed').hide();
    }

    $('.table-wrap tbody tr').on('mouseover', function () {
        var index = $(this).index();

        $('.table-main tbody tr').eq(index).addClass('active');
        $('.table-fixed-left tbody tr').eq(index).addClass('active');
        $('.table-fixed-right tbody tr').eq(index).addClass('active');
    });

    $('.table-wrap tbody tr').on('mouseout', function () {
        var index = $(this).index();

        $('.table-main tbody tr').eq(index).removeClass('active');
        $('.table-fixed-left tbody tr').eq(index).removeClass('active');
        $('.table-fixed-right tbody tr').eq(index).removeClass('active');
    });

    $('.<?php echo e($rowName, false); ?>-checkbox').iCheck({checkboxClass:'icheckbox_minimal-blue'}).on('ifChanged', function () {

        var id = $(this).data('id');
        var index = $(this).closest('tr').index();

        if (this.checked) {
        $.admin.grid.select(id);
            $('.table-main tbody tr').eq(index).css('background-color', '#ffffd5');
            $('.table-fixed-left tbody tr').eq(index).css('background-color', '#ffffd5');
            $('.table-fixed-right tbody tr').eq(index).css('background-color', '#ffffd5');
        } else {
        $.admin.grid.unselect(id);
            $('.table-main tbody tr').eq(index).css('background-color', '');
            $('.table-fixed-left tbody tr').eq(index).css('background-color', '');
            $('.table-fixed-right tbody tr').eq(index).css('background-color', '');
        }
    }).on('ifClicked', function () {

        var id = $(this).data('id');

        if (this.checked) {
            $.admin.grid.unselect(id);
        } else {
            $.admin.grid.select(id);
        }

        var selected = $.admin.grid.selected().length;

        if (selected > 0) {
            $('.<?php echo e($allName, false); ?>-btn').show();
        } else {
            $('.<?php echo e($allName, false); ?>-btn').hide();
        }

        $('.<?php echo e($allName, false); ?>-btn .selected').html("<?php echo e(trans('admin.grid_items_selected'), false); ?>".replace('{n}', selected));
    });
</script>
<?php /**PATH /www/wwwroot/testfood.dbestech.com/vendor/encore/laravel-admin/src/../resources/views/grid/fixed-table.blade.php ENDPATH**/ ?>