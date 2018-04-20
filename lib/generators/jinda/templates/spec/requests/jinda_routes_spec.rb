require 'rails_helper'

RSpec.describe "route test", :type => :routing do

  it 'register user form route' do
    expect(:get => "/identities/new").to route_to(
    :controller => "identities",
    :action => "new"
    )
  end 

  it 'Admin Jinda Pending' do
    expect(:get => "/jinda/new").to route_to(
    :controller => "jinda",
    :action => "new"
    )
  end 

  it 'Admin Jinda Pending redirecting to action pending' do
    expect(:get => "/jinda/pending").to route_to(
    :controller => "jinda",
    :action => "pending"
    )
  end 

  it 'jinda action init' do
    expect(:get => "/jinda/init").to route_to(
    :controller => "jinda",
    :action => "init"
    )
  end 

  it 'jinda action run' do
    expect(:get => "/jinda/run").to route_to(
    :controller => "jinda",
    :action => "run"
    )
  end

  it 'jinda action run_form' do
    expect(:get => "/jinda/run_form").to route_to(
    :controller => "jinda",
    :action => "run_form"
    )
  end

  it 'jinda action end_form' do
    expect(:get => "/jinda/end_form").to route_to(
    :controller => "jinda",
    :action => "end_form"
    )
  end

  it 'jinda action end_form method post' do
    expect(:post => "/jinda/end_form").to route_to(
    :controller => "jinda",
    :action => "end_form"
    )
  end
 
  it 'jinda action run_do' do
    expect(:get => "/jinda/run_do").to route_to(
    :controller => "jinda",
    :action => "run_do"
    )
  end

  it 'jinda action logs' do
    expect(:get => "/jinda/logs").to route_to(
    :controller => "jinda",
    :action => "logs"
    )
  end

  it 'jinda action doc' do
    expect(:get => "/jinda/doc").to route_to(
    :controller => "jinda",
    :action => "doc"
    )
  end

end