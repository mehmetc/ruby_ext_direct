class HomeAction < Cramp::Action
  use_fiber_pool do |pool|
    # Checkin database connection after each callback
    pool.generic_callbacks << proc { ActiveRecord::Base.clear_active_connections! }
  end

  def start
    render "Hello World!"
    finish
  end
end
