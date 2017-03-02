require 'rails_helper'

RSpec.describe CoursesController do
  describe "GET index" do
    it "assigns @courses" do
    course1 = create(:course)
    course2 = create(:course)
    get :index
    expect(assigns[:courses]).to eq([course1, course2])

    end

    it "render template" do
      course1 = create(:course)
      course2 = create(:course)
      get :index
      expect(response).to render_template("index")
    end
  end
  describe "GET show" do
    it "assigns @course" do
      course = create(:course)

      get :show, params: {id: course.id}

      expect(assigns[:course]).to eq(course)
    end

    it "render template" do
      course = create(:course)

      get :show, params: {id: course.id}

      expect(response).to render_template("show")
    end
  end

  describe "GET new" do
    it "assign @course" do
      course = build(:course)

      get :new

      expect(assigns(:course)).to be_a_new(Course)
    end

    it "render template" do
      course = build(:course)

      get :new

      expect(response).to render_template("new")
    end
  end

  describe 'POST create' do
    context "when course doesn't have a title" do
      it "doesen`t create a record " do
        expect do
          post :create, params: {course: {description: "bar"}}
        end.to change {Course.count}.by(0)
      end

      it "renders a new template " do


        post :create, params: {course: {description: "bar"}}

        expect(response).to render_template("new")
      end
  end

    context "when course has a title" do
      it "creates a new course record" do
        course = build(:course)
        expect do
          post :create, params: {course: attributes_for(:course)}
        end.to change {Course.count}.by(1)
      end

      it "redirects to courses_path" do
        course = build(:course)

        post :create, params:{course: attributes_for(:course)}

        expect(response).to redirect_to courses_path
      end
    end
  end

  describe "GET edit" do
    it "assigns course" do
      course = create(:course)

      get :edit, id: course.id

      expect(assigns[:course]).to eq(course)
    end

    it "render template" do
      course= create(:course)

      get :edit, id: course.id

      expect(response).to render_template("edit")
    end
  end

  describe "PUT update" do
    context "when couse has title" do
      it "assigns @course" do
        course = create(:course)

        put :update, params:{id: course.id, course:{title:"foo",
          description: "bar"}}

          expect(assigns[:course]).to eq(course)
      end

      it "changes value" do
        course = create(:course)

        put :update, params:{id: course.id, course:{title:"foo",
          description: "bar"}}

          expect(assigns[:course].title).to eq("foo")
          expect(assigns[:course].description).to eq("bar")
      end

      it "redirect_to course_path" do
        course = create(:course)

        put :update, params:{id: course.id, course:{title:"foo",
          description: "bar"}}

          expect(response).to redirect_to course_path(course)
      end
    end
    context "when couse doesn't have title" do
      it "dosen't update a record" do
        course = create(:course)

        put :update, params:{id: course.id, course:{title:"",description: "bar"}}

        expect(course.description).not_to eq("bar")
      end
      it "renders edit template" do
        course = create(:course)

        put :update, params:{id: course.id, course:{title:"", description: "bar"}}

        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destory" do
    it "assigns @course" do
      course = create(:course)

      delete :destroy, id: course.id

      expect(assigns[:course]).to eq(course)
    end

    it "deletes a record" do
      course = create(:course)

      expect {delete:destroy, id: course.id}.to change {Course.count}.by(-1)
    end

    it "redirects to courses_path" do
      course = create(:course)

      delete :destroy, id:course.id

      expect(response).to redirect_to courses_path
    end

  end
end
