<?php

namespace App\Admin\Controllers;

use App\Models\ArticleType;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Encore\Admin\Layout\Content;
use Encore\Admin\Tree;

class ArticleTypeController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Article Type';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
   /* protected function grid()
    {
        $grid = new Grid(new ArticleType());
        $grid->column('title', __('Title'));
        $grid->column('id', __('ID'));
        

        return $grid;
    } */
    
    public function index(Content $content){
        
        $tree = new Tree(new ArticleType);
        return $content->header('Article Category')->body($tree);
        
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(ArticleType::findOrFail($id));



        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new ArticleType());
        $form->select('parent_id')->options((new ArticleType())::selectOptions());
        $form->text('title')->required();
        $form->number('order')->default(0);    
        
        return $form;
    }
}
