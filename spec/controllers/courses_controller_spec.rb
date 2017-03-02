require 'rails_helper'

RSpec.describe CoursesController do
 let(:course){ create(:course)}
 let(:course1){ create(:course)}
 let(:course2){ create(:course)}
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'assigns @courses' do
      expect(assigns[:courses]).to eq([course1, course2])
    end

    it 'render template' do

      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { id: course.id }
    end
    it 'assigns @course' do



      expect(assigns[:course]).to eq(course)
    end

    it 'render template' do
      expect(response).to render_template('show')
    end
  end

  describe 'GET new'  do
    context "when user login" do
      let(:user){create(:user)}
      let(:course){build(:course)}
      before do
        sign_in user
        get :new
      end
      it 'assign @course' do

        expect(assigns(:course)).to be_a_new(Course)
      end

      it 'render template' do
        expect(response).to render_template('new')
      end
    end


    context "when user not login" do
      it "redirect_to new_uer_session_path" do

        get :new

        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'POST create' do
    let(:user){ create(:user)}
    before { sign_in user}
    context "when course doesn't have a title" do
      it 'doesen`t create a record ' do
        expect do
          post :create, params: { course: { description: 'bar' } }
        end.to change { Course.count }.by(0)
      end

      it 'renders a new template ' do
        post :create, params: { course: { description: 'bar' } }
        expect(response).to render_template('new')
      end
    end

    context 'when course has a title' do

      it 'creates a new course record' do
        expect do
          post :create, params: { course: attributes_for(:course) }
        end.to change { Course.count }.by(1)
      end

      it 'redirects to courses_path' do


        post :create, params: { course: attributes_for(:course) }

        expect(response).to redirect_to courses_path
      end

      it "create a course for user" do
        course = build(:course)

        post :create, params:{course: attributes_for(:course)}

        expect(Course.last.user).to eq(user)
      end
    end
  end

  describe 'GET edit' do

    before(:each) do
      get :edit, id: course.id
    end
    it 'assigns course' do

      expect(assigns[:course]).to eq(course)
    end

    it 'render template' do

      expect(response).to render_template('edit')
    end
  end

  describe 'PUT update' do

    context 'when couse has title' do
      before(:each) do
        put :update, params: { id: course.id, course: { title: 'foo',
                                              description: 'bar' } }
      end
      it 'assigns @course' do
        expect(assigns[:course]).to eq(course)
      end

      it 'changes value' do
        expect(assigns[:course].title).to eq('foo')
        expect(assigns[:course].description).to eq('bar')
      end

      it 'redirect_to course_path' do
        expect(response).to redirect_to course_path(course)
      end
    end

    context "when couse doesn't have title" do
      before(:each) do
        put :update, params: { id: course.id, course: { title: '', description: 'bar' } }
      end
      it "dosen't update a record" do
        expect(course.description).not_to eq('bar')
      end
      it 'renders edit template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destory' do
    it 'assigns @course' do


      delete :destroy, id: course.id

      expect(assigns[:course]).to eq(course)
    end

    it 'deletes a record' do
      course = create(:course)

      expect { delete:destroy, id: course.id }.to change { Course.count }.by(-1)
    end

    it 'redirects to courses_path' do
      course = create(:course)

      delete :destroy, id: course.id

      expect(response).to redirect_to courses_path
    end
  end
end
