require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require './model.rb' #DataBase관련 파일 (model)

set :bind, '0.0.0.0'

enable :sessions # 내가 앱에서 세션을 활용할꺼야 (앱에서 세션을 사용하기 위해 추가해줘야 함)

get '/' do
  @questions = Question.all.reverse #=> 배열의 형태로 질문들이 저장되어있다. ["첫번째질문", "두번째 질문", ... ]

  erb :index
end

get '/ask' do
  Question.create(
    :name => params["name"],
    :content => params["question"]
  )

  redirect to '/'
end

get '/signup' do
  erb :signup
end

get '/register' do
  User.create(
    :email => params["email"],
    :password => params["password"]
  )

  redirect to '/'
end

get '/admin' do
  @users = User.all
  erb :admin
end

get '/login' do
  erb :login
end

# 로그인?
# 1. 로그인 하려고 하는 사람이 우리 회원인지 확인한다.
# => User 데이터베이스에 있는 아이디인지 확인 / 로그인 하려고하는 사람이 제출한 email이 User DB에 있는지 확인
# 2. 만약에 있으면,
# => 비밀번호를 확인한다. / 제출된 비번과 DB의 비번이 같은지 아닌지 확인
# 3. 만약에 비밀번호가 맞다면 로그인 시킨다.
# 4. 비밀번호가 틀리면
# => 다시 비밀번호를 입력하라고 한다.
# 5. 만약에 User DB에 입력한 email이 없으면 회원가입 페이지로 보낸다.

get '/login_session' do
  @messge = ""
  if User.first(:email => params["email"]) #날라온 이메일로 가입된 사람이 있는지 없는지 확인
    if User.first(:email => params["email"]).password == params["password"]
      session[:email] = params["email"] # User.first(:email => params["email"])도 됨.
      #session은 해시이다. 여기 안에는 {:email = > "asdf@asdf.com"} 이 들어있다.
      @message = "로그인이 되었습니다."
      redirect to '/'
    else
      @message = "비번이 틀렸어요." #이메일은 DB에 존재하지만 비밀번호가 다른경우
    end
  else
    @messge = "해당하는 이메일의 유저가 없습니다."
  end
end

get '/logout' do
  session.clear
  redirect to '/'
end
