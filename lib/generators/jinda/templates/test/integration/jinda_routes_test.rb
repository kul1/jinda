require 'test_helper'
class RegistrationRoutesTest < ActionController::TestCase

  test 'register user form route' do
    assert_routing '/identities/new', {controller: 'identities', action: 'new'}
    #assert_routing({path: '/identities/new', method: 'post'},{controller: 'identities', action: 'new'})
  end
  test 'Admin Jinda Pending' do
    assert_routing '/jinda/new', {controller: 'jinda', action: 'new'}
  end
  test 'Admin Jinda Pending redirecting to action pending' do
    assert_routing '/jinda/pending', {controller: 'jinda', action: 'pending'}
    #assert_routing {'/jinda/pending', method: 'post'},{controller: 'jinda', action: 'index'})
  end
  test 'jinda action init' do
  	assert_routing '/jinda/init', {controller: 'jinda', action:'init'}
  end
  test 'jinda action run' do
  	assert_routing '/jinda/run', {controller: 'jinda', action:'run'}
  end
  test 'jinda action run_form' do
  	assert_routing '/jinda/run_form', {controller: 'jinda', action:'run_form'}
  end
  test 'jinda action end_form' do
  	assert_routing '/jinda/end_form', {controller: 'jinda', action:'end_form'}
  end
  test 'post jinda action end_form' do
  	assert_routing({ path:'/jinda/end_form',method: :post},{controller: 'jinda', action:'end_form'})
  end  
  test 'jinda action run_do' do
  	assert_routing '/jinda/run_do', {controller: 'jinda', action:'run_do'}
  end  
  # test "redirect_to(:action=>\'run_#{@runseq.action}\', :id=>@xmain.id)" do
  # 	assert_select 'title', "Welcome to Rails Testing Guide"
  # end






end   