# Check out https://github.com/joshbuddy/http_router for more information on HttpRouter
HttpRouter.new do  
  add('/api').to(ApiAction)
  add('/router').to(RouterAction)
  add('/').to(HomeAction)  
end
