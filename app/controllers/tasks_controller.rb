class TasksController < ApplicationController
    before_action :require_user_logged_in, only: [:index, :show]
    def index
        if logged_in?
            #@task = current_user.tasks.build  # form_with 用
            @tasks = current_user.task.order(id: :desc).page(params[:page])
        end
        #@tasks = Task.all
    end
    
    def show
        check_user
    end
    
    def new
        @task = Task.new
    end
    
    def create
        @task = current_user.task.build(task_params)
        
        if @task.save
            flash[:success] = 'Taskが正常に投稿されました'
            redirect_to @task
        else
            flash.now[:danger] = 'Taskが投稿されませんでした'
            render :new
        end
    end
    
    def edit
        check_user
    end
    
    def update
        check_user
        if @task.update(task_params)
            flash[:success] = 'Taskは正常に更新されました'
            redirect_to @task
        else
            flash.now[:danger] = 'Taskは更新されませんでした'
            render :edit
        end
    end
    
    def destroy
        check_user
        @task.destroy
        
        flash[:success] = 'Taskは正常に削除されました'
        redirect_to tasks_url
    end
    
    private
    
    #Strong Parameter
    def task_params
        params.require(:task).permit(:content, :status)
    end
    
    def check_user
        if current_user.task.find_by(id: params[:id])
            @task = current_user.task.find_by(id: params[:id])
        else
            redirect_to root_url
        end
    end
end