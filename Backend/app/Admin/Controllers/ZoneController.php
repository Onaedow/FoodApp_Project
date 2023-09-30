<?php

namespace App\Admin\Controllers;

use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use App\Models\Zone;


use Encore\Admin\Layout\Content;


class ZoneController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Zone';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Zone());

        $grid->column('id', __('Id'));
        $grid->column('name', __('Name'));
        $grid->column('coordinates', __('Coordinates'))->limit(50);
        $grid->column('status', __('Status'))->switch();
        $grid->column('restaurant_wise_topic', __('Restaurant_wise_topic'));
        $grid->column('customer_wise_topic', __('Customer_wise_topic'));
        $grid->column('deliveryman_wise_topic', __('Deliveryman_wise_topic'));
        $grid->column('created_at', __('Created_at'));
        $grid->column('updated_at', __('Updated_at'));

        return $grid;
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(Zone::findOrFail($id));
        $show->field('id', __('Id'));
        $show->field('name', __('Name'));


        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Zone());
        $form->text('name', __('Name'));
      //  $form->textarea('coordinates', __('Coordinates'));
        $form->zonecontent('coordinates', __('Coordinates'));
        $form->switch('status', __('Status'));
        $form->text('restaurant_wise_topic', __('Restaurant_wise_topic'));
        $form->text('customer_wise_topic', __('Customer_wise_topic'));
        $form->text('deliveryman_wise_topic', __('Deliveryman_wise_topic'));
        return $form;
    }
}
